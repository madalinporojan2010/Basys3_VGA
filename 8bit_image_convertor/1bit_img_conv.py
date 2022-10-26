from PIL import Image
# from tkinter import Tk for Python 3.x
from tkinter import Tk, messagebox
from tkinter.filedialog import askopenfilenames
import sys

Tk().withdraw()
img_PATHS = askopenfilenames(defaultextension=".jpg", initialdir="../img_src")
original_stdout = sys.stdout

if len(img_PATHS) == 5:
    data: str = [""] * 640 * 480
    for img_PATH in img_PATHS:
        length = 0
        im = Image.open(img_PATH)

        im = im.resize((640, 480))
        im = im.convert("1")

        pixels = im.load()
        for y in range(im.size[1]):
            for x in range(im.size[0]):
                data[length] = str(str(data[length]) +
                                   str(1 if pixels[x, y] == 255 else 0))
                length = length + 1

    newData = ",\n".join(data)
    with open("../VGA-Project.srcs/sources_1/ip/c1bit_img.coe", 'w') as f:
        sys.stdout = f
        print("memory_initialization_radix=2;")
        print("memory_initialization_vector=")
        print(newData, end="")
        print(";", end="")
    messagebox.showinfo(
        title="Success", message="Check [../VGA-Project.srcs/sources_1/ip/c1bit_img.coe]")
