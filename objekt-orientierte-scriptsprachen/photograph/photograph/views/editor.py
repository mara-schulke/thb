import tkinter as tk

import ttkbootstrap as ttk
from PIL import Image, ImageTk

from .components.canvas import ZoomableCanvas
from .components.layers import Layers


class EditorView(tk.Frame):
    """
    A tkinter Frame that serves as the main view for an image editing application.

    This class sets up the user interface for an image editor, including buttons for open, save, clear,
    pen, and erasor functionalities, along with a zoomable canvas for image manipulation and a layers panel
    for managing different layers of the image.

    Attributes:
        top (tk.Frame): A frame to hold the top row of buttons.
        open (ttk.Button): Button to open an image.
        save (ttk.Button): Button to save the current image.
        clear (ttk.Button): Button to clear the canvas.
        pen (ttk.Button): Button to activate drawing mode.
        erasor (ttk.Button): Button to activate erasing mode.
        content (tk.Frame): A frame to hold the main content area, including the canvas and layers panel.
        canvas (ZoomableCanvas): A custom canvas widget that supports zooming and panning.
        layers (Layers): A panel for managing image layers.
    """

    def __init__(self, *args, **kwargs):
        """
        Initializes the EditorView, setting up the layout, buttons, canvas, and layers panel.
        """

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

        self.open = ttk.Button(self.top, bootstyle="dark", text="Open")
        self.open.grid(row=0, column=0, sticky="ew")
        self.save = ttk.Button(self.top, bootstyle="dark", text="Save")
        self.save.grid(row=0, column=1, sticky="ew")
        self.clear = ttk.Button(self.top, bootstyle="dark",text="Clear")
        self.clear.grid(row=0, column=2, sticky="ew")
        self.pen = ttk.Button(self.top, bootstyle="dark", text="Pen")
        self.pen.grid(row=0, column=3, sticky="ew")
        self.erasor = ttk.Button(self.top, bootstyle="dark", text="Erasor")
        self.erasor.grid(row=0, column=4, sticky="ew")

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
        )
        self.layers.grid(row=0, column=1, sticky="nsew")

    def set_layers(self, layers):
        """
        Updates the layers panel with a new set of layers.

        Parameters:
            layers (list[PIL.Image.Image]): A list of PIL Image objects representing the layers.
        """

        self.layers = Layers(
            self.content,
            layers,
            width=100,
        )
        self.layers.grid(row=0, column=1, sticky="nsew")

    def set_image(self, image, scale):
        """
        Sets the image to be displayed on the canvas and adjusts the zoom level.

        Parameters:
            image (PIL.Image.Image): The image to display on the canvas.
            scale (float, optional): The initial zoom level for the image. Defaults to 1.
        """

        self.canvas.image = image
        self.canvas.render()

    def reset(self):
        """
        Resets the editor view to its default state, including reinitializing the canvas and clearing layers.
        """

        self.canvas = ZoomableCanvas(self.content)
        self.canvas.grid(row=0, column=0, sticky="nsew")
