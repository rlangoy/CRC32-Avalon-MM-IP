// Testbench
module test;

  reg clk;
  reg reset;
   
  reg [7:0] address;
  reg read;
  reg [31:0]readdata;
  reg write;
  reg [31:0] writedata;
  
  
  // Instantiate design under test
  avs_mm_crc32_wraper DUT(.clk(clk), .reset(reset),
                    .avs_address(address),                     
                    .avs_read(read), 
                    .avs_readdata(readdata),
                    .avs_write(write),
                    .avs_writedata(writedata));
  
  

  initial begin 
      read  = 0;
      clk   = 0; 
      reset = 1;
      write=0;
      address =8'h00;
      #1
      reset = 1; 
      #1
      reset = 0; 
      read  = 1;  
      #1
      read  = 0;    
      address =8'h00;
      writedata= 8'h01;
      write=1;
      #1
      write=0;
      address =8'h00;
      read  = 1;  
    
      #1
      read  = 0;    
      writedata= 8'h01;
      write=1;
      address =8'b0;

      #1
      write=0;
      read  = 1;  
    
      #1
      read  = 0;    
      writedata= 8'h01;
      write=1;
      address =8'h01;

      #1
      write=0;
      read  = 1;  
      address =8'h00;

    
      #1
      read  = 0;    
      writedata= 8'h01;
      write=1;
      address =8'h00;

      #1
      write=0;
      read  = 1;  
      address =8'h00;


          #1
      read  = 0;    
      writedata= 8'h01;
      write=1;
      address =8'h00;

      #1
      write=0;
      read  = 1;  
      address =8'h00;

       #1
      read  = 0;    
      writedata= 8'h01;
      write=1;
      address =8'h00;

      #1
      write=0;
      read  = 1;  
      address =8'h00;

    
   	   
    end 

  
    always  
      #1  clk =  ! clk; 

  
  
  initial  begin
    $display("\t\ttime,\tclk,\treset,\tread\twrite\taddress\\twriteData\treaddatat"); 
    $monitor("%d,\t%b,\t%b,\t%b,\t%b,\t0x%h,\t0x%h,\t0x%h",$time, clk,reset,read,write,address,writedata,readdata); 
    end 
   
  initial 
    #100  $finish; 
  

endmodule
