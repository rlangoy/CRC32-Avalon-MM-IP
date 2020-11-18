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
      //Initial/Statup Values
      read  = 0;
      clk   = 0; 
      reset = 1;
      write=0;
      address =8'h00;

      #1
      hwReset();
    
    
      #1
      write2Address(8'h00,8'h01);

      #1
      readAddress(8'h00);

      #1
      write2Address(8'h00,8'h01);

      #1
      readAddress(8'h00);

      #1
      write2Address(8'h00,8'h01);

      #1
      readAddress(8'h00);

    
      //Reset CRC32-Value
      #1
      write2Address(8'h01,8'h01);

      #1
      readAddress(8'h00);

    
      #1
      write2Address(8'h00,8'h01);

      #1
      readAddress(8'h00);

       
    end 

  //Perform Hardware reset
  task hwReset;
     begin
       $display("hwReset()");
      clk   = 1; 
      reset = 1;
      #1
      reset = 0; 
      clk   = 0; 
     end
  endtask
  
  //Read data from a given address
  task automatic readAddress;
  	input byte _addr;  
    begin
      $display("readAddress() _addr: 0x%h", _addr);
     #1
     clk=1;
     read  = 1;    
     address =_addr;

     #1
     clk=0;
     read  = 0;    

    end
  endtask

  //Write data to a given address
  task automatic write2Address;
  	input byte _addr;  
    input byte _value;    
    begin
      $display("write2Address() _addr: 0x%h _value: 0x%h", _addr,_value);
     #1
     clk=1;
     read  = 0;    
     writedata= _value;
     write=1;
     address =_addr;

     #1
     clk=0;
     write=0;

    end
  endtask
  
  
  //Displays signals on changes
  initial  begin
    $display("\t\ttime,\tclk,\treset,\tread\twrite\taddress\\twriteData\treaddatat"); 
    $monitor("%d,\t%b,\t%b,\t%b,\t%b,\t0x%h,\t0x%h,\t0x%h",$time, clk,reset,read,write,address,writedata,readdata); 
    end 
   
  initial 
    #100  $finish; 
  

endmodule
