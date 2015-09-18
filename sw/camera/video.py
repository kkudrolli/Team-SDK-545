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
IMAGE_TYPE = ".png"
CAPTURE_KEY = ' '
QUIT_KEY = 'q'

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
capture: Function captures a frame and stores it as an image on disk.

Parameters:
- frame: Frame to be captured
- cap_dir: Directory to store captured frame

Return value:
- None
"""
def capture(frame, cap_dir):
    timestr = time.strftime(DEF_TIME_STR)
    cv2.imwrite(cap_dir + IMAGE_NAME + timestr + IMAGE_TYPE, frame)
    print "Image written!"

"""
get_key: Gets the key that was pressed and takes action if it was a 
         SPACE (capture) or 'q' (quit).

Parameters:
- frame: One frame from the video feed
- cap_dir: Directory to store captured image

Return Value:
- True if q was pressed for quit
- False otherwise 
"""
def get_key(frame, cap_dir):
    if (cv2.waitKey(WAIT_KEY_TIME) & 0xFF == ord(CAPTURE_KEY)):
        capture(frame, cap_dir)
        return False
    elif (cv2.waitKey(WAIT_KEY_TIME) & 0xFF == ord(QUIT_KEY)):
        return True
    else:
        return False

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
        # Greyscale the image
        gray = cv2.cvtColor(video, cv2.COLOR_BGR2GRAY)
        # Capture iamge must be flipped otherwise display is mirrored
        flipped_gray = cv2.flip(gray, VERTICAL_FLIP) 
        # Display the video feed
        cv2.imshow("Video", flipped_gray)
        
        # Capture the keys pressed and quit if get_key returns True
        if (get_key(flipped_gray, cap_dir)): 
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


