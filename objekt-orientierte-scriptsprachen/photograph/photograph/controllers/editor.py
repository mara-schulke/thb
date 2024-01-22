import math
import time
import tkinter as tk
from tkinter import colorchooser, filedialog, messagebox
from tkinter.messagebox import askyesno, showerror

from PIL import Image, ImageDraw, ImageFilter, ImageGrab, ImageOps, ImageTk

from ..models.canvas import Effect
from ..models.editor import Mode
from ..models.main import Model
from ..views.main import View, ViewId


class EditorController:
    def __init__(self, model: Model, view: View) -> None:
        self.model = model
        self.view = view
        self.frame = self.view.get(ViewId.EDITOR)

        self.bind()

    def bind(self):
        self.frame.open.config(command=self.open)
        self.frame.save.config(command=self.save)
        self.frame.clear.config(command=self.clear)
        self.frame.pen.config(command=self.use_pen)
        self.frame.erasor.config(command=self.use_erasor)
        self.frame.layers.add.config(command=self.new_layer)
        self.frame.layers.rm.config(command=self.del_layer)

        self.render()

        self.model.canvas.listen("canvas::render", self.render)
        self.model.editor.listen("editor::mode", self.render)

    # listeners

    def render(self, *args) -> None:
        self.frame.set_image(self.model.canvas.merged(), self.model.canvas.scale)
        self.frame.set_layers(
            layers=self.model.canvas.layers,
        )

        self.frame.layers.add.config(command=self.new_layer)
        self.frame.layers.rm.config(command=self.del_layer)
        self.frame.canvas.onzoom = self.model.canvas.set_scale

        if self.model.editor.mode == Mode.VIEW:
            self.frame.pen.config(bootstyle="dark")
            self.frame.erasor.config(bootstyle="dark")
            self.frame.canvas.canvas.unbind("<B1-Motion>")
        elif self.model.editor.mode == Mode.DRAW:
            self.frame.pen.config(bootstyle="light")
            self.frame.erasor.config(bootstyle="dark")
            self.frame.canvas.canvas.bind("<B1-Motion>", self.draw)
        elif self.model.editor.mode == Mode.ERASE:
            self.frame.pen.config(bootstyle="dark")
            self.frame.erasor.config(bootstyle="light")
            self.frame.canvas.canvas.bind("<B1-Motion>", self.draw)

    # commands

    def open(self) -> None:
        self.model.canvas.load(filedialog.askopenfilename())

    def save(self) -> None:
        file = filedialog.asksaveasfilename(defaultextension=".png")

        if file:
            self.model.canvas.save(file)

    def clear(self) -> None:
        self.frame.reset()
        self.model.canvas.reset()

    def use_pen(self) -> None:
        self.model.canvas.scale = 1;
        self.model.editor.toggle_pen()

    def use_erasor(self) -> None:
        self.model.canvas.scale = 1;
        self.model.editor.toggle_erasor()

    # layers

    def apply(self, effect: Effect) -> None:
        self.model.canvas.apply(effect)

    def new_layer(self) -> None:
        self.model.canvas.new_layer()

    def del_layer(self) -> None:
        self.model.canvas.del_layer()

    # drawing

    def draw(self, ev) -> None:
        layer = self.model.canvas.layers[-1]
        draw = ImageDraw.Draw(layer)

        imx, imy = self.frame.canvas.canvas.coords(self.frame.canvas.canvas.imageid);
        imw, imh = self.model.canvas.size()

        if ev.x < imx or ev.y < imy:
            return
        
        if (imx + imw) < ev.x or (imy + imh) < ev.y:
            return

        x = ev.x - imx
        y = ev.y - imy


        if self.model.editor.mode == Mode.DRAW:
            radius = self.model.editor.pen.size
            fill = self.model.editor.pen.color.as_tk_color()
        elif self.model.editor.mode == Mode.ERASE:
            radius = 20
            fill = "white"

        draw.ellipse(
            (x-radius, y-radius, x+radius, y+radius), 
            fill=fill
        )

        # infer missed drawing events
        last_usage = self.model.editor.pen.last_usage
        now = time.time() * 1000

        if last_usage is not None and (now - last_usage) <= 100:
            lx, ly = self.model.editor.pen.last_coords
            # delta movements
            dx = x - lx
            dy = y - ly
            # delta vector
            dv = (dx, dy)
            # length of delta vector
            delta = math.sqrt(dx**2 + dy**2)

            for i in range(1, 1000):
                progress = i / 1000
                posx = x + (progress * dx)
                posy = y + (progress * dy)
                draw.ellipse(
                    (posx-radius, posy-radius, posx+radius, posy+radius), 
                    fill=fill
                )

        self.model.editor.pen.last_coords = (x, y)
        self.model.editor.pen.last_usage = now
        self.model.canvas.trigger("canvas::render")
