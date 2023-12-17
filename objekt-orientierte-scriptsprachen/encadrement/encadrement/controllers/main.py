from ..models.main import Model
from ..views.main import View, ViewId
from .editor import EditorController


class Controller:
    def __init__(self, model: Model, view: View) -> None:
        self.view = view
        self.model = model
        self.controller = {
            ViewId.EDITOR: EditorController(model, view)
        }

    def start(self) -> None:
        self.view.start()
