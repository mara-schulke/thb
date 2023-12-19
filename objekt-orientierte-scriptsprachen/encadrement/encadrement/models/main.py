from .canvas import Canvas
from .editor import Editor


class Model:
    def __init__(self):
        self.editor = Editor()
        self.canvas = Canvas()
