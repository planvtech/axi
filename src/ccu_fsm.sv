module ccu_fsm import ace_pkg::*; import snoop_pkg::*; 
#(
    parameter type mst_req_t            = logic,
    parameter type mst_resp_t           = logic,
    parameter type snoop_req_t          = logic,
    parameter type snoop_resp_t         = logic

) (  
    //clock and reset 
    input                               clk_i,
    input                               rst_ni,
    // Transaction type
    input ace_pkg::ace_trs_t            ace_trs,
    // Demux Request In and response out 
    input  mst_req_t                    m_req_i,
    output mst_resp_t                   m_resp_o,
    //CCU Request Out and response in 
    output mst_req_t                    ccu_req_o,
    output mst_resp_t                   ccu_resp_i,
    // Snoop channel resuest and response
    output snoop_req_t                  s2m_req_o,
    input  snoop_req_t                  m2s_resp_i
);

    enum logic [2:0] {IDLE, SEDN_READ, SEND_INVALID, WAIT_RESP, 
                SEND_ACK, READ_MEM, SEND_DATA} state_d, state_q;

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
            if(ace_trs == C_UNIQUE) begin
                state_d = SEND_INVALID;
            end else if( ace_trs == R_ONCE || ace_trs == R_SHARED) begin
                state_d = SEDN_READ;
            end else begin
                state_d = IDLE;
            end
        end

        SEND_INVALID: begin
            state_d = WAIT_RESP;
        end

        SEND_READ: begin
            state_d = WAIT_RESP;
        end

        WAIT_RESP: begin
            // wait for CR Valid from master 
            if (m2s_resp_i.cr_valid != 1'b1) begin
                state_d = WAIT_RESP;
            end else begin
                // if CLEANUNIQUE respond to master by sending ack
                if(ace_trs == C_UNIQUE) begin
                    state_d = SEND_ACK;
                end else begin
                // for read transactions     
                    if(m2s_resp_i.cr.resp[0]) begin : data_available
                        // if data available send data else fetch from AXI slave (READ_MEM)
                        state_d = SEND_DATA;
                    end else begin : data_not_available
                        state_d = READ_MEM;
                    end
                end
            end
        end
                    
        SEND_ACK: begin
            state_d = IDLE;
        end

        SEND_DATA: begin
            state_d =IDLE;
        end

        READ_MEM: begin
            if(ccu_resp_i.r_valid) begin
                state_d = SEND_DATA;
            end else begin
                state_d = READ_MEM;
            end
        end        
        endcase
    end

    /// Output block
    always_ff @(posedge clk_i) begin: ccu_output
        case(state_q) 
        IDLE:begin
            s2m_req_o.ac_valid      <= 'b0;
            s2m_req_o.ac.addr       <= 'b0;
            s2m_req_o.ac.acsnoop    <= 'b0;
            s2m_req_o.ac.acprot     <= 'b0;
        end
        SEND_INVALID:begin
            s2m_req_o.ac_valid      <= 'b1;
            s2m_req_o.ac.addr       <= m_req_i.aw.addr;
            s2m_req_o.ac.acsnoop    <= 'b1001;
            s2m_req_o.ac.acprot     <= m_req_i.aw.prot;
        end
        SEND_READ:begin
            s2m_req_o.ac_valid      <= 'b1;
            s2m_req_o.ac.addr       <= m_req_i.ar.addr;
            s2m_req_o.ac.acsnoop    <= m_req_i.ar.arsnoop;
            s2m_req_o.ac.acprot     <= m_req_i.ar.prot;
        end
        WAIT_RESP:begin
            s2m_req_o.ac_valid      <= 'b1;
            s2m_req_o.ac.addr       <= s2m_req_o.ac.addr;
            s2m_req_o.ac.acsnoop    <= s2m_req_o.ac.acsnoop;
            s2m_req_o.ac.acprot     <= s2m_req_o.ac.acprot;
        end 
        default:begin
            s2m_req_o.ac_valid      <= 'b0;
            s2m_req_o.ac.addr       <= 'b0;
            s2m_req_o.ac.acsnoop    <= 'b0;
            s2m_req_o.ac.acprot     <= 'b0;
        end
        endcase
    end 

endmodule 