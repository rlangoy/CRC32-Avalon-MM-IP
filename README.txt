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
	        soc_system.rbf         <- programming file loadable by U-BOOT / Linux
	        soc_system.sof         <- Normal quartus programming file

	.\DE1-SoC                      <- Files for building the DE1-SoC HPS system with memory mapped CRC32 Module 
	    HW\DE0_Nano_SoC_CRC32.qar  <- Quartus 20.1 Project archive 
	    HW\progFile                <- FPGA programing files
	        soc_system.rbf         <- programming file loadable by U-BOOT / Linux
	        soc_system.sof         <- Normal quartus programming file

	    
	.\Linux          <- Files for testing the memorymapped CRC32 module using Python
	    SW\hwCRC32SpeedTest.py  <- Benchmark of the HW implementet CRC32 IP 
	    SW\pureSWCRC32.py       <- Benchmark SW version of the CRC32 IP
	    SW\zlibCRC32.py         <- Benchmark of zlib's implementation of CRC32 generation



Installation binary-image for DE0-SoC-Nano
==========================================
For ease a  A prebuildt Linux 3.51 SD-Card image with U-Boot / CRC32 IP and Debian 10 + samples for DE0-Nano-SoC is available
Installation:
--------------
 
 1. Download and install balena-etcher (1.5) from balena-io https://github.com/balena-io/etcher/releases
 2. Insert a SD-Card of 4GB or more into the PC.
 3. Start balena-etcher 
 	i.  Click "Flash from URL"
 	ii. Paste in the URL: https://github.com/rlangoy/CRC32-Avalon-MM-IP/releases/download/1.0/DE0SocDebian10v4.img.xz and click ok
 	iii. Click "Select target" (the SD-card to place the image on)
 	iv.  Click "!Flash"
 4. Eject (unmount) the SD-Card
 5. Place the SD-Card in the development board and power it on
 6. The log in credentials is:
     Login:      root
     Password:   admin



Installation binary-image for DE1-SoC-Nano
==========================================
The prebuildt Linux 3.15 SD-Card image for DE0-Nano-SoC can be used on the DE1-SoC by only replacing the FPGA-Programming file (soc_system.rbf)
The SD-Card immage contains U-Boot,Linux 3.51 and Debian 10 + CRC32 Sample test programs.

Installation:
--------------
 
 1. Download and install balena-etcher (1.5) from balena-io https://github.com/balena-io/etcher/releases
 2. Insert a SD-Card of 4GB or more into the PC.
 3. Start balena-etcher 
 	i.  Click "Flash from URL"
 	ii. Paste in the URL: https://github.com/rlangoy/CRC32-Avalon-MM-IP/releases/download/1.0/DE0SocDebian10v4.img.xz and click ok
 	iii. Click "Select target" (the SD-card to place the image on)
 	iv.  Click "!Flash"
 4. Replace the soc_system.rbf on the sd-card with the .\DE1-SoC\HW\progFile\soc_system.rbf
 5. Eject (unmount) the SD-Card
 6. Place the SD-Card in the development board and power it on
 7. The log in credentials is:
     Login:      root
     Password:   admin


Create the Binary program files for other FPGA-devices 
=======================================================
  a) Start Quartus (v21.1) and Create a new project
  b) Copy the folder .\ip width content the new project folder.
  c) Open Quartus and select the menu item Tools |  Platform Designer
       i.  Open the menu timem Edit | Add and the ip  "USN | CRC32"
       ii. Close Platform Designer
  d) In Quartus select the menu item Processing | "Start Compilation" and wait.
  f) Convert the system_soc to soc_system.rbf
        select the menu item File | "Convert Programming files..." 
        i.   Change "Programming File type:" to "Raw Binary file (.rbf)"
        ii.  Change "Mode:" to "Passive Paralell x16"
        iii. In "Input files to convert" select "SOF data" click button "Add File.." and select system_soc.sof
        iv.  Click the generate button

U-BOOT Testing of CRC32-Core
============================

	1. Connect the USB cable (RS323 USB UART) (Micro-USB-Cable on DE1 and DE0) to the PC and Devlopment board
    2. Power on the Development board    

    3. Use a serial terminal program to comunicate width the Dev-Board UART
        Windows:
         ExtraPuTTY http://www.extraputty.com/download.php
         or Tera Term http://hp.vector.co.jp/authors/VA002416/teraterm.html )
        Linux:
           Start a new terminal
           Install minicom:
              sudo apt-install minicom
              minicom -D/dev/ttyACM0 -b115200 -o
 	4.) Stop U-Boot by pressing any when the power is turned on the Dev-board 
	    a) Program the FPGA HW:
	          #Load FPGA  from the SD-Card
	          fatload mmc 0:1 ${fpgadata} system_soc.rbf;
	          #Program FPGA
	          fpga load 0 ${fpgadata} ${filesize};
	          #Enable all bridges (busses)
	          run bridge_enable_handoff

	    b) Test the CRC32 module
	            #Add value (byte) to caclulate CRC32 
	            mw 0xff240000 0x01
	            #Show the new CRC32 SUM
	            md 0xff420000 1
	    c) Reset the CRC32-sum
	    		#Clear The CRC 32 sum 
	            mw 0xff240004 0x01
	            #Add value (byte) to caclulate CRC32 
	            mw 0xff240000 0x01
	            #Show the new CRC32 SUM
	            md 0xff420000 1


About
======
The CRC32 verilog code was created using  the CRC32-generator page (https://bues.ch/cms/hacking/crcgen).
    Online Hardware Simulator can be found at: https://www.edaplayground.com/x/ii7q 
    Online Python CRC32 demo is found at:      https://repl.it/join/zhlmvojd-rrrune
    Online Rust   CRC32 demo is found at:      https://play.rust-lang.org/?version=stable&mode=debug&edition=2018&gist=41962553c943c253519d9f7484e2dbae
    
    

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

    
	
 
 
 
 

