`include "ace/assign.svh"
`include "ace/typedef.svh"

module ccu_fsm  
#(
    parameter int  NoMstPorts           = 4,
    parameter type mst_req_t            = logic,
    parameter type mst_resp_t           = logic,
    parameter type snoop_req_t          = logic,
    parameter type snoop_resp_t         = logic

) (  
    //clock and reset 
    input                               clk_i,
    input                               rst_ni,
    // CCU Request In and response out 
    input  mst_req_t                    ccu_req_i,
    output mst_resp_t                   ccu_resp_o,
    //CCU Request Out and response in 
    output mst_req_t                    ccu_req_o,
    input  mst_resp_t                   ccu_resp_i,
    // Snoop channel resuest and response
    output snoop_req_t                   s2m_req_o,
    input  snoop_resp_t [NoMstPorts-1:0] m2s_resp_i
);

    enum logic [3:0] {IDLE, DECODE,
                      SEND_READ, WAIT_RESP_R, SEND_DATA, SEND_AXI_REQ, READ_MEM,
                      SEND_INVALID, WAIT_RESP_W, SEND_ACK 
                     } state_d, state_q;

    // snoop resoponse valid
    logic [NoMstPorts-1:0] mst_resp_cr_valid;
    // check for availablilty of data
    logic [NoMstPorts-1:0] data_available;
    // snoop channel ac received by master
    logic [NoMstPorts-1:0] mst_resp_ac_ready;
    // temp request holder
    mst_req_t              ccu_req_holder; 


    // stack snoop reponse valids and data_available
    for (genvar i = 0; i < NoMstPorts; i++) begin : stack_cr_valid
        assign mst_resp_cr_valid[i] = 1'b1;//m2s_resp_i[i].cr_valid;
        assign data_available[i]    = 1'b0;//m2s_resp_i[i].cr_resp[0];
        assign mst_resp_ac_ready[i] = 1'b0;//m2s_resp_i[i].ac_ready;
    end 


    /// Present state block
    always_ff @(posedge clk_i, negedge rst_ni) begin : ccu_present_state
        if(!rst_ni) begin
            state_q <= IDLE;
        end else begin
            state_q <= state_d;
        end
    end

    /// next_state block
    always_comb begin : ccu_state_ctrl
        case(state_q)
        IDLE: begin
            if(ccu_req_i.ar_valid ) begin
                state_d = DECODE;                   
            end else if (ccu_req_i.aw_valid) begin
                state_d = SEND_INVALID;
            end else begin
                state_d = IDLE;
            end
        end

        // determine if transaction is type of Read or clean-Invalid
        DECODE: begin
            $display("DECODE");
            if(ccu_req_holder.ar.snoop !='b1011) begin
                state_d = SEND_READ;
            end else begin
                state_d = SEND_INVALID;
            end
        end

        SEND_READ: begin
            $display("SEND_READ");
			// wait for all snoop masters to de-assert AC ready 
            if (mst_resp_ac_ready != 'b0) begin
                state_d = SEND_READ;
            end else begin
                state_d = WAIT_RESP_R;
            end
        end
 
        WAIT_RESP_R: begin
            $display("WAIT_RESP_R %b", mst_resp_cr_valid);
            // wait for all snoop masters to assert CR valid 
            if (mst_resp_cr_valid != 'b1) begin
                state_d = WAIT_RESP_R;
            end else if(data_available != 0) begin
                state_d = SEND_DATA;
            end else begin
                state_d = SEND_AXI_REQ;
            end
        end

        SEND_DATA: begin
            $display("SEND_DATA");
			// wait for initiating master to de-assert r_ready
            if(ccu_req_i.r_ready != 'b0) begin
                state_d = SEND_DATA;
            end else begin
                state_d = IDLE;
            end
        end

        SEND_AXI_REQ: begin
            $display("SEND_AXI_REQ");
			// wait for responding slave to de-assert ar_ready
            if(ccu_resp_i.ar_ready !='b0) begin
                state_d = SEND_AXI_REQ;
            end else begin
                state_d = READ_MEM;
            end
        end
		
		READ_MEM: begin
            $display("READ_MEM");
			// wait for responding slave to assert r_valid
            if(ccu_resp_i.r_valid) begin
                state_d = IDLE;
            end else begin
                state_d = READ_MEM;
            end
        end  
		
        SEND_INVALID: begin
            $display("SEND_INVALID");
			// wait for all snoop masters to de-assert AC ready 
            if (mst_resp_ac_ready != 'b0) begin
                state_d = SEND_INVALID;
            end else begin
                state_d = WAIT_RESP_W;
            end
        end

        WAIT_RESP_W: begin
            $display("WAIT_RESP_W %b", mst_resp_cr_valid);
            // wait for all snoop masters to assert CR valid 
            if (mst_resp_cr_valid != '1) begin
                state_d = WAIT_RESP_W;
            end else begin
                state_d = SEND_ACK;
            end
        end

        SEND_ACK: begin
            $display("SEND_ACK");
            state_d = IDLE;
        end

    endcase
    end

// output block
always_comb begin : ccu_output_block
    case(state_q) 
    IDLE: begin
        ccu_req_o           =   'b0;
        ccu_resp_o          =   'b0;
        s2m_req_o           =   'b0;
        ccu_resp_o.ar_ready =   'b1;
        ccu_resp_o.aw_ready =   'b1;
        ccu_resp_o.w_ready  =   'b1;
    end

    DECODE: begin
        ccu_req_o           =   'b0;
        ccu_resp_o          =   'b0;
        s2m_req_o           =   'b0;
    end

    SEND_READ: begin
        ccu_req_o           =   'b0;
        ccu_resp_o          =   'b0;
        // send request to snooping masters
        s2m_req_o.ac.addr   =   ccu_req_holder.ar.addr;
        s2m_req_o.ac.prot   =   ccu_req_holder.ar.prot;
        s2m_req_o.ac.snoop  =   ccu_req_holder.ar.snoop;
        s2m_req_o.ac_valid  =   'b1;
        s2m_req_o.cd_ready  =   'b1;
        s2m_req_o.cr_ready  =   'b1;
    end

    WAIT_RESP_R:
    WAIT_RESP_W:
     begin
        ccu_req_o           =   'b0;
        ccu_resp_o          =   'b0;
        s2m_req_o           =   'b0;
        s2m_req_o.cd_ready  =   'b1;
        s2m_req_o.cr_ready  =   'b1;
    end

    SEND_DATA: begin
        ccu_req_o           =   'b0;
        s2m_req_o           =   'b0;
        // response to intiating master
        ccu_resp_o.aw_ready =   'b1;
        ccu_resp_o.ar_ready =   'b1;
        ccu_resp_o.w_ready  =   'b1;
        ccu_resp_o.b_valid  =   'b0;
        ccu_resp_o.b        =   'b0;
        ccu_resp_o.r_valid  =   'b1;
        ccu_resp_o.r.id     =   ccu_req_holder.ar.id;
        ccu_resp_o.r.data   =   m2s_resp_i[0].cd.data;
        ccu_resp_o.r.resp   =   'b0;
        ccu_resp_o.r.last   =   m2s_resp_i[0].cd.last;
        ccu_resp_o.r.user   =   ccu_req_holder.ar.user;
    end

    SEND_AXI_REQ: begin
        s2m_req_o           =   'b0;
        ccu_resp_o          =   'b0;
        // forward request to slave (RAM)
        ccu_req_o.ar_valid  =   1'b1;
        ccu_req_o.ar        =   ccu_req_holder.ar;
        ccu_req_o.aw_valid  =   1'b0;
        ccu_req_o.aw        =   ccu_req_holder.aw;
        ccu_req_o.w_valid   =   1'b0;
        ccu_req_o.w         =   'b0;
        ccu_req_o.b_ready   =   'b1;
        ccu_req_o.r_ready   =   1'b1;
    end

    READ_MEM: begin
        s2m_req_o           =   'b0;
        ccu_req_o           =   'b0;
        // forward reponse from slave to intiating master
        ccu_resp_o.aw_ready =   'b1;
        ccu_resp_o.ar_ready =   'b1;
        ccu_resp_o.w_ready  =   'b1;
        ccu_resp_o.b_valid  =   'b0;
        ccu_resp_o.b        =   'b0;
        ccu_resp_o.r_valid  =   'b1;
        ccu_resp_o.r        =   ccu_resp_i.r;
    end

    SEND_INVALID:begin
        ccu_req_o           =   'b0;
        ccu_resp_o          =   'b0;
        s2m_req_o.ac.addr   =   ccu_req_holder.ar_valid ? ccu_req_holder.ar.addr : ccu_req_holder.aw.addr;
        s2m_req_o.ac.prot   =   ccu_req_holder.ar_valid ? ccu_req_holder.ar.prot : ccu_req_holder.aw.prot;
        s2m_req_o.ac.snoop  =   'b1001;
        s2m_req_o.ac_valid  =   'b1;
        s2m_req_o.cd_ready  =   'b1;
        s2m_req_o.cr_ready  =   'b1;
    end 

    SEND_ACK:begin
        s2m_req_o           =   'b0;
        ccu_req_o           =   'b0;
        // forward reponse from slave to intiating master
        ccu_resp_o.aw_ready =   'b1;
        ccu_resp_o.ar_ready =   'b1;
        ccu_resp_o.w_ready  =   'b1;
        ccu_resp_o.b_valid  =   ccu_req_holder.aw_valid;
        ccu_resp_o.b.id     =   ccu_req_holder.aw.id;
        ccu_resp_o.b.user   =   ccu_req_holder.aw.user;
        ccu_resp_o.b.resp   =   'b0;

        // ccu_resp_o.r_valid  =   'b0;
        // ccu_resp_o.r.id     =   ccu_req_holder.ar.id;
        // ccu_resp_o.r.user   =   ccu_req_holder.ar.user;
        // ccu_resp_o.r.last   =   1'b0;
        // ccu_resp_o.r.data   =   'hdeadbeef;
        // ccu_resp_o.r.resp   =   'b0;
    
    end 


    endcase
    end

// latch addresses from 
always_ff @(posedge clk_i , negedge rst_ni) begin
    if(!rst_ni) begin
        ccu_req_holder.ar <= 'b0;
        ccu_req_holder.aw <= 'b0;
    end else if(state_q == IDLE && (ccu_req_i.ar_valid | ccu_req_i.aw_valid)) begin
        `ACE_SET_AR_STRUCT(ccu_req_holder.ar, ccu_req_i.ar)
        `ACE_SET_AW_STRUCT(ccu_req_holder.aw, ccu_req_i.aw)
    end
end

endmodule 
