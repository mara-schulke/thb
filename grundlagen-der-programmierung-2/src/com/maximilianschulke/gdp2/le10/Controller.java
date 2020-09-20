package com.maximilianschulke.gdp2.le10;

import com.maximilianschulke.gdp2.le10.model.*;

import javafx.fxml.FXML;
import javafx.event.ActionEvent;
import javafx.scene.input.MouseEvent;
import javafx.scene.input.MouseButton;
import javafx.scene.input.MouseDragEvent;
import javafx.scene.layout.BorderPane;
import javafx.scene.control.ChoiceBox;
import javafx.scene.layout.Pane;


enum FigureType {
	CIRCLE,
	ELLIPSE,
	LINE,
	RECTANGLE,
	SQUARE,
	POLYGON,
	TRIANGLE;

	public static FigureType fromString(String id) {
		switch (id.toLowerCase()) {
			case "circle":
				return CIRCLE;
			case "ellipse":
				return ELLIPSE;
			case "line":
				return LINE;
			case "rectangle":
				return RECTANGLE;
			case "square":
				return SQUARE;
			case "polygon":
				return POLYGON;
			case "triangle":
				return TRIANGLE;
		}

		return null;
	}


	public Figure intoFigure(Point pos) {
		switch (this) {
			case CIRCLE:
				return new Circle(pos);
			case ELLIPSE:
				return new Ellipse(pos);
			case LINE:
				return new Line(pos);
			case RECTANGLE:
				return new Rectangle(pos);
			case SQUARE:
				return new Square(pos);
			case POLYGON:
				return new Polygon(pos);
			case TRIANGLE:
				return new Triangle(pos);
		}

		return null;
	}
}

public class Controller {

	private Figure figure;
	private Point start;

	@FXML private BorderPane layout;
	@FXML private Pane root;
	@FXML private ChoiceBox<String> typeBox;


	@FXML protected void onMouseDown(MouseEvent ev) {
		if (!ev.isPrimaryButtonDown()) return;

		start = new Point(ev.getX(), ev.getY());
		figure = FigureType.fromString(typeBox.getValue()).intoFigure(start);
		root.getChildren().add(figure.intoShape());
	}
	

	@FXML protected void onMouseMove(MouseEvent ev) {
		if (!ev.isPrimaryButtonDown()) return;

		Point current = new Point(ev.getX(), ev.getY());

		switch (FigureType.fromString(typeBox.getValue())) {
			case CIRCLE:
				System.out.println("Set circle radius to " + start.xDistanceTo(current));
				((Circle) figure).setRadius(Math.abs(start.xDistanceTo(current)));
				break;
			case ELLIPSE:
				((Ellipse) figure).setRadiusX(Math.abs(start.xDistanceTo(current)));
				((Ellipse) figure).setRadiusY(Math.abs(start.yDistanceTo(current)));
				break;
			case LINE:
				((Line) figure).setDest(current);
				break;
			case RECTANGLE:
				((Rectangle) figure).setA(Math.abs(start.xDistanceTo(current)));
				((Rectangle) figure).setB(Math.abs(start.yDistanceTo(current)));
				break;
			case SQUARE:
				((Square) figure).setA(Math.abs(start.xDistanceTo(current)));
				((Square) figure).setB(Math.abs(start.xDistanceTo(current)));
				break;
			case POLYGON:
				break;
			case TRIANGLE:
				break;
		}
	}


	@FXML protected void onMouseUp(MouseEvent ev) {
		if(!ev.getButton().equals(MouseButton.PRIMARY)) return;

		System.out.println("End Shape");
		start = null;
		figure = null;
	}

}