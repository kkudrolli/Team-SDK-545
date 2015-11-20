"""
bmp_to_bin.py

Author: Kais Kudrolli

Description: Script to convert all bmp's to a hex string of their pixel data.
Then write that to a file *.bin.
"""

FILE_MODE = "rb"
HDR_SZ = 122

def bmp_to_bin(bmp_name):
    bmp_file = open(bmp_name, FILE_MODE);
    header = bmp_file.read(HDR_SZ)
    print " ".join(hex(ord(n)) for n in header)
    
    bmp_file.close()


if __name__ == "__main__":
    bmp_to_bin("./0.bmp")
    
