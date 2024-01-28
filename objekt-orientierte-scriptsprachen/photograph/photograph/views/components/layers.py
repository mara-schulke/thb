import tkinter as tk

import ttkbootstrap as ttk
from PIL import Image, ImageTk


class Layers(tk.Frame):
    """
    A custom tkinter Frame for managing and displaying layers of an image editing application.

    This class provides a UI component to add, remove, and display layers. Each layer is represented
    by a small preview canvas within this frame. Users can add new layers or remove existing ones
    using the provided '+' and '-' buttons.

    Attributes:
        master: The parent widget.
        layers (list[PIL.Image.Image]): A list of PIL Image objects representing the layers.
        hidden (list[bool]): A list indicating the visibility of each layer, not currently used.
    """

    def __init__(self, master, layers = None, hidden = [], *args, **kwargs):
        """
        Initializes the Layers frame with optional layers and hidden status lists.

        Parameters:
            master: The parent widget.
            layers (list[PIL.Image.Image], optional): The initial set of layers to display. Defaults to a single blank layer.
            hidden (list[bool], optional): The initial visibility status for each layer. Defaults to an empty list.
        """

        super().__init__(master=master, *args, **kwargs)

        self.layers = layers

        if not self.layers:
            self.layers = [Image.new(mode="RGBA", size=((512, 512)))]

        self.grid_columnconfigure(0, weight=1, minsize=50)
        self.grid_columnconfigure(1, weight=1, minsize=50)
        self.grid_rowconfigure(0, weight=0, minsize=25)

        self.add = ttk.Button(self, style="dark", text="+")
        self.add.grid(row=0, column=0, columnspan=1, sticky="nsew")

        self.rm = ttk.Button(self, style="dark", text="-")
        self.rm.grid(row=0, column=1, columnspan=1, sticky="nsew")

        self.canvas = []


        for i,layer in enumerate(self.layers[::-1]):
            self.canvas.append(
                tk.Canvas(self, width=100, height=100, highlightthickness=2, highlightbackground="black")
            )

            row = i + 1

            self.grid_rowconfigure(row, weight=0, minsize=100)
            self.canvas[i].grid(row=row, column=0, columnspan=2, sticky="nsew", pady=5)
            self.canvas[i].background = self.canvas[i].create_rectangle(0, 0, 100, 100, fill="#ffffff")

            image = ImageTk.PhotoImage(layer.resize((100,100)))
            self.canvas[i].imageid = self.canvas[i].create_image(0, 0, anchor="nw", image=image)
            self.canvas[i].image = image
