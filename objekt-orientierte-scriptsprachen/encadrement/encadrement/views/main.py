from enum import Enum
from typing import TypedDict

from .editor import EditorView
from .root import Root


class Views(TypedDict):
    editor: EditorView

class ViewId(Enum):
    EDITOR = "editor"

class View:
    def __init__(self):
        self.root = Root()
        self.views: Views = {}
        self.register(EditorView, ViewId.EDITOR)

    def register(self, V, id: ViewId) -> None:
        self.views[id] = V(self.root)
        self.views[id].grid(row=0, column=0, sticky="nsew")

    def switch(self, id: ViewId) -> None:
        self.views[id].tkraise()

    def start(self) -> None:
        self.root.mainloop()
