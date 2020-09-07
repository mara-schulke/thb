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


	public void show() {
		System.out.println("x = " + getX());
		System.out.println("y = " + getX());
		System.out.println("radiusX = " + getRadiusX());
		System.out.println("radiusY = " + getRadiusY());
		System.out.println("area = " + area());
		System.out.println("perimeter = " + perimeter());
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
