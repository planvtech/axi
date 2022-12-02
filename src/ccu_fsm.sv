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
    output snoop_req_t  [NoMstPorts-1:0] s2m_req_o,
    input  snoop_resp_t [NoMstPorts-1:0] m2s_resp_i
);

    enum logic [4:0] {  IDLE,           //0
                        DECODE_R,       //1 
                        SEND_INVALID_R, //2 
                        SEND_READ,      //3
                        WAIT_RESP_R,    //4   
                        READ_SNP_DATA,  //5
                        SEND_DATA,      //6
                        SEND_CD_READY,
                        SEND_AXI_REQ_R, //7
                        READ_MEM,       //8
                        WAIT_INVALID_R, //9
                        SEND_ACK_I_R,   //10                       
                        DECODE_W,       //11
                        SEND_INVALID_W, //12
                        WAIT_RESP_W,    //13 
                        SEND_AXI_REQ_W, //14
                        WRITE_MEM       //15

                    } state_d, state_q;
    
    // snoop resoponse valid
    logic [NoMstPorts-1:0]          cr_valid;
    // snoop channel ac valid
    logic [NoMstPorts-1:0]          ac_valid;
    // snoop channel ac ready
    logic [NoMstPorts-1:0]          ac_ready;
    // snoop channel cd last 
    logic [NoMstPorts-1:0]          cd_last;
    // check for availablilty of data
    logic [NoMstPorts-1:0]          data_available;
    // check for response error
    logic [NoMstPorts-1:0]          response_error;
    // check for data received
    logic [NoMstPorts-1:0]          data_received;
    // check for shared in cr_resp
    logic [NoMstPorts-1:0]          shared;
    // check for dirty in cr_resp
    logic [NoMstPorts-1:0]          dirty;
    // request holder
    mst_req_t                       ccu_req_holder; 
    // response holder
    mst_resp_t                      ccu_resp_holder;
    // snoop response holder
    snoop_resp_t [NoMstPorts-1:0]   m2s_resp_holder;


    // ----------------------
    // Current State Block
    // ----------------------
    always_ff @(posedge clk_i, negedge rst_ni) begin : ccu_present_state
        if(!rst_ni) begin
            state_q <= IDLE;
        end else begin
            state_q <= state_d;
        end
    end

    // ----------------------
    // Next State Block
    // ----------------------
    always_comb begin : ccu_state_ctrl
       
        state_d = state_q;
     
        case(state_q)
        
        IDLE: begin
            //  wait for incoming valid request from master 
            if(ccu_req_i.ar_valid ) begin
                state_d = DECODE_R;              
            end else if(ccu_req_i.aw_valid) begin
                state_d = DECODE_W;
            end else begin
                state_d = IDLE;
            end
        end

        //--------------------- 
        //---- Read Branch ----
        //---------------------         
        DECODE_R: begin       
            //check read transaction type
            if(ccu_req_holder.ar.snoop != snoop_pkg::CLEAN_UNIQUE) begin   // check if CleanUnique then send Invalidate 
              state_d = SEND_READ;
            end else begin
                state_d = SEND_INVALID_R;
            end
        end

        SEND_INVALID_R: begin
            // wait for all snoop masters to assert AC ready 
            if (ac_ready != '1) begin
                state_d = SEND_INVALID_R;
            end else begin
                state_d = WAIT_INVALID_R;
            end
        end

        WAIT_INVALID_R: begin
            // wait for all snoop masters to assert CR valid 
            if (cr_valid != '1) begin
                state_d = WAIT_INVALID_R;
            end else begin
                state_d = SEND_ACK_I_R;
            end
        end

        SEND_READ: begin
            // wait for all snoop masters to de-assert AC ready 
            if (ac_ready != '1) begin
                state_d = SEND_READ;
            end else begin
                state_d = WAIT_RESP_R;
            end
        end

        WAIT_RESP_R: begin
            // wait for all snoop masters to assert CR valid 
            if (cr_valid != '1) begin
                state_d = WAIT_RESP_R;
            end else if(data_available != '0 && response_error == '0 ) begin
                state_d = READ_SNP_DATA;
            end else begin
                state_d = SEND_AXI_REQ_R;
            end
        end

        READ_SNP_DATA: begin
            if(data_available != data_received) begin
                state_d = READ_SNP_DATA;
            end else begin
                state_d = SEND_DATA;
            end
        end

        SEND_DATA: begin
            // wait for initiating master to assert r_ready
            if(ccu_req_i.r_ready != 'b0) begin
               state_d = SEND_CD_READY;
            end else begin
                state_d = SEND_DATA;
            end
        end

       SEND_CD_READY:begin
            if(cd_last == data_available) begin 
                    state_d = IDLE;
            end else begin 
                    state_d = READ_SNP_DATA;
            end
        end

        SEND_AXI_REQ_R: begin
            // wait for responding slave to assert ar_ready
            if(ccu_resp_i.ar_ready !='b1) begin
                state_d = SEND_AXI_REQ_R;
            end else begin
                state_d = READ_MEM;
            end
        end
        
        READ_MEM: begin
            // wait for responding slave to assert r_valid
            if(ccu_resp_i.r_valid && ccu_req_i.r_ready) begin
                if(ccu_resp_i.r.last) begin
                    state_d = IDLE;
                end else begin
                    state_d = READ_MEM;
                end
            end else begin
                state_d = READ_MEM;
            end
        end         

        SEND_ACK_I_R: begin
            if( ccu_req_i.r_ready ) begin
                state_d = IDLE;
            end else begin
                state_d = SEND_ACK_I_R;
            end
        end

        //--------------------- 
        //---- Write Branch ---
        //--------------------- 

        DECODE_W: begin  
            state_d = SEND_INVALID_W;
        end

        SEND_INVALID_W: begin
            // wait for all snoop masters to assert AC ready 
            if (ac_ready != '1) begin
                state_d = SEND_INVALID_W;
            end else begin
                state_d = WAIT_RESP_W;
            end
        end

        WAIT_RESP_W: begin
            // wait for all snoop masters to assert CR valid 
            if (cr_valid != '1 ) begin
                state_d = WAIT_RESP_W;
            end else begin
                state_d = SEND_AXI_REQ_W;
            end
        end

        SEND_AXI_REQ_W: begin
            // wait for responding slave to assert aw_ready
            if(ccu_resp_i.aw_ready !='b1) begin
                state_d = SEND_AXI_REQ_W;
            end else begin
                state_d = WRITE_MEM;
            end
        end

        WRITE_MEM: begin
            // wait for responding slave to send b_valid
            if((ccu_resp_i.b_valid && ccu_req_i.b_ready)) begin
                  if(ccu_req_holder.aw.atop [5]) begin
                    state_d = READ_MEM;
                  end else begin
                    state_d = IDLE;
                  end
            end else begin
                state_d = WRITE_MEM;
            end
        end

        default: state_d = IDLE;


    endcase
    end

    // ----------------------
    // Output Block
    // ----------------------
    always_comb begin : ccu_output_block
        
        // Default Assignments
        ccu_req_o           =   '0;
        ccu_resp_o          =   '0;
        s2m_req_o           =   '0;

        case(state_q) 
        IDLE: begin

        end

        //--------------------- 
        //---- Read Branch ----
        //--------------------- 
        DECODE_R:begin
            ccu_resp_o.ar_ready =   'b1;
        end
        SEND_READ: begin
            // send request to snooping masters
            for (int unsigned n = 0; n < NoMstPorts; n = n + 1) begin
                s2m_req_o[n].ac.addr   =   ccu_req_holder.ar.addr;
                s2m_req_o[n].ac.prot   =   ccu_req_holder.ar.prot;
                s2m_req_o[n].ac.snoop  =   ccu_req_holder.ar.snoop;
                if(ac_ready[n] && ac_valid[n])
                    s2m_req_o[n].ac_valid  =   'b0;
                else
                    s2m_req_o[n].ac_valid  =   'b1;
            end
        end

        SEND_INVALID_R:begin
            for (int unsigned n = 0; n < NoMstPorts; n = n + 1) begin
                s2m_req_o[n].ac.addr   =   ccu_req_holder.ar.addr;
                s2m_req_o[n].ac.prot   =   ccu_req_holder.ar.prot;
                s2m_req_o[n].ac.snoop  =   'b1001;
                if(ac_ready[n] && ac_valid[n])
                    s2m_req_o[n].ac_valid  =   'b0;
                else
                    s2m_req_o[n].ac_valid  =   'b1;
            end       
        end 
        
        WAIT_RESP_R, WAIT_RESP_W, WAIT_INVALID_R: begin
            for (int unsigned n = 0; n < NoMstPorts; n = n + 1) 
                s2m_req_o[n].cr_ready  =   'b1;
        end

        READ_SNP_DATA: begin
        end

        SEND_DATA: begin
            // response to intiating master
            for (int unsigned n = 0; n < NoMstPorts; n = n + 1)
                if (data_available[n]) begin
                    ccu_resp_o.r.data   =   m2s_resp_holder[n].cd.data;
                    ccu_resp_o.r.last   =   m2s_resp_holder[n].cd.last;
                    ccu_resp_o.r_valid  =   m2s_resp_holder[n].cd_valid;
                end
            ccu_resp_o.r.id         =   ccu_req_holder.ar.id;
            ccu_resp_o.r.resp[3]    =   |shared;                // update if shared
            ccu_resp_o.r.resp[2]    =   |dirty;                 // update if any line dirty
        end
        SEND_CD_READY: begin
            for (int unsigned n = 0; n < NoMstPorts; n = n + 1) 
                s2m_req_o[n].cd_ready  =   'b1;
        end

        SEND_AXI_REQ_R: begin
            // forward request to slave (RAM)
            ccu_req_o.ar_valid  =   'b1;
            ccu_req_o.ar        =   ccu_req_holder.ar;
            ccu_req_o.r_ready   =   ccu_req_holder.r_ready ; 
        end

        READ_MEM: begin
            // indicate slave to send data on r channel 
            ccu_req_o.r_ready   =   ccu_req_i.r_ready ;
            ccu_resp_o.r        =   ccu_resp_i.r;  
            ccu_resp_o.r_valid  =   ccu_resp_i.r_valid; 
        end

        SEND_ACK_I_R:begin
            // forward reponse from slave to intiating master
            ccu_resp_o.r        =   '0;  
            ccu_resp_o.r.id     =   ccu_req_holder.ar.id;
            ccu_resp_o.r.last   =   'b1; 
            ccu_resp_o.r_valid  =   'b1;  
        end 

        //--------------------- 
        //---- Write Branch ---
        //---------------------    
        DECODE_W: begin
            ccu_resp_o.aw_ready =   'b1;
        end

        SEND_INVALID_W:begin
            for (int unsigned n = 0; n < NoMstPorts; n = n + 1) begin
                s2m_req_o[n].ac.addr   =   ccu_req_holder.ar.addr;
                s2m_req_o[n].ac.prot   =   ccu_req_holder.ar.prot;
                s2m_req_o[n].ac.snoop  =   'b1001;
                if(ac_ready[n] && ac_valid[n])
                    s2m_req_o[n].ac_valid  =   'b0;
                else
                    s2m_req_o[n].ac_valid  =   'b1;
            end         
        end 

        SEND_AXI_REQ_W: begin
            // forward request to slave (RAM)
            ccu_req_o.aw_valid  =    'b1;
            ccu_req_o.aw        =    ccu_req_holder.aw; 
        end

        WRITE_MEM: begin
            ccu_req_o.w         =  ccu_req_i.w;
            ccu_req_o.w_valid   =  ccu_req_i.w_valid;
            ccu_req_o.b_ready   =  ccu_req_i.b_ready; 

            ccu_resp_o.b        =  ccu_resp_i.b;
            ccu_resp_o.b_valid  =  ccu_resp_i.b_valid;
            ccu_resp_o.w_ready  =  ccu_resp_i.w_ready;

        end
        endcase
    end // end output block

    // Hold incoming ACE request 
    always_ff @(posedge clk_i , negedge rst_ni) begin
        if(!rst_ni) begin
            ccu_req_holder <= '0;
        end else if(state_q == IDLE && ccu_req_i.ar_valid  ) begin
            ccu_req_holder.ar 	    <=  ccu_req_i.ar;
            ccu_req_holder.ar_valid <=  ccu_req_i.ar_valid;
            ccu_req_holder.r_ready 	<=  ccu_req_i.r_ready;
            
        end  else if(state_q == IDLE &&  ccu_req_i.aw_valid) begin
            ccu_req_holder.aw 	    <=  ccu_req_i.aw;
            ccu_req_holder.aw_valid <=  ccu_req_i.aw_valid;
        end  
    end


    // Hold snoop AC_ready
    for (genvar n = 0; n < NoMstPorts; n = n + 1) begin: hold_ac_ready
        always_ff @ (posedge clk_i, negedge rst_ni) begin
            if(!rst_ni) begin
                ac_ready[n]         <= 'b0;
                ac_valid[n]         <= 'b0;
            end else if(((state_q == SEND_READ || state_q == SEND_INVALID_R || state_q == SEND_INVALID_W) && (m2s_resp_i[n].ac_ready) ) ) begin
                ac_ready[n]         <= m2s_resp_i[n].ac_ready; 
                ac_valid[n]         <= s2m_req_o[n].ac_valid; 
            end else if(state_q == IDLE) begin
                ac_ready[n]         <= 'b0; 
                ac_valid[n]         <= 'b0;
            end 
        end 
    end
    

    // Hold snoop CR 
    for (genvar i = 0; i < NoMstPorts; i = i + 1) begin: hold_snoop_response
        always_ff @ (posedge clk_i, negedge rst_ni) begin
            if(!rst_ni) begin
                cr_valid[i]         <= 'b0;
                data_available[i]   <= 'b0;
                shared[i]           <= 'b0;
                dirty[i]            <= 'b0;
                response_error[i]   <= 'b0;
            end else if(((state_q == WAIT_RESP_R || state_q == WAIT_RESP_W || state_q == WAIT_INVALID_R) && (m2s_resp_i[i].cr_valid) ) ) begin
                cr_valid[i]         <=   m2s_resp_i[i].cr_valid;
                data_available[i]   <=   m2s_resp_i[i].cr_resp.dataTransfer;
                shared[i]           <=   m2s_resp_i[i].cr_resp.isShared;
                dirty[i]            <=   m2s_resp_i[i].cr_resp.passDirty;
                response_error[i]   <=   m2s_resp_i[i].cr_resp.error;        
            end else if(state_q == IDLE) begin
                cr_valid[i]         <= 'b0;
                data_available[i]   <= 'b0;
                shared[i]           <= 'b0;
                dirty[i]            <= 'b0;
                response_error[i]   <= 'b0;
            end
        end 
    end

    // Hold snoop CD
    for (genvar i = 0; i < NoMstPorts; i = i + 1) begin: hold_snoop_data
        always_ff @ (posedge clk_i, negedge rst_ni) begin
            if(!rst_ni) begin
                data_received[i]    <= 'b0;
                cd_last[i]          <= 'b0;
                m2s_resp_holder[i]  <= '0;
            end else if(state_q == READ_SNP_DATA && m2s_resp_i[i].cd_valid) begin
                data_received[i]    <= m2s_resp_i[i].cd_valid;
                cd_last[i]          <= m2s_resp_i[i].cd.last;
                m2s_resp_holder[i]  <= m2s_resp_i[i];
            end else if(state_q == SEND_CD_READY) begin
                data_received[i]    <= 'b0;
                cd_last[i]          <= 'b0;
                m2s_resp_holder[i]  <= '0;
            end
        end 
    end
endmodule 


