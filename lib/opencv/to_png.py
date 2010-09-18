import sys
import re
sys.path.append("/usr/local/lib/python2.6/site-packages")
import cv

jpg_file = sys.argv[1]
print jpg_file
png_file_name = re.sub("\.\w*$", '.png', jpg_file)
print png_file_name
img = cv.LoadImageM(jpg_file)
cv.SaveImage(png_file_name, img)

