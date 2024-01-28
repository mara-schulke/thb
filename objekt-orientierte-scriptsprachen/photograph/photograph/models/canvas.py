from enum import Enum
from tkinter import filedialog
from typing import TypedDict, Union

import PIL as pillow

from .base import ObservableModel


class Effect(Enum):
    """
    An enumeration of various image effects that can be applied to a canvas layer.

    Attributes:
        GRAYSCALE: Converts the image to grayscale.
        BLUR: Applies a blur effect to the image.
        CONTOUR: Highlights the contours within the image.
        DETAIL: Enhances the details of the image.
        EMBOSS: Applies an embossing effect to the image.
        EDGE_ENHANCE: Enhances the edges within the image.
        SHARPEN: Sharpens the image.
        SMOOTH: Applies a smoothing effect to the image.
    """

    GRAYSCALE = 0
    BLUR = 1
    CONTOUR = 2
    DETAIL = 3
    EMBOSS = 4
    EDGE_ENHANCE = 5
    SHARPEN = 6
    SMOOTH = 7

class Canvas(ObservableModel):
    """
    Represents a drawable canvas that supports multiple layers and various image effects.

    Inherits from ObservableModel to allow other components of the application to listen for
    and respond to changes in the canvas state.

    Attributes:
        width (int): The width of the canvas.
        height (int): The height of the canvas.
        scale (float): The current zoom level of the canvas.
        file (str): The file path of the currently loaded image, if any.
        layers (list[PIL.Image.Image]): A list of PIL Image layers that make up the canvas.
        hidden (list[bool]): A list indicating the visibility of each layer.
    """

    def __init__(self):
        """
        Initializes a new Canvas instance with default dimensions, scale, and a single white layer.
        """

        super().__init__()
        self.width = 512
        self.height = 512
        self.scale = 1
        self.file = ""
        self.layers = [pillow.Image.new(mode='RGBA', size=self.size(), color='white')]
        self.hidden = []
        self.trigger("canvas::update")

    def size(self) -> (int, int):
        """
        Returns the current size of the canvas as a tuple.

        Returns:
            tuple[int, int]: The width and height of the canvas.
        """

        return (self.width, self.height)

    def load(self, path: str) -> None:
        """
        Loads an image from the given file path and sets it as the only layer of the canvas.

        Parameters:
            path (str): The file path of the image to load.
        """

        if not path:
            return

        self.file = path
        self.layers = [pillow.Image.open(self.file).convert('RGBA')]
        self.hidden = []
        self.width, self.height = self.layers[0].size
        self.trigger("canvas::open")
        self.trigger("canvas::render")

    def merged(self):
        """
        Merges all visible layers into a single PIL Image and returns it.

        Returns:
            PIL.Image.Image: The merged image of all visible layers.
        """

        merged = pillow.Image.new('RGBA', self.size(), (0, 0, 0, 0))

        for layer in self.layers:
            merged.paste(layer, (0, 0), layer)

        return merged

    def save(self, path: str) -> None:
        """
        Saves the merged canvas image to the specified file path.

        Parameters:
            path (str): The file path where the image will be saved.
        """

        if not path:
            return

        self.merged().save(path)
        self.trigger("canvas::save")

    def reset(self) -> None:
        """
        Resets the canvas to its default state with one white layer.
        """

        self.width = 512
        self.height = 512
        self.scale = 1
        self.file = ""
        self.layers = [pillow.Image.new(mode='RGBA', size=self.size(), color="white")]
        self.hidden = []
        self.trigger("canvas::reset")
        self.trigger("canvas::render")

    # utils

    def set_scale(self, scale: int) -> None:
        """
        Sets the zoom level of the canvas.

        Parameters:
            scale (float): The new zoom level.
        """

        self.scale = scale

    # layers

    def apply(self, effect) -> None:
        """
        Applies the specified effect to the topmost layer of the canvas.

        Parameters:
            effect (Effect): The image effect to apply.
        """

        layer = self.layers[-1]

        if effect == Effect.GRAYSCALE:
            self.layers[-1] = pillow.ImageOps.grayscale(layer)
        elif effect == Effect.BLUR:
            self.layers[-1] = layer.filter(pillow.ImageFilter.BLUR)
        elif effect == Effect.CONTOUR:
            self.layers[-1] = layer.filter(pillow.ImageFilter.CONTOUR)
        elif effect == Effect.DETAIL:
            self.layers[-1] = layer.filter(pillow.ImageFilter.DETAIL)
        elif effect == Effect.EMBOSS:
            self.layers[-1] = layer.filter(pillow.ImageFilter.EMBOSS)
        elif effect == Effect.EDGE_ENHANCE:
            self.layers[-1] = layer.filter(pillow.ImageFilter.EDGE_ENHANCE)
        elif effect == Effect.SHARPEN:
            self.layers[-1] = layer.filter(pillow.ImageFilter.SHARPEN)
        elif effect == Effect.SMOOTH:
            self.layers[-1] = layer.filter(pillow.ImageFilter.SMOOTH)

        self.trigger("canvas::render")

    def new_layer(self) -> None:
        """
        Adds a new transparent layer on top of the existing layers.
        """

        self.layers.append(pillow.Image.new(mode='RGBA', size=self.size()))
        self.trigger("canvas::render")

    def del_layer(self) -> None:
        """
        Removes the topmost layer from the canvas, if there are multiple layers.
        """

        if len(self.layers) > 1:
            self.layers.pop()

        self.trigger("canvas::render")
