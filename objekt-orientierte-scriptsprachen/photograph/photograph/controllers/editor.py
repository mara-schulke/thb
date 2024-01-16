import tkinter as tk
from tkinter import colorchooser, filedialog, messagebox
from tkinter.messagebox import askyesno, showerror

from PIL import Image, ImageDraw, ImageFilter, ImageGrab, ImageOps, ImageTk

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
        self.frame.pen.config(command=self.toggle_mode)
        self.frame.layers.add.config(command=self.new_layer)

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
        self.frame.canvas.onzoom = self.model.canvas.set_scale

        if self.model.editor.mode == Mode.VIEW:
            self.frame.pen.config(bootstyle="dark")
            self.frame.canvas.canvas.unbind("<B1-Motion>")
        elif self.model.editor.mode == Mode.DRAW:
            def draw(ev):
                def draw_inner():
                    layer = self.model.canvas.layers[-1]
                    draw = ImageDraw.Draw(layer)

                    imx, imy = self.frame.canvas.canvas.coords(self.frame.canvas.canvas.imageid);
                    imw, imh = self.model.canvas.size()

                    print(imx, imy, imw, imh, self.frame.canvas.size())

                    if ev.x < imx or ev.y < imy:
                        print("imx or imy to big")
                        return
                    
                    if (imx + imw) < ev.x or (imy + imh) < ev.y:
                        print("evx or evy oob")
                        return

                    relx = ev.x - imx
                    rely = ev.y - imy

                    print(relx, rely)

                    x, y, radius = relx, rely, 5

                    # print(ev.x, ev.y)

                    draw.ellipse((x-radius, y-radius, x+radius, y+radius), fill='black')
                    print("drew ellipse")
                    self.model.canvas.trigger("canvas::render")

                # self.frame.after(25, draw_inner)
                draw_inner()


            self.frame.pen.config(bootstyle="light")
            self.frame.canvas.canvas.bind("<B1-Motion>", draw)

    # commands

    def open(self) -> None:
        self.model.canvas.load(filedialog.askopenfilename())

    def save(self) -> None:
        file = filedialog.asksaveasfilename(defaultextension=".png")

        if file:
            self.model.canvas.save(file)

    def clear(self) -> None:
        self.model.canvas.reset()
        self.frame.reset()

    def toggle_mode(self) -> None:
        self.model.editor.toggle_mode()

    # layers

    def new_layer(self) -> None:
        self.model.canvas.new_layer()
