import ttkbootstrap as ttk
from PIL import Image, ImageTk

from .components.canvas import ZoomableCanvas


class EditorView(ttk.Frame):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.grid_rowconfigure(0, weight=0, minsize=50)
        self.grid_rowconfigure(1, weight=1)
        self.grid_columnconfigure(0, weight=1)

        # buttons
        self.top = ttk.Frame(*args, **kwargs, height=50)
        self.top.grid(row=0, column=0, sticky="new")
        self.top.grid_columnconfigure(0, weight=1)
        self.top.grid_columnconfigure(1, weight=1)
        self.top.grid_columnconfigure(2, weight=1)
        self.top.grid_columnconfigure(3, weight=1)
        self.top.grid_columnconfigure(4, weight=1)

        self.open = ttk.Button(self.top, text="Open")
        self.open.grid(row=0, column=0, sticky="ew")
        self.save = ttk.Button(self.top, text="Save")
        self.save.grid(row=0, column=1, sticky="ew")
        self.clear = ttk.Button(self.top, text="Clear")
        self.clear.grid(row=0, column=2, sticky="ew")
        self.pen = ttk.Button(self.top, text="Pen")
        self.pen.grid(row=0, column=3, sticky="ew")
        self.select = ttk.Button(self.top, text="Select")
        self.select.grid(row=0, column=4, sticky="ew")

        self.canvas = ZoomableCanvas(self) # Canvas(self, bd=0, highlightthickness=0, relief='ridge')
        self.canvas.grid(row=1, column=0, columnspan=4, sticky="nsew", padx=10, pady=10)

    def set_image(self, image):
        self.canvas = ZoomableCanvas(self, image)
        self.canvas.grid(row=1, column=0, columnspan=4, sticky="nsew")
        pass

    def reset(self):
        self.canvas = ZoomableCanvas(self)
        self.canvas.grid(row=1, column=0, columnspan=4, sticky="nsew")
        pass
