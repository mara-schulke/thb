import tkinter as tk

import ttkbootstrap as ttk
from PIL import Image, ImageTk


# note: this is currently unused due to simplification of the editor ui
class AutoScrollbar(ttk.Scrollbar):
    """
    A custom scrollbar that automatically hides itself when not needed.

    Extends the ttk.Scrollbar to only display the scrollbar when the content is larger than the
    visible area. It hides itself when the entire content fits within the visible area.
    """

    def set(self, lo, hi):
        """
        Sets the scrollbar's fraction to determine if it needs to be displayed.

        Parameters:
            lo (float): The lower fraction of the scrollbar.
            hi (float): The upper fraction of the scrollbar.
        """

        if float(lo) <= 0.0 and float(hi) >= 1.0:
            self.grid_remove()
        else:
            self.grid()
            ttk.Scrollbar.set(self, lo, hi)

    def pack(self, **kw):
        """
        Prevents using the pack geometry manager with this widget.

        Raises:
            ttk.TclError: When the pack method is called.
        """

        raise ttk.TclError('Cannot use pack with this widget')

    def place(self, **kw):
        """
        Prevents using the place geometry manager with this widget.

        Raises:
            ttk.TclError: When the place method is called.
        """

        raise ttk.TclError('Cannot use place with this widget')

class ZoomableCanvas(tk.Frame):
    """
    A tkinter Frame that contains a canvas which can display an image and support zooming functionality.

    This class provides a canvas within a tkinter frame that can display an image and allow the user
    to zoom in and out using keyboard shortcuts. The image is centered and scaled according to the
    zoom level.

    Attributes:
        mainframe: The parent widget.
        image (PIL.Image.Image): The image to be displayed on the canvas.
        scale (float): The initial scale of the image.
    """

    def __init__(self, mainframe, image = None, scale = 1, *args, **kwargs):
        """
        Initializes the ZoomableCanvas with a given parent, image, and scale.

        Parameters:
            mainframe: The parent widget.
            image (PIL.Image.Image, optional): The image to display. Defaults to a blank 512x512 RGBA image.
            scale (float, optional): The initial scale for the image. Defaults to 1.
        """

        tk.Frame.__init__(self, master=mainframe, *args, **kwargs)

        self.canvas = ttk.Canvas(
            self,
            highlightthickness=0,
        )

        self.canvas.grid(row=0, column=0, sticky='nswe')
        self.canvas.update()

        self.rowconfigure(0, weight=1)
        self.columnconfigure(0, weight=1)

        self.canvas.bind('<Configure>', self.render)  # canvas is resized
        self.bind('<Control-plus>', self.zoom_in)
        self.bind('<Control-minus>', self.zoom_out)
        self.focus_set()

        self.image = image

        if not self.image:
            self.image = Image.new(mode="RGBA", size=((512, 512)))

        self.width, self.height = self.image.size

        self.scale = scale
        self.delta = 1.2

        if not self.scale:
            self.scale = 1.0 

        self.container = self.canvas.create_rectangle(0, 0, self.width, self.height, width=0)
        self.render()

    def zoom(self, direction):
        """
        Adjusts the zoom level of the image based on the given direction.

        Parameters:
            direction (int): The direction to zoom. Positive values zoom in, negative values zoom out.
        """

        if direction < 0:
            i = min(self.width, self.height)
            if int(i * self.scale) < 64: return
            if self.scale < .2: return
            self.scale /= self.delta

        if direction > 0:
            i = min(self.canvas.winfo_width(), self.canvas.winfo_height())
            if i < self.scale: return
            if self.scale > 8: return
            self.scale *= self.delta

        self.canvas.scale(
            'all', 
            self.canvas.winfo_width() / 2,
            self.canvas.winfo_height() / 2,
            self.scale,
            self.scale
        )

        if self.onzoom is not None:
            self.onzoom(self.scale)

        self.render()

    def zoom_in(self, event=None):
        """
        Increases the zoom level of the image.

        Parameters:
            event: An optional event parameter for binding this method to an event.
        """

        self.zoom(1)

    def zoom_out(self, event=None):
       """
        Decreases the zoom level of the image.

        Parameters:
            event: An optional event parameter for binding this method to an event.
        """

        self.zoom(-1)

    def render(self, event=None):
        """
        Renders the image on the canvas at the current zoom level and centered.

        Parameters:
            event: An optional event parameter that triggers the rendering, such as window resizing.
        """

        cw = self.canvas.winfo_width()
        ch = self.canvas.winfo_height()
        w = int(self.width * self.scale)
        h = int(self.height * self.scale)
        x = int((cw - w) // 2)
        y = int((ch - h) // 2)

        image = self.image
        imagetk = ImageTk.PhotoImage(image.resize((w, h)))

        self.canvas.imageid = self.canvas.create_image(x, y, image=imagetk, anchor='nw')
        self.canvas.imagetk = imagetk
