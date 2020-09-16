package com.maximilianschulke.gdp2.le04;

public class Ellipse {

	private double x;
	private double y;
	private double radiusX;
	private double radiusY;


	public Ellipse(double x, double y, double rx, double ry) {
		setX(x);
		setY(y);
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
		s += "x = " + getX() + "\n";
		s += "y = " + getY() + "\n";
		s += "radiusX = " + getRadiusX() + "\n";
		s += "radiusY = " + getRadiusY() + "\n";
		s += "area = " + area() + "\n";
		s += "perimeter = " + perimeter() + "\n";
		return s;
	}


	public double getX() {
		return x;
	}


	public void setX(double x) {
		this.x = x;
	}


	public double getY() {
		return y;
	}


	public void setY(double y) {
		this.y = y;
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

}
