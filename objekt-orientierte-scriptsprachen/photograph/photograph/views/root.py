import tkinter

import ttkbootstrap as ttk


class Root(ttk.Window):
    """
    The main application window.

    This class represents the main application window of the Photograph application. It inherits from ttkbootstrap's
    Window class and provides customization for the window's appearance and behavior.

    Attributes:
        themename (str): The theme name for styling the application window.
    """

    def __init__(self):
        """
        Initializes the main application window.

        Parameters:
            themename (str, optional): The theme name for styling the application window. Defaults to "darkly".
        """

        super().__init__(themename="darkly")

        start_width = 600
        min_width = 400
        start_height = 600
        min_height = 400

        self.geometry(f"{start_width}x{start_height}")
        self.minsize(width=min_width, height=min_height)
        self.title("Photograph")
        self.grid_columnconfigure(0, weight=1)
        self.grid_rowconfigure(0, weight=1)

