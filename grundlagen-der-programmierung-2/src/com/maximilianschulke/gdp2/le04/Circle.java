package com.maximilianschulke.gdp2.le04;

public class Circle extends Ellipse {

	public Circle(double x, double y, double radius) {
		super(x, y, radius, radius);
	}


	public double circumference() {
		return perimeter();
	}
	

	public double getRadius() {
		return getRadiusX();
	}


	public void setRadius(double radius) {
		setRadiusX(radius);
		setRadiusY(radius);
	}


	public String toString() {
		return super.toString().replaceAll("Ellipse", "Circle").replaceAll("Perimeter", "Circumference");
	}

}
