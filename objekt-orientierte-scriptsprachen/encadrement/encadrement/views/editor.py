from tkinter import Button, Canvas, Frame, Label


class EditorView(Frame):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.grid_rowconfigure(0, weight=0, minsize=50)
        self.grid_rowconfigure(1, weight=1)
        self.grid_columnconfigure(0, weight=1)

        # buttons
        self.top = Frame(*args, **kwargs, height=50)
        self.top.grid(row=0, column=0, sticky="new")
        self.top.grid_columnconfigure(0, weight=1)
        self.top.grid_columnconfigure(1, weight=1)
        self.top.grid_columnconfigure(2, weight=1)
        self.top.grid_columnconfigure(3, weight=1)
        self.top.grid_columnconfigure(4, weight=1)

        self.open = Button(self.top, text="Open")
        self.open.grid(row=0, column=0, padx=10, pady=10, sticky="ew")
        self.save = Button(self.top, text="Save")
        self.save.grid(row=0, column=1, padx=10, pady=10, sticky="ew")
        self.clear = Button(self.top, text="Clear")
        self.clear.grid(row=0, column=2, padx=10, pady=10, sticky="ew")
        self.pen = Button(self.top, text="Pen")
        self.pen.grid(row=0, column=3, padx=10, pady=10, sticky="ew")
        self.select = Button(self.top, text="Select")
        self.select.grid(row=0, column=4, padx=10, pady=10, sticky="ew")

        # canvas
        self.canvas = Canvas(self, bg='white', bd=0, highlightthickness=0, relief='ridge')
        self.canvas.grid(row=1, column=0, columnspan=4, sticky="nsew")

