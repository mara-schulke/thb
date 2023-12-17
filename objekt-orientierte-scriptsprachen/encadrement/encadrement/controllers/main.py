import tkinter as tk

from ..models.main import Model
from ..views.main import View, ViewId
from .editor import EditorController


class Menu:
    def __init__(self, controller, model: Model, view: View) -> None:
        bar = tk.Menu(view.root)

        file = tk.Menu(bar, tearoff=0)
        file.add_command(label="Open", command=controller.editor.open)
        file.add_command(label="Save as", command=controller.editor.save)
        file.add_separator()
        file.add_command(label="Exit", command=view.root.quit)

        bar.add_cascade(label="File", menu=file)

        view.root.config(menu=bar)

class Controller:
    def __init__(self, model: Model, view: View) -> None:
        self.view = view
        self.model = model

        self.editor = EditorController(model, view)
        self.menu = Menu(self, model, view)

    def start(self) -> None:
        self.view.start()
