# 20215853, mara.schulke@th-brandenburg.de

import tkinter as tk

from .controllers.main import Controller
from .models.main import Model
from .views.main import View


def main():
    """
    Entry point for the Photograph application.

    This function initializes the Model, View, and Controller components of the Photograph application,
    and then starts the application by invoking the Controller's start method.

    Usage:
        Run this script to launch the Photograph application.

    Example:
        $ poetry run photograph
    """

    model = Model()
    view = View()
    controller = Controller(model, view)
    controller.start()


if __name__ == "__main__":
    main()
