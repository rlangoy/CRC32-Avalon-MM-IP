
/*
This is a implementation of "Avalon memory mapped" CRC32 
The crc module is grenerated using the site: https://bues.ch/cms/hacking/crcgen 
#
# Licence
#############
# This code is Public Domain.
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
# SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
# RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
# NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE
# USE OR PERFORMANCE OF THIS SOFTWARE.

# Poly in hex form: 0x04 C1 1D B7
# CRC polynomial coefficients: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
# Hexadecimal, reversed representation: 0xED B8 83 20 (hex)  
# CRC width:                   32 bits
# CRC shift direction:         right
# OUTPUT Xor 0xffffffff
*/

// Design
// Avalon memory interface
module avs_mm_crc32_wraper( 
  	         clk, // clock.clk
             reset, // reset.reset

             // Memory mapped read/write slave interface
             avs_address,
             avs_read,
             avs_write,
             avs_writedata,
             avs_readdata);
    
  //Clk and reset
  input      clk;
  input      reset;
  // Memory mapped read/write slave interface
  input [7:0]    avs_address;
  input	  avs_read;
  input	  avs_write;
  input  [31:0] avs_writedata;
  output [31:0]  avs_readdata;
  
  //--- Internal Reg and fun
  reg [31:0] 	 out_data;
  reg [31:0] 	 crc32_sum;
  reg [7:0]      data;
  wire [31:0]     out;
  reg             rst;
  crc crc32(.crcIn(crc32_sum),.data(data),.crcOut(out));

  //When Read signal is issued put out data
  // Writes the CRC32-sum and out_data
  always @(posedge avs_read)
  begin
     //if ((avs_address == 8'h00) && (avs_read)) begin
    if (avs_read) 
      case (avs_address )
        8'h00     :   out_data = out;             
        default   :   out_data = 8'hff;
      endcase                     
  end
  
 
  // Writes the CRC32-data & crc32_sum
  always @ (posedge avs_write or posedge reset)
  begin
    if (reset)
      begin
        rst=1;         // Flag reset crc32 sum
      end
    else if ( avs_write ) begin  
      case (avs_address ) 
       8'h00  : begin  // Set CRC32-Sum and new input data
        	      
         		  // If reset initiate CRC32 SUM
         		  if(rst) begin 
                    	rst=0; 
                        crc32_sum=32'hffffffff;  //CRC32 Init
                  end else  
                    	crc32_sum=out;
         
                  data = avs_writedata & 8'hff;     // Write new data to calculate crc32       				
       			end
        //Writing to address 0x01 -> CRC32 RESET (set's crc32_sum to 0xffffffff when adding new data)
        8'h01  : rst=1; 			
                      
      endcase
  	end
	 
  end // end write 
  
  
 // write data from reg to outport     
  assign avs_readdata = ~out_data;  // Output is CRC32 sum inverted

endmodule

module crc (crcIn, data, crcOut);
	input [31:0] crcIn;
	input [7:0] data;
	output [31:0] crcOut;

	assign crcOut[0] = (crcIn[2] ^ crcIn[8] ^ data[2]);
	assign crcOut[1] = (crcIn[0] ^ crcIn[3] ^ crcIn[9] ^ data[0] ^ data[3]);
	assign crcOut[2] = (crcIn[0] ^ crcIn[1] ^ crcIn[4] ^ crcIn[10] ^ data[0] ^ data[1] ^ data[4]);
	assign crcOut[3] = (crcIn[1] ^ crcIn[2] ^ crcIn[5] ^ crcIn[11] ^ data[1] ^ data[2] ^ data[5]);
	assign crcOut[4] = (crcIn[0] ^ crcIn[2] ^ crcIn[3] ^ crcIn[6] ^ crcIn[12] ^ data[0] ^ data[2] ^ data[3] ^ data[6]);
	assign crcOut[5] = (crcIn[1] ^ crcIn[3] ^ crcIn[4] ^ crcIn[7] ^ crcIn[13] ^ data[1] ^ data[3] ^ data[4] ^ data[7]);
	assign crcOut[6] = (crcIn[4] ^ crcIn[5] ^ crcIn[14] ^ data[4] ^ data[5]);
	assign crcOut[7] = (crcIn[0] ^ crcIn[5] ^ crcIn[6] ^ crcIn[15] ^ data[0] ^ data[5] ^ data[6]);
	assign crcOut[8] = (crcIn[1] ^ crcIn[6] ^ crcIn[7] ^ crcIn[16] ^ data[1] ^ data[6] ^ data[7]);
	assign crcOut[9] = (crcIn[7] ^ crcIn[17] ^ data[7]);
	assign crcOut[10] = (crcIn[2] ^ crcIn[18] ^ data[2]);
	assign crcOut[11] = (crcIn[3] ^ crcIn[19] ^ data[3]);
	assign crcOut[12] = (crcIn[0] ^ crcIn[4] ^ crcIn[20] ^ data[0] ^ data[4]);
	assign crcOut[13] = (crcIn[0] ^ crcIn[1] ^ crcIn[5] ^ crcIn[21] ^ data[0] ^ data[1] ^ data[5]);
	assign crcOut[14] = (crcIn[1] ^ crcIn[2] ^ crcIn[6] ^ crcIn[22] ^ data[1] ^ data[2] ^ data[6]);
	assign crcOut[15] = (crcIn[2] ^ crcIn[3] ^ crcIn[7] ^ crcIn[23] ^ data[2] ^ data[3] ^ data[7]);
	assign crcOut[16] = (crcIn[0] ^ crcIn[2] ^ crcIn[3] ^ crcIn[4] ^ crcIn[24] ^ data[0] ^ data[2] ^ data[3] ^ data[4]);
	assign crcOut[17] = (crcIn[0] ^ crcIn[1] ^ crcIn[3] ^ crcIn[4] ^ crcIn[5] ^ crcIn[25] ^ data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[5]);
	assign crcOut[18] = (crcIn[0] ^ crcIn[1] ^ crcIn[2] ^ crcIn[4] ^ crcIn[5] ^ crcIn[6] ^ crcIn[26] ^ data[0] ^ data[1] ^ data[2] ^ data[4] ^ data[5] ^ data[6]);
	assign crcOut[19] = (crcIn[1] ^ crcIn[2] ^ crcIn[3] ^ crcIn[5] ^ crcIn[6] ^ crcIn[7] ^ crcIn[27] ^ data[1] ^ data[2] ^ data[3] ^ data[5] ^ data[6] ^ data[7]);
	assign crcOut[20] = (crcIn[3] ^ crcIn[4] ^ crcIn[6] ^ crcIn[7] ^ crcIn[28] ^ data[3] ^ data[4] ^ data[6] ^ data[7]);
	assign crcOut[21] = (crcIn[2] ^ crcIn[4] ^ crcIn[5] ^ crcIn[7] ^ crcIn[29] ^ data[2] ^ data[4] ^ data[5] ^ data[7]);
	assign crcOut[22] = (crcIn[2] ^ crcIn[3] ^ crcIn[5] ^ crcIn[6] ^ crcIn[30] ^ data[2] ^ data[3] ^ data[5] ^ data[6]);
	assign crcOut[23] = (crcIn[3] ^ crcIn[4] ^ crcIn[6] ^ crcIn[7] ^ crcIn[31] ^ data[3] ^ data[4] ^ data[6] ^ data[7]);
	assign crcOut[24] = (crcIn[0] ^ crcIn[2] ^ crcIn[4] ^ crcIn[5] ^ crcIn[7] ^ data[0] ^ data[2] ^ data[4] ^ data[5] ^ data[7]);
	assign crcOut[25] = (crcIn[0] ^ crcIn[1] ^ crcIn[2] ^ crcIn[3] ^ crcIn[5] ^ crcIn[6] ^ data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[5] ^ data[6]);
	assign crcOut[26] = (crcIn[0] ^ crcIn[1] ^ crcIn[2] ^ crcIn[3] ^ crcIn[4] ^ crcIn[6] ^ crcIn[7] ^ data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[4] ^ data[6] ^ data[7]);
	assign crcOut[27] = (crcIn[1] ^ crcIn[3] ^ crcIn[4] ^ crcIn[5] ^ crcIn[7] ^ data[1] ^ data[3] ^ data[4] ^ data[5] ^ data[7]);
	assign crcOut[28] = (crcIn[0] ^ crcIn[4] ^ crcIn[5] ^ crcIn[6] ^ data[0] ^ data[4] ^ data[5] ^ data[6]);
	assign crcOut[29] = (crcIn[0] ^ crcIn[1] ^ crcIn[5] ^ crcIn[6] ^ crcIn[7] ^ data[0] ^ data[1] ^ data[5] ^ data[6] ^ data[7]);
	assign crcOut[30] = (crcIn[0] ^ crcIn[1] ^ crcIn[6] ^ crcIn[7] ^ data[0] ^ data[1] ^ data[6] ^ data[7]);
	assign crcOut[31] = (crcIn[1] ^ crcIn[7] ^ data[1] ^ data[7]);
endmodule
