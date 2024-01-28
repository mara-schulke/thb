import math
import time
import tkinter as tk
from tkinter import colorchooser, filedialog, messagebox
from tkinter.messagebox import askyesno, showerror

import numpy as np
from PIL import Image, ImageDraw, ImageFilter, ImageGrab, ImageOps, ImageTk
from scipy.interpolate import CubicSpline

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

        # todo(mara.schulke): take scaling into account!
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

        self.interpolate_drawing(draw, (x, y), fill, radius)

        self.model.editor.pen.last_points.append((int(x), int(y)))
        self.model.editor.pen.last_usage = time.time() * 1000
        self.model.canvas.trigger("canvas::render")

    def interpolate_drawing(self, draw, ev: (int, int), fill: int, radius: int) -> None:
        x, y = ev

        last_usage = self.model.editor.pen.last_usage
        last_points = self.model.editor.pen.last_points

        now = time.time() * 1000

        if last_usage is None or (now - last_usage) >= 100:
            self.model.editor.pen.last_points = []
            return

        if len(last_points) < 2:
            return

        lx, ly = last_points[-1]
        dx, dy = x - lx, y - ly
        delta = math.sqrt(dx**2 + dy**2)

        if delta < 1:
            return

        xseries, yseries = zip(*last_points)
        xseries, yseries = np.array(xseries), np.array(yseries)

        # Perform cubic spline interpolation
        cs_x = CubicSpline(np.arange(len(xseries)), xseries)
        cs_y = CubicSpline(np.arange(len(yseries)), yseries)

        # Generate more points for a smoother line
        x_interp = cs_x(np.linspace(0, len(xseries) - 1, num=len(xseries) * 10))
        y_interp = cs_y(np.linspace(0, len(yseries) - 1, num=len(yseries) * 10))

        # Draw the smooth line
        for i in range(len(x_interp) - 1):
            draw.line(
                (x_interp[i], y_interp[i], x_interp[i+1], y_interp[i+1]),
                fill=fill,
                width=radius*2
            )

        while len(self.model.editor.pen.last_points) > 2:
            self.model.editor.pen.last_points.pop(0)
