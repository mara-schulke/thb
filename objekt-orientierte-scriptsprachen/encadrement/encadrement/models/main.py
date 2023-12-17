from .editor import Editor
from .image import Image


class Model:
    def __init__(self):
        self.editor = Editor()
        self.image = Image()
