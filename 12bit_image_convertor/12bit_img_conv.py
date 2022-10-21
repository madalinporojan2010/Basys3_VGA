from PIL import Image
# from tkinter import Tk for Python 3.x
from tkinter import Tk, dialog, messagebox
from tkinter.filedialog import askopenfilename
import sys

Tk().withdraw()
img_PATH = askopenfilename(defaultextension=".jpg", initialdir="../img_src")

if len(img_PATH) > 0:

    original_stdout = sys.stdout

    im = Image.open(img_PATH)

    im = im.resize((320, 240))
    pixels = im.load()

    for x in range(im.size[0]):
        for y in range(im.size[1]):
            pixels[x, y] = tuple(((color & 0x000000F0) >> 4)
                                 for color in pixels[x, y])

    path = img_PATH.split("/")
    change_extension = path[-1].split(".")
    change_extension[-1] = ".coe"

    dataFile_name = "".join(change_extension)

    with open("../VGA-Project.srcs/sources_1/ip/" + dataFile_name, 'w') as f:
        sys.stdout = f
        print("memory_initialization_radix=16;")
        print("memory_initialization_vector=")
        for y in range(im.size[1]):
            for x in range(im.size[0]):
                print("{:03X}".format((pixels[x, y][0] << 8) | (
                    pixels[x, y][1] << 4) | (pixels[x, y][2])), end="")

                if (y != im.size[1] - 1) or (x != im.size[0] - 1):
                    print(",")

        print(";", end="")
    messagebox.showinfo(
        title="Success", message="Check [../VGA-Project.srcs/sources_1/ip/]" + dataFile_name)
