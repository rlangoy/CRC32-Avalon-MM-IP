import zlib
import time
# Source for zlib crc: https://github.com/madler/zlib/blob/master/crc32.c

bufferSize=4000 # Size of CRC32 input buffer
print("Starting claculating CRC from %d bytes" % bufferSize)

start_time = time.time()
dataInput = bytes([0x01])
for i in range(bufferSize-1):
  dataInput +=bytes([0x01])

crcSum=zlib.crc32(dataInput)

print("The execution time was %s seconds ---" % (time.time() - start_time))

#print("Datainput : ")
#print(dataInput)
print("The array has CRC32 sum:", hex(crcSum))

