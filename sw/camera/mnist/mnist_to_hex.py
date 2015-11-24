"""
mnist_to_hex.py

Author: Kais Kudrolli

Description: Script to convert mnist images to a hex string of their pixel data.
Then writes all into hex_strings.txt.
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
IMAGE_HEADER_SIZE = 16
NUM_ITEMS_OFFSET = 6
ROW_OFFSET = 11
COL_OFFSET = 15

def print_num(hex_string):
    for i in xrange(0, 28):
        for j in xrange(0, 28*2, 2):
            print_byte = (hex_string[(i*56)+j] + hex_string[(i*56)+(j+1)])
            if (print_byte == "00"):
               print print_byte,
            else:
               print bcolors.OKGREEN + print_byte + bcolors.ENDC,
        print "\n",

def mnist_to_bin(mnist_name):
    mnist_file = open(mnist_name, FILE_MODE);
    header = mnist_file.read(IMAGE_HEADER_SIZE)
    for i in header: print format(ord(i), 'x')

    num_images = ord(header[NUM_ITEMS_OFFSET:NUM_ITEMS_OFFSET+1])
    #print num_images
    rows = ord(header[ROW_OFFSET:ROW_OFFSET+1])
    #print rows
    cols = ord(header[COL_OFFSET:COL_OFFSET+1])
    #print cols
    img_size = rows * cols
    #print img_size

    hex_string = ""
    for i in xrange(0, img_size):
        byte = mnist_file.read(1)
        byte_str = format(ord(byte), 'x')
        if (len(byte_str) == 1):
            byte_str = "0" + byte_str
        hex_string = byte_str + hex_string

    mnist_file.close()
    print print_num(hex_string)
    return hex_string


if __name__ == "__main__":
    hex_file = open("./hex_strings.txt", "w")

    hex_string = mnist_to_bin("./t10k-images-idx3-ubyte")
    hex_file.write("'h" + hex_string + "\n")

    hex_file.close() 
    
