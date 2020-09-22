package com.maximilianschulke.gdp2.le10.model;

import javafx.scene.paint.Paint;

public enum FigureType {
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


	public static FigureType fromFigure(Figure f) {
		if (f instanceof Circle) return CIRCLE;
		else if (f instanceof Ellipse) return ELLIPSE;
		else if (f instanceof Line) return LINE;
		else if (f instanceof Square) return SQUARE;
		else if (f instanceof Rectangle) return RECTANGLE;
		else if (f instanceof Triangle) return TRIANGLE;
		else if (f instanceof Polygon) return POLYGON;
		else return null;
	}


	public Figure intoFigure(Point pos, Paint color) {
		switch (this) {
			case CIRCLE:
				return new Circle(pos, color);
			case ELLIPSE:
				return new Ellipse(pos, color);
			case LINE:
				return new Line(pos, color);
			case RECTANGLE:
				return new Rectangle(pos, color);
			case SQUARE:
				return new Square(pos, color);
			case POLYGON:
				return new Polygon(pos, color);
			case TRIANGLE:
				return new Triangle(pos, color);
		}

		return null;
	}
}
