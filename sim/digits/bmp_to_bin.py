"""
bmp_to_bin.py

Author: Kais Kudrolli

Description: Script to convert all bmp's to a hex string of their pixel data.
Then writes all 10 into hex_strings.txt.
"""

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

FILE_MODE = "rb"
HDR_SZ = 122
IMG_SZ = 784

def print_num(hex_string):
    for i in xrange(0, 28):
        for j in xrange(0, 28*2, 2):
            print_byte = (hex_string[(i*56)+j] + hex_string[(i*56)+(j+1)])
            if (print_byte == "ff"):
               print print_byte,
            else:
               print bcolors.OKGREEN + print_byte + bcolors.ENDC,
        print "\n",

def bmp_to_bin(bmp_name):
    bmp_file = open(bmp_name, FILE_MODE);
    header = bmp_file.read(HDR_SZ)

    hex_string = ""
    for i in xrange(0, IMG_SZ*3):
        byte = bmp_file.read(1)
        byte_str = format(ord(byte), 'x')
        if (len(byte_str) == 1):
            byte_str = "0" + byte_str
        if (i % 3 == 0):
            hex_string = byte_str + hex_string

    bmp_file.close()
    return hex_string


if __name__ == "__main__":
    hex_file = open("./hex_strings.txt", "w")

    for i in xrange(0, 10):
        hex_string = bmp_to_bin("./" + str(i) + ".bmp")
        hex_file.write("`define NUM" + str(i) + " 'h" + hex_string + "\n")

    hex_file.close() 

    
