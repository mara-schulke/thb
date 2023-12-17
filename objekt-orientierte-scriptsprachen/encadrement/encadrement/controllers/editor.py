import tkinter as tk

from ..models.main import Model
from ..views.main import View, ViewId


class Menu:
    def __init__(self, controller, model: Model, view: View) -> None:
        menubar = tk.Menu(view.root)
        file_menu = tk.Menu(menubar, tearoff=0)

        file_menu.add_command(label="Open", command=controller.open)
        file_menu.add_command(label="Save as...", command=controller.save)

        file_menu.add_separator()
        file_menu.add_command(label="Exit", command=view.root.quit)
        menubar.add_cascade(label="File", menu=file_menu)
        view.root.config(menu=menubar)

class EditorController:
    def __init__(self, model: Model, view: View) -> None:
        self.model = model
        self.view = view
        self.frame = self.view.views[ViewId.EDITOR]
        self.menu = Menu(self, model, view)

        if self.model.image.path:
            self.frame.path.config(text=f"{self.model.image.path}")
        else:
            self.frame.path.config(text="No Image")

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
        self.frame.path.config(text="Some Image")
        pass

    def save(self) -> None:
        pass
