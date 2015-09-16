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

def wait():
    raw_input("Press ENTER to take a picture")

def snap(ramp_frames, camera):
    for i in xrange(ramp_frames):
        temp = get_image()

    wait()    
    print "Taking image..."
    camera_capture = get_image()
    print "Image captured"
    file = "/Users/kais/Development/Team-SDK-545/sw/camera/pics/test.png"
    cv2.imwrite(file, camera_capture)
    print "Image written"

    del(camera)

if __name__ == "__main__":
    camera = cv2.VideoCapture(DEF_CAMERA_PORT)
    snap(DEF_RAMP_FRAMES, camera)

"""
def snapshot(delay):
    

    if (not cap.isOpened()):
        print "Cannot open camera!"
        return

    # Set video to 320x240
    #cap.set(3, 320)
    #cap.set(4, 240)

    

    take_pic = False
    t0, filenum = 0, 1

    file_name = "~/Development/Team-SDK-545/sw/camera/pics/test.png"

    while (True):
        val, frame = cap.read()
        print val
        print frame
        #cv2.imshow("video", frame)
        
        cv2.imwrite(file_name, frame)

        key = cv2.waitKey(30)
        print "key " + str(key)

        if (key == ord(' ')):
            t0 = cv2.getTickCount()
            take_pic = True
        elif (key == ord('q')):
            break
 
        if (take_pic and ((cv2.getTickCount()-t0) / cv2.getTickFrequency()) > delay):
            cv2.imwrite(str(filenum) + ".jpg", frame)
            filenum += 1
            take_pic = False

        cap.release()

if __name__ == "__main__":
    snapshot(2)
"""
