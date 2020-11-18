

Files
======

hwCRC32SpeedTest.py  <- Benchmark of the HW implementet CRC32 IP 
pureSWCRC32.py       <- Benchmark SW version of the CRC32 IP
zlibCRC32.py         <- Benchmark of zlib's implementation of CRC32 generation


Expected speed results on DE1-SoC (and DE0-Soc-Nano) calculating 4000 bytes

Prog                  |   Calculation Time [sec]
----------------------+-------------------------
pureSWCRC32.py        |   2.60594511032105 
hwCRC32SpeedTest.py   |   0.12244725227356 
zlibCRC32.py          |   0.01834106445313 

