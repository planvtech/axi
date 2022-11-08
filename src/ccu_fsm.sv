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

    enum logic [4:0] {  IDLE,           //0
                        DECODE_R,       //1 
                        SEND_INVALID_R, //3 
                        SEND_READ,      //4
                        WAIT_RESP_R,    //5   
                        SEND_DATA,      //6
                        SEND_AXI_REQ_R, //7
                        READ_MEM,       //8
                        SEND_ACK_R,     //9
                        SEND_ACK_I_R,   //10                       
                        DECODE_W,       //11
                        SEND_INVALID_W, //12
                        WAIT_RESP_W,    //13 
                        SEND_AXI_REQ_W, //14
                        WRITE_MEM,      //15
                        SEND_ACK_W      //16
                    } state_d, state_q;
    
    // snoop resoponse valid
    logic [NoMstPorts-1:0]          mst_resp_cr_valid;
    // check for availablilty of data
    logic [NoMstPorts-1:0]          data_available;
    // snoop channel ac received by master
    logic [NoMstPorts-1:0]          mst_resp_ac_ready;
    // snoop channel cd last 
    logic [NoMstPorts-1:0]          mst_resp_cd_last;
    // request holder
    mst_req_t                       ccu_req_holder; 
    // response holder
    mst_resp_t                      ccu_resp_holder;
    // snoop response holder
    snoop_resp_t [NoMstPorts-1:0]   m2s_resp_holder;


    // stack snoop reponse valids and data_available
    for (genvar i = 0; i < NoMstPorts; i++) begin : stack_cr_valid
        assign mst_resp_cr_valid[i] = 'b1;//m2s_resp_holder[i].cr_valid;
        assign data_available[i]    = 'b0;//m2s_resp_holder[i].cr_resp[0];
        assign mst_resp_ac_ready[i] = 'b0;//m2s_resp_i[i].ac_ready;
        assign mst_resp_cd_last[i]  = 'b1;//m2s_resp_i[i].cd.last;
    end 


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
            // check read transaction type
            if(ccu_req_holder.ar.snoop != 4'b1011) begin   // check if CleanUnique then send Invalidate 
                state_d = SEND_READ;
            end else begin
                state_d = SEND_INVALID_R;
            end
        end

        SEND_INVALID_R: begin
            // wait for all snoop masters to assert AC ready 
            if (mst_resp_ac_ready != '0) begin
                state_d = SEND_INVALID_R;
            end else begin
                state_d = WAIT_RESP_R;
            end
        end

        SEND_READ: begin
            // wait for all snoop masters to de-assert AC ready 
            if (mst_resp_ac_ready != '0) begin
                state_d = SEND_READ;
            end else begin
                state_d = WAIT_RESP_R;
            end
        end

        WAIT_RESP_R: begin
            // wait for all snoop masters to assert CR valid 
            if (mst_resp_cr_valid != '1) begin
                state_d = WAIT_RESP_R;
            end else if(data_available != 0) begin
                state_d = SEND_DATA;
            end else begin
                state_d = SEND_AXI_REQ_R;
            end
        end

        SEND_DATA: begin
            // wait for initiating master to de-assert r_ready
            if(ccu_req_i.r_ready == 'b0) begin
                if(mst_resp_cd_last != '0) begin 
                    state_d = IDLE;
                end else begin 
                    state_d = SEND_DATA;
                end
            end else begin
                state_d = SEND_DATA;
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
            if(ccu_resp_i.r_valid) begin
                state_d = SEND_ACK_R;
            end else begin
                state_d = READ_MEM;
            end
        end         
       
        SEND_ACK_R: begin
            if( ccu_req_i.r_ready ) begin
                if(ccu_resp_holder.r.last) begin
                    state_d = IDLE;
                end else begin
                    state_d = READ_MEM;
                end
            end else begin
                state_d = SEND_ACK_R;
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
            if (mst_resp_ac_ready != '0) begin
                state_d = SEND_INVALID_W;
            end else begin
                state_d = WAIT_RESP_W;
            end
        end

        WAIT_RESP_W: begin
            // wait for all snoop masters to assert CR valid 
            if (mst_resp_cr_valid != '1 ) begin
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
            if(ccu_resp_i.b_valid !='b1) begin
                state_d = WRITE_MEM;
            end else begin
                state_d = IDLE;
            end
        end
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
            ccu_resp_o.aw_ready =   'b1;
            ccu_resp_o.ar_ready =   'b1;
        end

        //--------------------- 
        //---- Read Branch ----
        //--------------------- 

        SEND_READ: begin
            // send request to snooping masters
            s2m_req_o.ac.addr   =   ccu_req_holder.ar.addr;
            s2m_req_o.ac.prot   =   ccu_req_holder.ar.prot;
            s2m_req_o.ac.snoop  =   ccu_req_holder.ar.snoop;
            s2m_req_o.ac_valid  =   'b1;
        end

        SEND_INVALID_R,SEND_INVALID_W:begin
            s2m_req_o.ac.addr   =   ccu_req_holder.ar.addr;
            s2m_req_o.ac.prot   =   ccu_req_holder.ar.prot;
            s2m_req_o.ac.snoop  =   'b1001;
            s2m_req_o.ac_valid  =   'b1;         
        end 
        
        WAIT_RESP_R, WAIT_RESP_W: begin
            s2m_req_o.cr_ready  =   'b1;
        end

        SEND_DATA: begin
            // response to intiating master
            for (int unsigned i = 0; i < NoMstPorts; i = i + 1)
                if (data_available[i]) begin
                    ccu_resp_o.r.data   =   m2s_resp_holder[i].cd.data;
                    ccu_resp_o.r.last   =   m2s_resp_holder[i].cd.last;
                end
            ccu_resp_o.r_valid  =   'b1;   
            s2m_req_o.cd_ready  =   'b1; 
        end

        SEND_AXI_REQ_R: begin
            // forward request to slave (RAM)
            ccu_req_o.ar_valid  =   'b1;
            ccu_req_o.ar        =    ccu_req_holder.ar; 
        end

        READ_MEM: begin
            // indicate slave to send data on r channel 
            ccu_req_o.r_ready   =   'b1; 
        end

        SEND_ACK_R:begin
            // forward reponse from slave to intiating master
            ccu_resp_o.r        =   ccu_resp_holder.r;  
            ccu_resp_o.r_valid  =   1'b1;   
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
        SEND_AXI_REQ_W: begin
            // forward request to slave (RAM)
            ccu_req_o.aw_valid  =   'b1;
            ccu_req_o.aw        =    ccu_req_holder.aw; 
        end

        WRITE_MEM: begin
            ccu_req_o           =  ccu_req_i;
            ccu_resp_o          =  ccu_resp_i;
        end

        endcase
    end // end output block

    // Hold incoming ACE request 
    always_ff @(posedge clk_i , negedge rst_ni) begin
        if(!rst_ni) begin
            ccu_req_holder <= '0;
        end else if(state_q == IDLE && (ccu_req_i.ar_valid | ccu_req_i.aw_valid) | state_q == WRITE_MEM && ( ccu_req_i.w_valid)) begin
            ccu_req_holder <=  ccu_req_i;
        end 
    end

    // Hold incoming ACE response 
    always_ff @(posedge clk_i , negedge rst_ni) begin
        if(!rst_ni) begin
            ccu_resp_holder <= '0;
        end else if ( state_q == READ_MEM && ccu_resp_i.r_valid | state_q == WRITE_MEM && ccu_resp_i.b_valid) begin
            ccu_resp_holder <=  ccu_resp_i;        
        end 
    end
    
    // Hold snoop response
    for (genvar i = 0; i < NoMstPorts; i = i + 1) begin: hold_snoop
        always_ff @ (posedge clk_i, negedge rst_ni) begin
            if(rst_ni) begin
                m2s_resp_holder[i] <= '0;
            end else if(state_q == WAIT_RESP_R && (m2s_resp_i[i].cr_valid)) begin
                m2s_resp_holder[i] <= m2s_resp_i[i];
            end
        end 
    end      

endmodule 
