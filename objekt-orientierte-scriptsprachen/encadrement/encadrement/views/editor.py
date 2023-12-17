from tkinter import Button, Canvas, Frame, Label


class Layout(Frame):
    def __init__(self, root):
        Frame.__init__(self, root)
        self.grid()

        self.top = Frame(self, height=50)
        self.top.pack()
        self.bottom = Frame(self)
        self.bottom.pack(side=tk.BOTTOM)

class EditorView(Frame):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.grid_columnconfigure(0, weight=1)

        self.header = Label(self, text="Editor")
        self.header.grid(row=0, column=0, padx=10, pady=10, sticky="ew")

        self.canvas = Canvas(self, bg='gray', width=200, height=200)
        self.canvas.grid(row=1, column=0, sticky="nsew")

        self.path = Label(self, text=f"")
        self.path.grid(row=2, column=0, sticky="ew")
