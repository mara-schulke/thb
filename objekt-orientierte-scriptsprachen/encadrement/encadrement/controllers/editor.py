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

    # def on_mount(self) -> None:
        # if self.model.image.path:
            # self.frame.path.config(text=f"{self.model.image.path}")
        # else:
            # self.frame.path.config(text="No Image")

    # def on_update(self) -> None:
        # if self.model.image.path:
            # self.frame.path.config(text=f"{self.model.image.path}")
        # else:
            # self.frame.path.config(text="No Image")

    # def on_unmount(self) -> None:
        # pass

    def open(self) -> None:
        self.model.canvas.load(filedialog.askopenfilename())
        self.frame.set_image(self.model.canvas.layers[0])

    def save(self) -> None:
        file = filedialog.asksaveasfilename(defaultextension=".png")

        if file:
            self.model.canvas.save(file)

    def clear(self) -> None:
        self.frame.reset()
