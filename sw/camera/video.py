"""
Author: Kais Kudrolli
Andrew ID: kkudroll

Description: Script that uses OpenCV to display webcam feed, take a snapshot,
and store it as a greyscaled image.

"""

import time
import cv2

# Constants so that setup can be easily configured
WEBCAM_CAMERA_NUM = 0
DEF_CAP_DIR = "./pics/"
VERTICAL_FLIP = 1
WAIT_KEY_TIME = 1
IMAGE_NAME = "cap"
DEF_TIME_STR = "%Y%m%d-%H%M%S"
IMAGE_TYPE = ".bmp"
CAPTURE_KEY = ' '
QUIT_KEY = 'q'
NORM_MIN = 0
NORM_MAX = 255
DOWN_AMOUNT = 4

"""
get_video: Reads a frame of video input from the camera and returns it.

Parameters:
- video_capture: instance of class VideoCapture used to capture video
                 from cameras

Return value:
- a video frame
"""
def get_video(video_capture):
    retval, frame = video_capture.read()
    return frame

"""
grayscale: Grayscale an image using a naive averaging algorithm.

Parameters:
- frame: image to be grayscaled

Return value: 
- greyscaled image
"""
def grayscale(frame):
    # TODO: This is slow but for now only happens once
    x, y, z = frame.shape
    for i in xrange(0, x):
        for j in xrange(0, y):
            # Naive grayscale avgs BGR values together
            b = frame.item(i, j, 0)
            g = frame.item(i, j, 1)
            r = frame.item(i, j, 2)
            avg = (b + g + r) // z
            frame.itemset((i, j, 0), avg)
            frame.itemset((i, j, 1), avg)
            frame.itemset((i, j, 2), avg)

    return frame

"""
manipulate: Grayscales, normalizes, downsizes the image before it is stored.

Parameters:
- frame: Frame to be captured
- cap_dir: Directory to store captured frame

Return value:
- None
"""
def manipulate(frame):
    # Grayscale the image using a naive averaging method
    gray = grayscale(frame)

    # Normalize the image, this ensures the colors are in a 
    # certain range of values. Normalization is necessary so that
    # images that are too bright or too dark do not mess up 
    # classification.
    cv2.normalize(gray, gray, 0, 255, cv2.NORM_MINMAX)

    # Downsize the image, using image pyramids, this function has 
    # anti-aliasing built in
    # TODO: resize so that number is recognizable
    resized = cv2.pyrDown(gray)
    for i in xrange(0, DOWN_AMOUNT - 1):
        resized = cv2.pyrDown(resized)
        i += 1
        """
    resized = cv2.resize(gray, (28, 28))   
    """
    return resized

"""
capture: Function captures a frame and stores it as an image on disk.

Parameters:
- frame: Frame to be captured
- cap_dir: Directory to store captured frame

Return value:
- None
"""
def capture(frame, cap_dir):
    timestr = time.strftime(DEF_TIME_STR)
    man_frame = manipulate(frame) 
    cv2.imwrite(cap_dir + IMAGE_NAME + timestr + IMAGE_TYPE, man_frame)
    print "Image written!"
    
"""
get_key: Gets the key that was pressed and takes action if it was a 
         SPACE (capture) or 'q' (quit).

Parameters:
- original: One frame from the video feed
- cap_dir: Directory to store captured image

Return Value:
- True if q was pressed for quit
- False otherwise 
"""
def get_key(original, cap_dir):
    wait = cv2.waitKey(WAIT_KEY_TIME) & 0xFF 
    if (wait == ord(CAPTURE_KEY)):
        capture(original, cap_dir)
        return False
    elif (wait == ord(QUIT_KEY)):
        return True
    else:
        return False
      
    """
    if (cv2.waitKey(WAIT_KEY_TIME) & 0xFF == ord(CAPTURE_KEY)):
        capture(original, cap_dir)
        return False
    elif (cv2.waitKey(WAIT_KEY_TIME) & 0xFF == ord(QUIT_KEY)):
        return True
    else:
        return False

    """
"""
feed: Function that runs a feed loop to continuously capture and display
      video frames.

Parameters:
- video_capture: VideoCapture object
- cap_dir: directory where captured image would be put

Return value:
- None
"""
def feed(video_capture, cap_dir):
    while (True):
        video = get_video(video_capture)
        # Capture image must be flipped otherwise display is mirrored
        flipped = cv2.flip(video, VERTICAL_FLIP)        
        # Greyscale the image
        gray = cv2.cvtColor(flipped, cv2.COLOR_BGR2GRAY)

        # Display the video feed - grayscaled image displayed will
        # be slightly different from what is stored to disk
        cv2.imshow("Video", gray)
        
        # Capture the keys pressed and quit if get_key returns True
        if (get_key(flipped, cap_dir)): 
            break
    
    # Clean up
    video_capture.release()
    cv2.destroyAllWindows()

# Main function to start video feed capture
if __name__ == "__main__":
    # Some of these parameters that could have just been made
    # global constants are passed to feed so later we can 
    # take arguments from command line or use the default
    # constants in this file
    video_capture = cv2.VideoCapture(WEBCAM_CAMERA_NUM)
    cap_dir = DEF_CAP_DIR
    feed(video_capture, cap_dir)


