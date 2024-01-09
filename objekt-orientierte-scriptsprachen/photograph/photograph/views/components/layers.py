import tkinter as tk

import ttkbootstrap as ttk
from PIL import Image, ImageTk


class Layers(tk.Frame):
    def __init__(self, master, layers = None, active = 0, hidden = [], *args, **kwargs):
        super().__init__(master=master, *args, **kwargs)

        self.layers = layers

        if not self.layers:
            self.layers = [Image.new(mode="RGBA", size=((512, 512)))]

        self.grid_columnconfigure(0, weight=1, minsize=100)
        self.grid_rowconfigure(0, weight=0, minsize=50)

        self.add = ttk.Button(self, text="New Layer")
        self.add.grid(row=0, column=0, columnspan=1, sticky="nsew")

        self.canvas = []


        for i,layer in enumerate(self.layers[::-1]):
            self.canvas.append(
                tk.Canvas(self, width=100, height=100, highlightthickness=2, highlightbackground="black")
            )

            row = i + 1

            self.grid_rowconfigure(row, weight=0, minsize=100)
            self.canvas[i].grid(row=row, column=0, columnspan=1, sticky="nsew", pady=5)

            self.canvas[i].background = self.canvas[i].create_rectangle(0, 0, 100, 100, fill="#ffffff")

            image = ImageTk.PhotoImage(layer.resize((100,100)))
            self.canvas[i].imageid = self.canvas[i].create_image(0, 0, anchor="nw", image=image)
            self.canvas[i].image = image

            if (len(self.layers) - 1 - i) == active: 
                self.canvas[i].visibility = self.canvas[i].create_rectangle(0, 00, 10, 10, fill="#aaaaaa")

            # if i != len(self.layers) - 1:
                # self.canvas[i].remove = self.canvas[i].create_rectangle(90, 0, 100, 10, fill="#000000")
