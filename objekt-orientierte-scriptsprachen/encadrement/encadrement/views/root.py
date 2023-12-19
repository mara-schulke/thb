import tkinter

import ttkbootstrap as ttk


class Root(ttk.Window):
    def __init__(self):
        super().__init__(themename="darkly")

        start_width = 600
        min_width = 400
        start_height = 600
        min_height = 400

        self.geometry(f"{start_width}x{start_height}")
        self.minsize(width=min_width, height=min_height)
        self.title("Encadrement")
        self.grid_columnconfigure(0, weight=1)
        self.grid_rowconfigure(0, weight=1)

