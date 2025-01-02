import tkinter as tk
from enum import Enum

from ..models.canvas import Effect
from ..models.main import Model
from ..views.main import View, ViewId
from .editor import EditorController


class Menu:
    """
    Represents the menu bar of the application, providing options for file operations and image effects.

    The menu is integrated into the application's main window and offers various functionalities like opening
    and saving files, applying image effects, and exiting the application.

    Attributes:
        controller: The main controller of the application that coordinates actions between the model and view.
        model (Model): The data model of the application, containing the state and logic.
        view (View): The UI view of the application, responsible for rendering the interface.
    """

    def __init__(self, controller, model: Model, view: View) -> None:
        """
        Initializes the Menu with a controller, model, and view, setting up the menu items and their actions.

        Parameters:
            controller: The main application controller that provides access to various components and actions.
            model (Model): The data model of the application, containing the state and logic.
            view (View): The UI view of the application, where the menu bar will be displayed.
        """

        bar = tk.Menu(view.root)

        file = tk.Menu(bar, tearoff=0)
        file.add_command(label="Open", command=controller.editor.open)
        file.add_command(label="Save as", command=controller.editor.save)
        file.add_separator()
        file.add_command(label="Exit", command=view.root.quit)

        fx = tk.Menu(bar, tearoff=0)
        fx.add_command(label="Grayscale", command=lambda: controller.editor.apply(Effect.GRAYSCALE))
        fx.add_command(label="Blur", command=lambda: controller.editor.apply(Effect.BLUR))
        fx.add_command(label="Contour", command=lambda: controller.editor.apply(Effect.CONTOUR))
        fx.add_command(label="Detail", command=lambda: controller.editor.apply(Effect.DETAIL))
        fx.add_command(label="Emboss", command=lambda: controller.editor.apply(Effect.EMBOSS))
        fx.add_command(label="Edge Enhance", command=lambda: controller.editor.apply(Effect.EDGE_ENHANCE))
        fx.add_command(label="Sharpen", command=lambda: controller.editor.apply(Effect.SHARPEN))
        fx.add_command(label="Smooth", command=lambda: controller.editor.apply(Effect.SMOOTH))

        bar.add_cascade(label="File", menu=file)
        bar.add_cascade(label="Effects", menu=fx)

        view.root.config(menu=bar)

class Controller:
    """
    The main controller for the application, orchestrating interactions between the model, view, and editor.

    This class initializes the main components of the application, including the editor and menu, and starts
    the application's main loop.

    Attributes:
        view (View): The UI view of the application, responsible for rendering the interface.
        model (Model): The data model of the application, containing the state and logic.
        editor (EditorController): The controller for the editor component, handling image editing actions.
        menu (Menu): The application's menu bar, providing options for file operations and image effects.
    """

    def __init__(self, model: Model, view: View) -> None:
        """
        Initializes the Controller with a model and view, setting up the editor and menu components.

        Parameters:
            model (Model): The data model of the application, containing the state and logic.
            view (View): The UI view of the application, responsible for rendering the interface.
        """

        self.view = view
        self.model = model
        self.editor = EditorController(model, view)
        self.menu = Menu(self, model, view)

    def start(self) -> None:
        """
        Starts the application by initiating the main loop of the UI view.
        """

        self.view.start()
