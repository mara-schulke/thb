import tkinter as tk
from tkinter import Button, Canvas, Frame, Label

from PIL import Image, ImageTk


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
        self.canvas = ZoomableCanvas(self) # Canvas(self, bd=0, highlightthickness=0, relief='ridge')
        self.canvas.grid(row=1, column=0, columnspan=4, sticky="nsew")

        # self.image = Image.new(mode="RGBA", size=(512, 512), color=(255,0,0));
        # self.photo = ImageTk.PhotoImage(self.image)
        # self.canvas.create_image(0, 0, image=self.photo, anchor="nw")

    def set_image(self, image):
        self.canvas = ZoomableCanvas(self, image)
        self.canvas.grid(row=1, column=0, columnspan=4, sticky="nsew")

    def reset(self):
        self.canvas.delete('all')


class AutoScrollbar(tk.Scrollbar):
    def set(self, lo, hi):
        if float(lo) <= 0.0 and float(hi) >= 1.0:
            self.grid_remove()
        else:
            self.grid()
            tk.Scrollbar.set(self, lo, hi)

    def pack(self, **kw):
        raise tk.TclError('Cannot use pack with this widget')

    def place(self, **kw):
        raise tk.TclError('Cannot use place with this widget')

class ZoomableCanvas(tk.Frame):
    def __init__(self, mainframe, image = None):
        tk.Frame.__init__(self, master=mainframe, bg='white')
        vbar = AutoScrollbar(self, orient='vertical')
        hbar = AutoScrollbar(self, orient='horizontal')
        vbar.grid(row=0, column=1, sticky='ns')
        hbar.grid(row=1, column=0, sticky='we')

        self.canvas = tk.Canvas(
            self,
            bg='white',
            highlightthickness=0,
            xscrollcommand=hbar.set,
            yscrollcommand=vbar.set
        )

        self.canvas.grid(row=0, column=0, sticky='nswe')
        self.canvas.update()

        vbar.configure(command=self.scroll_y)
        hbar.configure(command=self.scroll_x)

        self.rowconfigure(0, weight=1)
        self.columnconfigure(0, weight=1)

        self.canvas.bind('<Configure>', self.show_image)  # canvas is resized
        self.canvas.bind('<ButtonPress-1>', self.move_from)
        self.canvas.bind('<B1-Motion>', self.move_to)
        self.canvas.bind('<MouseWheel>', self.wheel)  # with Windows and MacOS, but not Linux
        self.canvas.bind('<Button-5>', self.wheel)  # only with Linux, wheel scroll down
        self.canvas.bind('<Button-4>', self.wheel)  # only with Linux, wheel scroll up
        self.focus_set()

        self.image = image

        if not self.image:
            self.image = Image.new(mode="RGBA", size=((512, 512)))

        self.width, self.height = self.image.size
        self.scale = 1.0 
        self.delta = 1.3
        self.container = self.canvas.create_rectangle(0, 0, self.width, self.height, width=0)
        self.show_image()

    def scroll_y(self, *args, **kwargs):
        self.canvas.yview(*args, **kwargs)  # scroll vertically
        self.show_image()  # redraw the image

    def scroll_x(self, *args, **kwargs):
        self.canvas.xview(*args, **kwargs)  # scroll horizontally
        self.show_image()  # redraw the image

    def move_from(self, event):
        self.canvas.scan_mark(event.x, event.y)

    def move_to(self, event):
        self.canvas.scan_dragto(event.x, event.y, gain=1)
        self.show_image()  # redraw the image

    def wheel(self, event):
        x = self.canvas.canvasx(event.x)
        y = self.canvas.canvasy(event.y)
        bbox = self.canvas.bbox(self.container)  # get image area
        if bbox[0] < x < bbox[2] and bbox[1] < y < bbox[3]: pass  # Ok! Inside the image
        else: return  # zoom only inside image area
        scale = 1.0
        # Respond to Linux (event.num) or Windows (event.delta) wheel event
        if event.num == 5 or event.delta == -120:  # scroll down
            i = min(self.width, self.height)
            if int(i * self.scale) < 30: return  # image is less than 30 pixels
            self.scale /= self.delta
            scale        /= self.delta
        if event.num == 4 or event.delta == 120:  # scroll up
            i = min(self.canvas.winfo_width(), self.canvas.winfo_height())
            if i < self.scale: return  # 1 pixel is bigger than the visible area
            self.scale *= self.delta
            scale        *= self.delta
        self.canvas.scale('all', x, y, scale, scale)  # rescale all canvas objects
        self.show_image()

    def show_image(self, event=None):
        bbox1 = self.canvas.bbox(self.container)
        bbox1 = (bbox1[0] + 1, bbox1[1] + 1, bbox1[2] - 1, bbox1[3] - 1)

        bbox2 = (self.canvas.canvasx(0),
                 self.canvas.canvasy(0),
                 self.canvas.canvasx(self.canvas.winfo_width()),
                 self.canvas.canvasy(self.canvas.winfo_height()))

        bbox = [min(bbox1[0], bbox2[0]), min(bbox1[1], bbox2[1]),
                max(bbox1[2], bbox2[2]), max(bbox1[3], bbox2[3])]
  
        # whole image in the visible area
        if bbox[0] == bbox2[0] and bbox[2] == bbox2[2]:
            bbox[0] = bbox1[0]
            bbox[2] = bbox1[2]

        # whole image in the visible area
        if bbox[1] == bbox2[1] and bbox[3] == bbox2[3]:
            bbox[1] = bbox1[1]
            bbox[3] = bbox1[3]

        self.canvas.configure(scrollregion=bbox)  # set scroll region

        x1 = max(bbox2[0] - bbox1[0], 0)
        y1 = max(bbox2[1] - bbox1[1], 0)
        x2 = min(bbox2[2], bbox1[2]) - bbox1[0]
        y2 = min(bbox2[3], bbox1[3]) - bbox1[1]

        if int(x2 - x1) > 0 and int(y2 - y1) > 0:
            x = min(int(x2 / self.scale), self.width)
            y = min(int(y2 / self.scale), self.height)

            image = self.image.crop((int(x1 / self.scale), int(y1 / self.scale), x, y))
            imagetk = ImageTk.PhotoImage(image.resize((int(x2 - x1), int(y2 - y1))))
            imageid = self.canvas.create_image(max(bbox2[0], bbox1[0]), max(bbox2[1], bbox1[1]),
                                               anchor="nw", image=imagetk)
            self.canvas.lower(imageid)
            self.canvas.imagetk = imagetk
