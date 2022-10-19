// Authors: Mohammed Abdul Haq and Vempati Surya Kaushik
// Module Name: Synchronous FIFO_TB
// Version: 1.1


module tb;

reg clk,rst,wr_en,rd_en;
reg [7:0] Data_in;

wire [7:0] Data_out;
wire fifo_empty;
wire fifo_full;

integer i;

fifo DUT(.clk(clk), .rst(rst), .wr_en(wr_en), .rd_en(rd_en), .Data_in(Data_in), .Data_out(Data_out), .fifo_empty(fifo_empty), .fifo_full(fifo_full),.TData_out(TData_out));
   

initial begin
    $dumpfile("dump.vcd"); $dumpvars(0,tb);
end
initial begin
    clk=1;
    forever begin
        clk=#5 ~clk;
    end
end

initial begin
    rst=0;Data_in=0;wr_en=0;rd_en=0;
    @(posedge clk)
    rst=1;
    repeat(2) @(posedge clk);
    @(posedge clk)
    rst=0;
    #10;

    for(i=0;i<20;i=i+1) begin
       #10;
       wr_en=1;
        Data_in=i;
        if(i==15) rst=1;
        else if(i==17) rst=0;
        else rst =0;      
    end
    #10;wr_en=0;
    #10;rd_en=1;

    // some other conditions you can try!!
    // wr_en=0;
    // #30;rd_en=1;
    // #($clog2($random));
    // rd_en=0;
    // rd_en=0;wr_en=1;
    // #10;
    // for(i=0;i<20;i=i+1) begin
    //     #10;
    //     Data_in=i+100;
    // end
    // #10;

    // #10;
    // rd_en=1;


    #1000;
    $finish;
end
initial begin
   
    $monitor($time,"  output data=%d, read Enable=%b, read pointers=%d,  fifo_empty=%b, INPUT DATA=%d, Write enable=%b, write pointers=%d , fifo_full=%b ",Data_out,rd_en,DUT.rd_ptr,fifo_empty, Data_in,wr_en,DUT.wr_ptr,fifo_full);
end
endmodule