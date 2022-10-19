// Authors: Mohammed Abdul Haq and Vempati Surya Kaushik
// Module Name: Synchronous FIFO
// Version: 1.1


module fifo (clk, rst, wr_en, rd_en, Data_in, Data_out, fifo_empty, fifo_full);
  parameter Depth = 64;

  input clk, rst, wr_en, rd_en;
  input [7:0] Data_in;

  output reg [7:0] Data_out;
  output reg fifo_empty, fifo_full;

  reg [7:0] fifo_mem [Depth-1:0];
  reg [$clog2(Depth)-1:0] rd_ptr, wr_ptr,temp_ptr;
// initial Conditions of FIFO
  initial begin
    wr_ptr=0;
    rd_ptr=0;
    fifo_full=0;
    fifo_empty=0;
  end

  always @(posedge clk) begin
    //Reset
    if(rst) begin
        wr_ptr=0;
        rd_ptr=0;
        Data_out=0;
        fifo_full=0;
        fifo_empty=1;
        temp_ptr=0;
    end
    // Read Write
    else begin
        // Write Operation
        temp_ptr=rd_ptr-1;
        if(wr_en && !fifo_full) begin
            fifo_mem[wr_ptr] <= Data_in;
            if(wr_ptr==rd_ptr) begin
                fifo_full=0;
                fifo_empty=1;
                wr_ptr=wr_ptr+1;
            end
            else if(temp_ptr==wr_ptr) begin
                fifo_full=1;
                fifo_empty=0;
            end
            else begin
                fifo_full=0;
                fifo_empty=0;
                wr_ptr=wr_ptr+1;
            end            
        end
        else begin
            Data_out <= Data_out;
        end

        // Read Operation

        if(rd_en && !fifo_empty) begin
            Data_out <= fifo_mem[rd_ptr];
            if(rd_ptr==wr_ptr) begin
                 fifo_empty=1;
                 fifo_full=0;
                 wr_ptr=wr_ptr+1;              
            end
            else begin
                fifo_empty=0;
                fifo_full=0;                
                rd_ptr=rd_ptr+1;
            end    
        end
        else begin
            Data_out <= Data_out;
        end
  end
  end
endmodule