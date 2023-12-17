# 20215853, mara.schulke@th-brandenburg.de

import tkinter as tk

from .controllers.main import Controller
from .models.main import Model
from .views.main import View


def main():
    model = Model()
    view = View()
    controller = Controller(model, view)
    controller.start()


if __name__ == "__main__":
    main()
