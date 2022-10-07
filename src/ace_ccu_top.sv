// Copyright (c) 2014-2018 ETH Zurich, University of Bologna
// Copyright (c) 2022 PlanV GmbH
//
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

// ace_ccu_top: Top level module for closely coupled cache coherency protocol

module ace_ccu_top
import cf_math_pkg::idx_width;
#(
  parameter axi_pkg::xbar_cfg_t Cfg                                   = '0,
  parameter bit  ATOPs                                                = 1'b1,
  parameter type slv_aw_chan_t                                        = logic,
  parameter type mst_aw_chan_t                                        = logic,
  parameter type w_chan_t                                             = logic,
  parameter type slv_b_chan_t                                         = logic,
  parameter type mst_b_chan_t                                         = logic,
  parameter type slv_ar_chan_t                                        = logic,
  parameter type mst_ar_chan_t                                        = logic,
  parameter type slv_r_chan_t                                         = logic,
  parameter type mst_r_chan_t                                         = logic,
  parameter type slv_req_t                                            = logic,
  parameter type slv_resp_t                                           = logic,
  parameter type mst_req_t                                            = logic,
  parameter type mst_resp_t                                           = logic
) (
  input  logic                                                          clk_i,
  input  logic                                                          rst_ni,
  input  logic                                                          test_i,
  input  slv_req_t  [Cfg.NoSlvPorts-1:0]                                slv_ports_req_i,
  output slv_resp_t [Cfg.NoSlvPorts-1:0]                                slv_ports_resp_o,
  output mst_req_t                                                      mst_ports_req_o,
  input  mst_resp_t                                                     mst_ports_resp_i
);

// signals from the ace_demuxes
slv_req_t  [Cfg.NoSlvPorts-1:0] [1:0] slv_reqs;   // one for non-shareable and one for shareable req
slv_resp_t [Cfg.NoSlvPorts-1:0] [1:0] slv_resps;
// signals into the ace_muxes
slv_req_t  [Cfg.NoSlvPorts:0]          mst_reqs;   // one extra port for CCU
slv_resp_t [Cfg.NoSlvPorts:0]          mst_resps;
// signals into the CCU
slv_req_t  [Cfg.NoSlvPorts-1:0]        ccu_reqs_i;   
slv_resp_t [Cfg.NoSlvPorts-1:0]        ccu_resps_o;
// signals from the CCU
slv_req_t                              ccu_reqs_o;   
slv_resp_t                             ccu_resps_i;



// selection lines for mux and demuxes
ace_pkg::snoop_trs_t [Cfg.NoSlvPorts-1:0]    slv_aw_select, slv_ar_select;


for (genvar i = 0; i < Cfg.NoSlvPorts; i++) begin : gen_slv_port_demux
    
    // routing of incoming request through transaction type    
    ace_trs_dec #(
      .slv_ace_req_t  (       slv_req_t        )
    ) i_ace_trs_dec (   
        .slv_reqs_i   (   slv_ports_req_i[i]   ),
        .snoop_aw_trs (   slv_aw_select[i]     ),
        .snoop_ar_trs (   slv_ar_select[i]     )
    );

    // demux
    axi_demux #(
      .AxiIdWidth     ( Cfg.AxiIdWidthSlvPorts ),  // ID Width
      .AtopSupport    ( ATOPs                  ),
      .aw_chan_t      ( slv_aw_chan_t          ),  // AW Channel Type
      .w_chan_t       ( w_chan_t               ),  //  W Channel Type
      .b_chan_t       ( slv_b_chan_t           ),  //  B Channel Type
      .ar_chan_t      ( slv_ar_chan_t          ),  // AR Channel Type
      .r_chan_t       ( slv_r_chan_t           ),  //  R Channel Type
      .axi_req_t      ( slv_req_t              ),
      .axi_resp_t     ( slv_resp_t             ),
      .NoMstPorts     ( 2                      ),  // one for CCU module and one for mux
      .MaxTrans       ( Cfg.MaxMstTrans        ),
      .AxiLookBits    ( Cfg.AxiIdUsedSlvPorts  ),
      .UniqueIds      ( Cfg.UniqueIds          ),
      //.FallThrough    ( Cfg.FallThrough        ),
      .SpillAw        ( Cfg.LatencyMode[9]     ),
      .SpillW         ( Cfg.LatencyMode[8]     ),
      .SpillB         ( Cfg.LatencyMode[7]     ),
      .SpillAr        ( Cfg.LatencyMode[6]     ),
      .SpillR         ( Cfg.LatencyMode[5]     )
    ) i_axi_demux (
      .clk_i,   // Clock
      .rst_ni,  // Asynchronous reset active low
      .test_i,  // Testmode enable
      .slv_req_i       ( slv_ports_req_i[i]  ),
      .slv_aw_select_i ( slv_aw_select       ),
      .slv_ar_select_i ( slv_ar_select       ),
      .slv_resp_o      ( slv_ports_resp_o[i] ),
      .mst_reqs_o      ( slv_reqs[i]         ),
      .mst_resps_i     ( slv_resps[i]        )
    );
end

axi_mux #(
  .SlvAxiIDWidth ( Cfg.AxiIdWidthSlvPorts ), // ID width of the slave ports
  .slv_aw_chan_t ( slv_aw_chan_t          ), // AW Channel Type, slave ports
  .mst_aw_chan_t ( mst_aw_chan_t          ), // AW Channel Type, master port
  .w_chan_t      ( w_chan_t               ), //  W Channel Type, all ports
  .slv_b_chan_t  ( slv_b_chan_t           ), //  B Channel Type, slave ports
  .mst_b_chan_t  ( mst_b_chan_t           ), //  B Channel Type, master port
  .slv_ar_chan_t ( slv_ar_chan_t          ), // AR Channel Type, slave ports
  .mst_ar_chan_t ( mst_ar_chan_t          ), // AR Channel Type, master port
  .slv_r_chan_t  ( slv_r_chan_t           ), //  R Channel Type, slave ports
  .mst_r_chan_t  ( mst_r_chan_t           ), //  R Channel Type, master port
  .slv_req_t     ( slv_req_t              ),
  .slv_resp_t    ( slv_resp_t             ),
  .mst_req_t     ( mst_req_t              ),
  .mst_resp_t    ( mst_resp_t             ),
  .NoSlvPorts    ( Cfg.NoSlvPorts+1       ), // Number of Masters for the module
  .MaxWTrans     ( Cfg.MaxSlvTrans        ),
  .FallThrough   ( Cfg.FallThrough        ),
  .SpillAw       ( Cfg.LatencyMode[4]     ),
  .SpillW        ( Cfg.LatencyMode[3]     ),
  .SpillB        ( Cfg.LatencyMode[2]     ),
  .SpillAr       ( Cfg.LatencyMode[1]     ),
  .SpillR        ( Cfg.LatencyMode[0]     )
) i_axi_mux (
  .clk_i,   // Clock
  .rst_ni,  // Asynchronous reset active low
  .test_i,  // Test Mode enable
  .slv_reqs_i  ( mst_reqs         ),
  .slv_resps_o ( mst_resps        ),
  .mst_req_o   ( mst_ports_req_o  ),
  .mst_resp_i  ( mst_ports_resp_i )
);
// connection reqs and resps for non-shareable tarnsactions with axi_mux
for (genvar i = 0; i < Cfg.NoSlvPorts; i++) begin : gen_non_shared_conn
    assign mst_reqs[i]  = slv_reqs[i][0];
    assign slv_resps[i][0] = mst_resps[i];
end    

// connection reqs and resps for shareable transactions with CCU 
for (genvar i = 0; i < Cfg.NoSlvPorts; i++) begin : gen_shared_conn
    assign ccu_reqs_i[i]  = slv_reqs[i][1];
    assign slv_resps[i][1] = ccu_resps_o[i] ;
end  

// Temporary solution it will stuck after few transactions due to ID clashes
assign ccu_reqs_o     = ccu_reqs_i[0];
assign ccu_resps_o[0] = ccu_resps_i;

 
// connect CCU reqs and resps to mux  
assign mst_reqs[Cfg.NoSlvPorts]     = ccu_reqs_o;
assign ccu_resps_i                  = mst_resps[Cfg.NoSlvPorts];
  
endmodule