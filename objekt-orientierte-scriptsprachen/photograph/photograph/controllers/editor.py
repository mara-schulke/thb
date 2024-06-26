import math
import time
import tkinter as tk
from tkinter import colorchooser, filedialog, messagebox
from tkinter.messagebox import askyesno, showerror

import numpy as np
from PIL import Image, ImageDraw, ImageFilter, ImageGrab, ImageOps, ImageTk
from scipy.interpolate import CubicSpline

from ..models.canvas import Effect
from ..models.editor import Mode
from ..models.main import Model
from ..views.main import View, ViewId


class EditorController:
    """
    Controls the interactions between the model and view in an image editing application,
    handling user inputs for image manipulation such as drawing, erasing, and layer management.

    Attributes:
        model (Model): The data model of the application.
        view (View): The UI view of the application.
        frame: The frame within the view dedicated to the editor.
    """

    def __init__(self, model: Model, view: View) -> None:
        """
        Initializes the EditorController with a given model and view, setting up the editor frame
        and binding UI elements to their respective commands.

        Parameters:
            model (Model): The data model of the application.
            view (View): The UI view of the application.
        """

        self.model = model
        self.view = view
        self.frame = self.view.get(ViewId.EDITOR)

        self.bind()

    def bind(self):
        """
        Binds UI elements to their respective command functions and sets up listeners for model updates.
        """

        self.frame.open.config(command=self.open)
        self.frame.save.config(command=self.save)
        self.frame.clear.config(command=self.clear)
        self.frame.pen.config(command=self.use_pen)
        self.frame.erasor.config(command=self.use_erasor)
        self.frame.layers.add.config(command=self.new_layer)
        self.frame.layers.rm.config(command=self.del_layer)

        self.render()

        self.model.canvas.listen("canvas::render", self.render)
        self.model.editor.listen("editor::mode", self.render)

    # listeners

    def render(self, *args) -> None:
        """
        Renders the canvas and updates UI elements based on the current state of the model. This method
        is called in response to model updates.

        Parameters:
            *args: Variable length argument list to accommodate various signals from the model.
        """

        self.frame.set_image(self.model.canvas.merged(), self.model.canvas.scale)
        self.frame.set_layers(
            layers=self.model.canvas.layers,
        )

        self.frame.layers.add.config(command=self.new_layer)
        self.frame.layers.rm.config(command=self.del_layer)
        self.frame.canvas.onzoom = self.model.canvas.set_scale

        if self.model.editor.mode == Mode.VIEW:
            self.frame.pen.config(bootstyle="dark")
            self.frame.erasor.config(bootstyle="dark")
            self.frame.canvas.canvas.unbind("<B1-Motion>")
        elif self.model.editor.mode == Mode.DRAW:
            self.frame.pen.config(bootstyle="light")
            self.frame.erasor.config(bootstyle="dark")
            self.frame.canvas.canvas.bind("<B1-Motion>", self.draw)
        elif self.model.editor.mode == Mode.ERASE:
            self.frame.pen.config(bootstyle="dark")
            self.frame.erasor.config(bootstyle="light")
            self.frame.canvas.canvas.bind("<B1-Motion>", self.draw)

    # commands

    def open(self) -> None:
        """
        Opens a dialog for the user to select an image file to load into the canvas.
        """

        self.model.canvas.load(filedialog.askopenfilename())

    def save(self) -> None:
        """
        Opens a dialog for the user to select a file path to save the current canvas state as an image.
        """

        file = filedialog.asksaveasfilename(defaultextension=".png")

        if file:
            self.model.canvas.save(file)

    def clear(self) -> None:
        """
        Clears the current drawing on the canvas and resets the editor state.
        """

        self.frame.reset()
        self.model.canvas.reset()

    def use_pen(self) -> None:
        """
        Sets the editor mode to drawing, allowing the user to draw on the canvas.
        """

        self.model.canvas.scale = 1;
        self.model.editor.toggle_pen()

    def use_erasor(self) -> None:
        """
        Sets the editor mode to erasing, allowing the user to erase parts of the drawing on the canvas.
        """

        self.model.canvas.scale = 1;
        self.model.editor.toggle_erasor()

    # layers

    def apply(self, effect: Effect) -> None:
        """
        Applies an effect to the canvas and redraws the ui.
        """
        self.model.canvas.apply(effect)

    def new_layer(self) -> None:
        """
        Adds a new layer to the canvas, allowing for non-destructive edits.
        """

        self.model.canvas.new_layer()

    def del_layer(self) -> None:
        """
        Removes the currently selected layer from the canvas.
        """

        self.model.canvas.del_layer()

    # drawing

    def draw(self, ev) -> None:
        """
        Handles the drawing action on the canvas when the user moves the mouse with the button pressed.
        This method captures the mouse position and draws on the current layer based on the editor mode.

        Parameters:
            ev: The event object containing information about the mouse event.
        """

        layer = self.model.canvas.layers[-1]
        draw = ImageDraw.Draw(layer)

        imx, imy = self.frame.canvas.canvas.coords(self.frame.canvas.canvas.imageid);
        imw, imh = self.model.canvas.size()

        if ev.x < imx or ev.y < imy:
            return
        
        if (imx + imw) < ev.x or (imy + imh) < ev.y:
            return

        # todo(mara.schulke): repair in zoom drawing
        x = (ev.x - imx) / self.model.canvas.scale
        y = (ev.y - imy) / self.model.canvas.scale

        if self.model.editor.mode == Mode.DRAW:
            radius = self.model.editor.pen.size
            fill = self.model.editor.pen.color.as_tk_color()
        elif self.model.editor.mode == Mode.ERASE:
            radius = 20
            fill = "white"

        draw.ellipse(
            (x-radius, y-radius, x+radius, y+radius), 
            fill=fill
        )

        self.interpolate_drawing(draw, (x, y), fill, radius)

        self.model.editor.pen.last_points.append((int(x), int(y)))
        self.model.editor.pen.last_usage = time.time() * 1000
        self.model.canvas.trigger("canvas::render")

    def interpolate_drawing(self, draw, ev: (int, int), fill: int, radius: int) -> None:
        """
        Performs cubic spline interpolation between the last drawn points to create a smooth drawing line.
        This method is called during the drawing action.

        Parameters:
            draw: The ImageDraw object used to draw on the canvas.
            ev: A tuple containing the current x and y coordinates of the mouse event.
            fill: The fill color to use for drawing.
            radius: The radius of the drawing tool.
        """

        x, y = ev

        last_usage = self.model.editor.pen.last_usage
        last_points = self.model.editor.pen.last_points

        now = time.time() * 1000

        if last_usage is None or (now - last_usage) >= 100:
            self.model.editor.pen.last_points = []
            return

        if len(last_points) < 2:
            return

        lx, ly = last_points[-1]
        dx, dy = x - lx, y - ly
        delta = math.sqrt(dx**2 + dy**2)

        if delta < 1:
            return

        xseries, yseries = zip(*last_points)
        xseries, yseries = np.array(xseries), np.array(yseries)

        # Perform cubic spline interpolation
        cs_x = CubicSpline(np.arange(len(xseries)), xseries)
        cs_y = CubicSpline(np.arange(len(yseries)), yseries)

        # Generate more points for a smoother line
        x_interp = cs_x(np.linspace(0, len(xseries) - 1, num=len(xseries) * 10))
        y_interp = cs_y(np.linspace(0, len(yseries) - 1, num=len(yseries) * 10))

        # Draw the smooth line
        for i in range(len(x_interp) - 1):
            draw.line(
                (x_interp[i], y_interp[i], x_interp[i+1], y_interp[i+1]),
                fill=fill,
                width=radius*2
            )

        while len(self.model.editor.pen.last_points) > 2:
            self.model.editor.pen.last_points.pop(0)
