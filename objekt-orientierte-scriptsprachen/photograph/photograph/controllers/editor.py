import tkinter as tk
from tkinter import colorchooser, filedialog, messagebox
from tkinter.messagebox import askyesno, showerror

from PIL import Image, ImageFilter, ImageGrab, ImageOps, ImageTk

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
        self.frame.layers.add.config(command=self.new_layer)

        self.render()

        self.model.canvas.listen("canvas::render", self.render)

    # listeners

    def render(self, *args) -> None:
        self.frame.set_image(self.model.canvas.merged())
        self.frame.set_layers(
            layers=self.model.canvas.layers,
            active=self.model.canvas.active,
            hidden=self.model.canvas.hidden,
        )

        self.frame.layers.add.config(command=self.new_layer)

        # todo: fix activation!!!!
        # for i, canvas in enumerate(self.frame.layers.canvas[::-1]):
            # layer = self.frame.layers.ca
            # self.frame.layers.canvas[i].bind("<Button-1>", lambda x: self.model.canvas.activate(i))

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

    # layers

    def new_layer(self) -> None:
        self.model.canvas.new_layer()
