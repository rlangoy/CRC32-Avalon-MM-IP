import devmem
import time
# Pyhsical addresses 
LPHS_BRIDGE                   = 0xff200000
CRC32_CALC_BASE               =    0x40000
CRC32_RESET_BASE= CRC32_CALC_BASE + 0x0004

#Acess -  CRC32 Calc Reg
CRC32_CALC_ADDR=LPHS_BRIDGE+CRC32_CALC_BASE
crc32CALCReg=devmem.DevMem(CRC32_CALC_ADDR,1,'/dev/mem',0)

#Acess - CRC32 Reset Reg
CRC32_RESET_ADDR=LPHS_BRIDGE+CRC32_RESET_BASE
crc32ResetReg=devmem.DevMem(CRC32_RESET_ADDR,1,'/dev/mem',0)
  

#Read and diplay the 32bit content stored at the byte address  CRC32_RESET_BASE
def readCRC32Sum() :
	crc32Sum=crc32CALCReg.read(0,1)
	return crc32Sum.data[0]

def addValueToBeCRC32Hashed( inputVal):
        crc32Sum=crc32CALCReg.write(0,[inputVal])

def resetCRC32Sum():
        crc32Sum=crc32ResetReg.write(0,[0x1]) # write 0x00000001 to the RESET REG 


print("Clearing the CRC32-Sum")
resetCRC32Sum()

bufferSize=4000 # Size of CRC32 input buffer
print("Starting claculating CRC from %d bytes" % bufferSize)
start_time = time.time()


resetCRC32Sum()
for i in range(bufferSize):
	addValueToBeCRC32Hashed(0x01)

print("The execution time was %s seconds ---" % (time.time() - start_time))
print ("The array CRC32 sum is: ", hex(readCRC32Sum()))

