import tkinter as tk

import ttkbootstrap as ttk
from PIL import Image, ImageTk

from .components.canvas import ZoomableCanvas
from .components.layers import Layers


class EditorView(tk.Frame):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.grid_rowconfigure(0, weight=0)
        self.grid_rowconfigure(1, weight=1)
        self.grid_columnconfigure(0, weight=1)

        # buttons
        self.top = tk.Frame(self)
        self.top.grid(row=0, column=0, sticky="nsew")
        self.top.grid_columnconfigure(0, weight=1)
        self.top.grid_columnconfigure(1, weight=1)
        self.top.grid_columnconfigure(2, weight=1)
        self.top.grid_columnconfigure(3, weight=1)
        self.top.grid_columnconfigure(4, weight=1)

        self.open = ttk.Button(self.top, text="Open")
        self.open.grid(row=0, column=0, sticky="ew")
        self.save = ttk.Button(self.top, text="Save")
        self.save.grid(row=0, column=1, sticky="ew")
        self.clear = ttk.Button(self.top, text="Clear")
        self.clear.grid(row=0, column=2, sticky="ew")
        self.pen = ttk.Button(self.top, text="Pen")
        self.pen.grid(row=0, column=3, sticky="ew")
        self.select = ttk.Button(self.top, text="Select")
        self.select.grid(row=0, column=4, sticky="ew")

        self.content = tk.Frame(self)
        self.content.grid(row=1, column=0, sticky="nsew")
        self.content.grid_rowconfigure(0, weight=1)
        self.content.grid_columnconfigure(0, weight=1)
        self.content.grid_columnconfigure(1, weight=0)

        self.canvas = ZoomableCanvas(
            self.content,
            highlightbackground="black",
            highlightthickness=1
        )
        self.canvas.grid(row=0, column=0, sticky="nsew")

        self.layers = Layers(
            self.content,
            width=100,
            highlightbackground="red",
            highlightthickness=1
        )
        self.layers.grid(row=0, column=1, sticky="nsew")

    def set_layers(self, layers, active, hidden):
        self.layers = Layers(
            self.content,
            layers,
            active,
            hidden,
            width=100,
            highlightbackground="red",
            highlightthickness=1
        )
        self.layers.grid(row=0, column=1, sticky="nsew")

    def set_image(self, image):
        self.canvas = ZoomableCanvas(self.content, image)
        self.canvas.grid(row=0, column=0, sticky="nsew")

    def reset(self):
        self.canvas = ZoomableCanvas(self.content)
        self.canvas.grid(row=0, column=0, sticky="nsew")
