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

// ace_ccu_core: main block for handling snoop requests

module ace_ccu_core
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


// signals into the ccu_muxes
slv_req_t  [Cfg.NoSlvPorts-1:0]          ccu_reqs_i;   
slv_resp_t [Cfg.NoSlvPorts-1:0]          ccu_resps_o;

// signals from the CCU
slv_req_t                                ccu_req_o;   
slv_resp_t                               ccu_resp_i;




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
  .NoSlvPorts    ( Cfg.NoSlvPorts         ), 
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
  .slv_reqs_i  ( ccu_reqs_i         ),
  .slv_resps_o ( ccu_resps_o        ),
  .mst_req_o   ( ccu_req_o          ),
  .mst_resp_i  ( ccu_resp_i         )
);

  
endmodule
