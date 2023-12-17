import tkinter as tk

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
        pass

    def save(self) -> None:
        pass
