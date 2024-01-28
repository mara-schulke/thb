from enum import Enum
from typing import TypedDict

from .editor import EditorView
from .root import Root


class Views(TypedDict):
    editor: EditorView

class ViewId(Enum):
    EDITOR = "editor"

class View:
    """
    The main application view manager that handles different views and their switching.

    This class manages multiple views in an application and provides methods for registering, accessing, and
    switching between them. It also controls the main application loop.

    Attributes:
        root (Root): The main application window.
        views (Views): A dictionary that stores registered views.
    """

    def __init__(self):
        """
        Initializes the View manager with an empty views dictionary and creates the main application window.
        """

        self.root = Root()
        self.views: Views = {}
        self.register(EditorView, ViewId.EDITOR)

    def register(self, V, id: ViewId) -> None:
        """
        Registers a new view with the manager.

        Parameters:
            V (type): The view class to register.
            id (ViewId): An enumeration representing the view's ID.
        """

        self.views[id] = V(self.root)
        self.views[id].grid(row=0, column=0, sticky="nsew")

    def get(self, id: ViewId):
        """
        Gets a registered view by its ID.

        Parameters:
            id (ViewId): An enumeration representing the view's ID.

        Returns:
            type: The registered view corresponding to the provided ID.
        """

        return self.views[id]

    def switch(self, id: ViewId) -> None:
        """
        Switches to the specified view.

        Parameters:
            id (ViewId): An enumeration representing the view's ID.
        """

        self.views[id].tkraise()

    def start(self) -> None:
        """
        Starts the main application loop.
        """

        self.root.mainloop()
