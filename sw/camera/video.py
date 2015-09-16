"""
Author: Kais Kudrolli
Andrew ID: kkudroll

Description: Script that uses OpenCV to display webcam feed, take a snapshot,
and store it as a greyscaled image.

"""
import time
import cv2

DEF_CAP_DIR = "/Users/kais/Development/Team-SDK-545/sw/camera/pics/"

def get_video(video_capture):
    retval, frame = video_capture.read()
    return frame

def feed(video_capture, cap_dir):

    while (True):
        video = get_video(video_capture)
        gray = cv2.cvtColor(video, cv2.COLOR_BGR2GRAY)
        # need to flip otherwise does not match movements
        flipped_gray = cv2.flip(gray, 1) # vertical flip = 1

        cv2.imshow("Video", flipped_gray)
        
        if (cv2.waitKey(1) & 0xFF == ord(' ')):
            timestr = time.strftime("%Y%m%d-%H%M%S")
            cv2.imwrite(cap_dir + "cap" + timestr + ".png", flipped_gray)
            print "Image written!"
        elif (cv2.waitKey(1) & 0xFF == ord('q')):
            break
    
    video_capture.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    video_capture = cv2.VideoCapture(0)
    cap_dir = DEF_CAP_DIR
    feed(video_capture, cap_dir)
