"""
Author: Kais Kudrolli
Andrew ID: kkudroll

Description: Script that take a snapshot using your webcam, using OpenCV.

"""

import cv2

DEF_RAMP_FRAMES = 30
DEF_CAMERA_PORT = 0

def get_image():
    retval, im = camera.read()
    return im

def snap(ramp_frames, camera):
    for i in xrange(ramp_frames):
        temp = get_image()

    raw_input("Press ENTER to take image") 
    print "Taking image..."
    camera_capture = get_image()
    print "Image captured"
    file = "/Users/kais/Development/Team-SDK-545/sw/camera/pics/test.png"
    cv2.imwrite(file, camera_capture)
    print "Image written"

    # Grayscale
    raw_input("Press ENTER to grayscale your image") 
    gray_image = cv2.cvtColor(camera_capture, cv2.COLOR_BGR2GRAY)
    gray_file = "/Users/kais/Development/Team-SDK-545/sw/camera/pics/test_gray.png"
    cv2.imwrite(gray_file, gray_image)

    del(camera)

if __name__ == "__main__":
    camera = cv2.VideoCapture(DEF_CAMERA_PORT)
    snap(DEF_RAMP_FRAMES, camera)

