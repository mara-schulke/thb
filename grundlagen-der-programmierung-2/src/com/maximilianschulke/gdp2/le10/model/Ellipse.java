package com.maximilianschulke.gdp2.le10.model;

import javafx.scene.shape.Shape;

public class Ellipse extends Figure implements Sizeable {

	private double radiusX;
	private double radiusY;


	public Ellipse() {
		super();
	}


	public Ellipse(Point pos, double rx, double ry) {
		super(pos);
		setRadiusX(rx);
		setRadiusY(ry);
	}


	public double area() {
		return radiusX * radiusY * Math.PI;
	}


	public double perimeter() {
		if (radiusX == 0 && radiusY == 0) return 0;

		double h = Math.pow(radiusX - radiusY, 2) / Math.pow(radiusX + radiusY, 2);

		return Math.PI * (radiusX + radiusY) * (1 + 3 * h / (10 + Math.sqrt(4 - 3 * h)));
	}


	public String toString() {
		String s = "";
		s += "pos = " + getPos() + "\n";
		s += "radiusX = " + getRadiusX() + "\n";
		s += "radiusY = " + getRadiusY() + "\n";
		s += "area = " + area() + "\n";
		s += "perimeter = " + perimeter() + "\n";
		return s;
	}


	public double getRadiusX() {
		return radiusX;
	}


	public void setRadiusX(double radiusX) {
		this.radiusX = radiusX;
	}


	public double getRadiusY() {
		return radiusY;
	}


	public void setRadiusY(double radiusY) {
		this.radiusY = radiusY;
	}


	public Shape intoShape() {
		return new javafx.scene.shape.Ellipse(getPos().getX(), getPos().getY(), getRadiusX(), getRadiusY());
	}

}
