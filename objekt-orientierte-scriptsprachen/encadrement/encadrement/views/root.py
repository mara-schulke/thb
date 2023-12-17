from tkinter import Frame, Tk


class Root(Tk):
    def __init__(self):
        super().__init__()

        start_width = 600
        min_width = 400
        start_height = 600
        min_height = 400

        self.geometry(f"{start_width}x{start_height}")
        self.minsize(width=min_width, height=min_height)
        self.maxsize(width=start_width, height=start_height)
        self.title("Encadrement")
        self.grid_columnconfigure(0, weight=1)
        self.grid_rowconfigure(0, weight=1)

