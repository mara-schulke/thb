package com.maximilianschulke.gdp2.le05;

public class Ellipse extends Figure implements Sizeable {

	private double radiusX;
	private double radiusY;


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


	public void show() {
		System.out.println("x = " + getPos().getX());
		System.out.println("y = " + getPos().getY());
		System.out.println("radiusX = " + getRadiusX());
		System.out.println("radiusY = " + getRadiusY());
		System.out.println("area = " + area());
		System.out.println("perimeter = " + perimeter());
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
