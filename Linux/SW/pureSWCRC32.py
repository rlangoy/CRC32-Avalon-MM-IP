#
#  See HW sim from:
#  https://www.edaplayground.com/x/ii7q
#
import time
def crc(crcIn, data):
	class bitwrapper:
		def __init__(self, value):
			self.value = value
		def __getitem__(self, index):
			return ((self.value >> index) & 1)
		def __setitem__(self, index, value):
			if value:
				self.value |= 1 << index
			else:
				self.value &= ~(1 << index)
	crcIn = bitwrapper(crcIn)
	data = bitwrapper(data)
	ret = bitwrapper(0)
	ret[0] = (crcIn[2] ^ crcIn[8] ^ data[2])
	ret[1] = (crcIn[0] ^ crcIn[3] ^ crcIn[9] ^ data[0] ^ data[3])
	ret[2] = (crcIn[0] ^ crcIn[1] ^ crcIn[4] ^ crcIn[10] ^ data[0] ^ data[1] ^ data[4])
	ret[3] = (crcIn[1] ^ crcIn[2] ^ crcIn[5] ^ crcIn[11] ^ data[1] ^ data[2] ^ data[5])
	ret[4] = (crcIn[0] ^ crcIn[2] ^ crcIn[3] ^ crcIn[6] ^ crcIn[12] ^ data[0] ^ data[2] ^ data[3] ^ data[6])
	ret[5] = (crcIn[1] ^ crcIn[3] ^ crcIn[4] ^ crcIn[7] ^ crcIn[13] ^ data[1] ^ data[3] ^ data[4] ^ data[7])
	ret[6] = (crcIn[4] ^ crcIn[5] ^ crcIn[14] ^ data[4] ^ data[5])
	ret[7] = (crcIn[0] ^ crcIn[5] ^ crcIn[6] ^ crcIn[15] ^ data[0] ^ data[5] ^ data[6])
	ret[8] = (crcIn[1] ^ crcIn[6] ^ crcIn[7] ^ crcIn[16] ^ data[1] ^ data[6] ^ data[7])
	ret[9] = (crcIn[7] ^ crcIn[17] ^ data[7])
	ret[10] = (crcIn[2] ^ crcIn[18] ^ data[2])
	ret[11] = (crcIn[3] ^ crcIn[19] ^ data[3])
	ret[12] = (crcIn[0] ^ crcIn[4] ^ crcIn[20] ^ data[0] ^ data[4])
	ret[13] = (crcIn[0] ^ crcIn[1] ^ crcIn[5] ^ crcIn[21] ^ data[0] ^ data[1] ^ data[5])
	ret[14] = (crcIn[1] ^ crcIn[2] ^ crcIn[6] ^ crcIn[22] ^ data[1] ^ data[2] ^ data[6])
	ret[15] = (crcIn[2] ^ crcIn[3] ^ crcIn[7] ^ crcIn[23] ^ data[2] ^ data[3] ^ data[7])
	ret[16] = (crcIn[0] ^ crcIn[2] ^ crcIn[3] ^ crcIn[4] ^ crcIn[24] ^ data[0] ^ data[2] ^ data[3] ^ data[4])
	ret[17] = (crcIn[0] ^ crcIn[1] ^ crcIn[3] ^ crcIn[4] ^ crcIn[5] ^ crcIn[25] ^ data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[5])
	ret[18] = (crcIn[0] ^ crcIn[1] ^ crcIn[2] ^ crcIn[4] ^ crcIn[5] ^ crcIn[6] ^ crcIn[26] ^ data[0] ^ data[1] ^ data[2] ^ data[4] ^ data[5] ^ data[6])
	ret[19] = (crcIn[1] ^ crcIn[2] ^ crcIn[3] ^ crcIn[5] ^ crcIn[6] ^ crcIn[7] ^ crcIn[27] ^ data[1] ^ data[2] ^ data[3] ^ data[5] ^ data[6] ^ data[7])
	ret[20] = (crcIn[3] ^ crcIn[4] ^ crcIn[6] ^ crcIn[7] ^ crcIn[28] ^ data[3] ^ data[4] ^ data[6] ^ data[7])
	ret[21] = (crcIn[2] ^ crcIn[4] ^ crcIn[5] ^ crcIn[7] ^ crcIn[29] ^ data[2] ^ data[4] ^ data[5] ^ data[7])
	ret[22] = (crcIn[2] ^ crcIn[3] ^ crcIn[5] ^ crcIn[6] ^ crcIn[30] ^ data[2] ^ data[3] ^ data[5] ^ data[6])
	ret[23] = (crcIn[3] ^ crcIn[4] ^ crcIn[6] ^ crcIn[7] ^ crcIn[31] ^ data[3] ^ data[4] ^ data[6] ^ data[7])
	ret[24] = (crcIn[0] ^ crcIn[2] ^ crcIn[4] ^ crcIn[5] ^ crcIn[7] ^ data[0] ^ data[2] ^ data[4] ^ data[5] ^ data[7])
	ret[25] = (crcIn[0] ^ crcIn[1] ^ crcIn[2] ^ crcIn[3] ^ crcIn[5] ^ crcIn[6] ^ data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[5] ^ data[6])
	ret[26] = (crcIn[0] ^ crcIn[1] ^ crcIn[2] ^ crcIn[3] ^ crcIn[4] ^ crcIn[6] ^ crcIn[7] ^ data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[4] ^ data[6] ^ data[7])
	ret[27] = (crcIn[1] ^ crcIn[3] ^ crcIn[4] ^ crcIn[5] ^ crcIn[7] ^ data[1] ^ data[3] ^ data[4] ^ data[5] ^ data[7])
	ret[28] = (crcIn[0] ^ crcIn[4] ^ crcIn[5] ^ crcIn[6] ^ data[0] ^ data[4] ^ data[5] ^ data[6])
	ret[29] = (crcIn[0] ^ crcIn[1] ^ crcIn[5] ^ crcIn[6] ^ crcIn[7] ^ data[0] ^ data[1] ^ data[5] ^ data[6] ^ data[7])
	ret[30] = (crcIn[0] ^ crcIn[1] ^ crcIn[6] ^ crcIn[7] ^ data[0] ^ data[1] ^ data[6] ^ data[7])
	ret[31] = (crcIn[1] ^ crcIn[7] ^ data[1] ^ data[7])
	return ret.value

bufferSize=4000 # Size of CRC32 input buffer
print("Starting claculating CRC from %d bytes" % bufferSize)

start_time = time.time()
crcSum=0

for inputByte in range(bufferSize):
   crcSum=crc(crcSum,0x01)

print("The execution time was %s seconds ---" % (time.time() - start_time))

print("The array has CRC32 sum: ", hex(crcSum))


