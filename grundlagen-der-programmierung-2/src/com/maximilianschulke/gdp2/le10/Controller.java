package com.maximilianschulke.gdp2.le10;

import com.maximilianschulke.gdp2.le10.model.*;

import javafx.fxml.FXML;
import javafx.event.ActionEvent;
import javafx.scene.layout.BorderPane;
import javafx.scene.control.ChoiceBox;
import javafx.scene.canvas.*;

public class Controller {

	private Figure figure;

	@FXML private BorderPane layout;
	@FXML private Canvas canvas;
	@FXML private ChoiceBox<String> typeBox;

	@FXML protected void onMouseDrag() {}

	@FXML protected void onTypeSelect(ActionEvent ev) {
		System.out.println("Selected type -> " + typeBox.getValue());

		switch (typeBox.getValue().toLowerCase()) {
			case "circle":
				figure = new Circle();
				break;
			case "ellipse":
				figure = new Ellipse();
				break;
			case "line":
				figure = new Line();
				break;
			case "rectangle":
				figure = new Rectangle();
				break;
			case "square":
				figure = new Square();
				break;
			case "polygon":
				figure = new Polygon();
				break;
			case "triangle":
				figure = new Polygon();
				break;
		}

		System.out.println(figure);
	}

}