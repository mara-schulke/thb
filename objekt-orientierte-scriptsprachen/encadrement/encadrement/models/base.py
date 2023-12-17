from typing import Any, Callable, TypeVar

Self = TypeVar("Self", bound="ObservableModel")


class ObservableModel:
    def __init__(self):
        self._event_listeners: dict[str, list[Callable[[Any], None]]] = {}

    def listen(self, event: str, fn: Callable[[Self], None]) -> Callable:
        try:
            self._event_listeners[event].append(fn)
        except KeyError:
            self._event_listeners[event] = [fn]

        return lambda: self._event_listeners[event].remove(fn)

    def trigger(self, event: str) -> None:
        if event not in self._event_listeners.keys():
            return

        for func in self._event_listeners[event]:
            func(self)
