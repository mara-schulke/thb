from typing import Any, Callable, TypeVar

Self = TypeVar("Self", bound="ObservableModel")


class ObservableModel:
    """
    A base class that implements the Observer pattern, allowing objects to listen to and trigger events.

    This class provides a mechanism for registering callback functions to specific events and triggering
    those events, executing all associated callbacks. It's useful for implementing event-driven behavior
    in classes that inherit from `ObservableModel`.

    Attributes:
        _event_listeners (dict[str, list[Callable[[Any], None]]]): A dictionary mapping event names to lists
            of callback functions that should be invoked when the event is triggered.
    """

    def __init__(self):
        """
        Initializes the `ObservableModel` with an empty dictionary for event listeners.
        """

        self._event_listeners: dict[str, list[Callable[[Any], None]]] = {}

    def listen(self, event: str, fn: Callable[[Self], None]) -> Callable:
        """
        Registers a callback function to be invoked when a specific event is triggered.

        If the event does not already exist in the listeners dictionary, it is added along with the
        callback function. If the event exists, the callback is appended to the list of listeners for that event.

        Parameters:
            event (str): The name of the event to listen for.
            fn (Callable[[Self], None]): The callback function to register. This function should accept
                a single argument: an instance of the class that triggered the event.

        Returns:
            Callable: A function that, when called, will unregister the provided callback function from
            the event listeners, effectively stopping the callback from being invoked on future triggers of the event.
        """

        try:
            self._event_listeners[event].append(fn)
        except KeyError:
            self._event_listeners[event] = [fn]

        return lambda: self._event_listeners[event].remove(fn)

    def trigger(self, event: str) -> None:
        """
        Triggers an event, causing all registered callback functions for that event to be invoked.

        If no listeners are registered for the event, the method returns immediately without any action.

        Parameters:
            event (str): The name of the event to trigger.
        """

        if event not in self._event_listeners.keys():
            return

        for func in self._event_listeners[event]:
            func(self)
