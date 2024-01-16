import tkinter as tk

import ttkbootstrap as ttk
from PIL import Image, ImageTk


class AutoScrollbar(ttk.Scrollbar):
    def set(self, lo, hi):
        if float(lo) <= 0.0 and float(hi) >= 1.0:
            self.grid_remove()
        else:
            self.grid()
            ttk.Scrollbar.set(self, lo, hi)

    def pack(self, **kw):
        raise ttk.TclError('Cannot use pack with this widget')

    def place(self, **kw):
        raise ttk.TclError('Cannot use place with this widget')

class ZoomableCanvas(tk.Frame):
    def __init__(self, mainframe, image = None, scale = 1, *args, **kwargs):
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
        self.zoom(1)

    def zoom_out(self, event=None):
        self.zoom(-1)

    def render(self, event=None):
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
