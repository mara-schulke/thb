# 20215853, mara.schulke@th-brandenburg.de

import tkinter as tk
from tkinter import Frame, colorchooser, filedialog, messagebox
from tkinter.messagebox import askyesno, showerror

from PIL import Image, ImageFilter, ImageGrab, ImageOps, ImageTk

WIDTH = 750
HEIGHT = 560
STATE = State()

class State:
    file_path = ""
    pen_size = 3
    pen_color = "black"

class Menubar(tk.Frame):
    def __init__(self, root=None):
        tk.Frame.__init__(self, root)

        self.columnconfigure(0)
        self.columnconfigure(1)
        self.columnconfigure(2)
        self.columnconfigure(3)
        self.grid()

        self.open = tk.Button(self, text='Open', command=self.quit)
        self.open.grid(row=0, column=0, columnspan=3, sticky=tk.N+tk.E+tk.S+tk.W)

class Editor(tk.Frame):
    def __init__(self, root=None):
        tk.Frame.__init__(self, root)
        self.grid()
        self.createWidgets()

    def createWidgets(self):
        self.quitButton = tk.Button(self, text='Quit',
            command=self.quit)
        self.quitButton.grid()

class Layout(tk.Frame):
    def __init__(self, root):
        tk.Frame.__init__(self, root)
        self.grid()

        self.top = Frame(self, height=50)
        self.top.pack()
        self.bottom = Frame(self)
        self.bottom.pack(side=tk.BOTTOM)

root = tk.Tk()
root.title('Encadrement')
root.geometry("800x800")

layout = Layout(root)
layout.pack()

Menubar(layout.top).pack()
Editor(layout.bottom).pack()


# app = Application(root)
# app.pack()

root.mainloop()


class ImageEditor:
    def __init__(self, root):
        self.root = root
        self.root.title("")
        self.root.resizable(False, False)

        self.image = None
        self.photo = None

        self.image_path = ""


        self.canvas = tk.Canvas(bottomFrame, bg='gray', width=800, height=800)
        self.canvas.pack(fill=tk.BOTH, expand=True)

        menubar = tk.Menu(root)
        file_menu = tk.Menu(menubar, tearoff=0)
        file_menu.add_command(label="Open", command=self.open_image)
        file_menu.add_command(label="Save as...", command=self.save_image_as)
        file_menu.add_command(label="Resize", command=self.resize_image)
        file_menu.add_separator()
        file_menu.add_command(label="Exit", command=root.quit)
        menubar.add_cascade(label="File", menu=file_menu)

        self.open_button = tk.Button(topFrame, text="Open Image", command=self.open_image)
        self.open_button.pack(side=tk.LEFT, padx=5, pady=5)
        self.resize_button = tk.Button(topFrame, text="Resize Image", command=self.resize_image)
        self.resize_button.pack(side=tk.LEFT, padx=5, pady=5)
        self.save_button = tk.Button(topFrame, text="Save Image As...", command=self.save_image_as)
        self.save_button.pack(side=tk.LEFT, padx=5, pady=5)

        root.config(menu=menubar)

    def open_image(self):
        self.image_path = filedialog.askopenfilename()
        if self.image_path:
            self.image = Image.open(self.image_path)
            self.photo = ImageTk.PhotoImage(self.image.resize((200, 200)), self.image)
            self.canvas.create_image(0, 0, image=self.photo, anchor=tk.NW)

    def save_image_as(self):
        if self.image:
            filepath = filedialog.asksaveasfilename(defaultextension=".png")
            if filepath:
                self.image.save(filepath)

    def resize_image(self):
        if self.image:
            new_size = tk.simpledialog.askstring("Resize", "Enter new size (width,height):")
            if new_size:
                width, height = map(int, new_size.split(','))
                self.image = self.image.resize((width, height))
                self.photo = ImageTk.PhotoImage(self.image)
                self.canvas.create_image(0, 0, image=self.photo, anchor=tk.NW)
                self.root.geometry(f"{width}x{height}")

# if __name__ == "__main__":
    # root = tk.Tk()
    # app = ImageEditor(root)
    # root.mainloop()