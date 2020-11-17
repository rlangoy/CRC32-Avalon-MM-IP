CRC32 Memory mapped core
========================

Implementation of "Avalon memory mapped" CRC32 - ip from https://bues.ch/cms/hacking/crcgen (https://github.com/mbuesch/crcgen)
using DE0-Nano-SoC

File Structure:
	.\ip                  <- Quartus System Builder (QSYS) components 
	    CRC32             <- Folder for the CRC32 Avalon Memorymapped IP source and testbench
	      CRC32_hw.tcl    <- System builder script linking hdl source and testbench as a System Builder Component
	      avs_mm_crc32_wraper.v  <- verilog CRC32 component connected to "memory mapped avalon I/O" 
	      avs_crc32_wraper_tb.sv <- system verilog test bench for the CRC32 memory mapped component


	.\DE0-NANO-SoC   <- Files for building the DE0-Nano-SoC HPS system with memory mapped CRC32 Module 
	    HW\DE0_Nano_SoC_CRC32.qar  <- Quartus 20.1 Project archive 
	    HW\progFile                <- FPGA programing files
	        de0_nano_soc.rbf       <- programming file loadable by U-BOOT / Linux
	        soc_system.sof         <- Normal quartus programming file

	    
	.\Linux          <- Files for testing the memorymapped CRC32 module using Python
	    SW\hwCRC32SpeedTest.py  <- Benchmark of the HW implementet CRC32 IP 
	    SW\pureSWCRC32.py       <- Benchmark SW version of the CRC32 IP
	    SW\zlibCRC32.py         <- Benchmark of zlib's implementation of CRC32 generation

Installation
===============
A prebuildt Linux SD-Card image with U-Boot / CRC32 IP and ebian 10 + samples for DE0-Nano-SoC can be downloaded from : https://github.com/rlangoy/CRC32-Avalon-MM-IP/releases/download/1.0/DE0SocDebian10v4.img.xz  
   The SD-Card image can be burned using Etcher (https://github.com/balena-io/etcher/releases)


About
======
The CRC32 verilog code locis using  the CRC32-generator page (https://bues.ch/cms/hacking/crcgen).
    Online Hardware Simulator can be found at: https://www.edaplayground.com/x/ii7q 
    Online Python CRC32 demo is found at:      https://repl.it/join/zhlmvojd-rrrune
    
    

Licence
=======
This code is Public Domain.
Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted.
 
THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE
USE OR PERFORMANCE OF THIS SOFTWARE.

    
	
 
 
 
 

