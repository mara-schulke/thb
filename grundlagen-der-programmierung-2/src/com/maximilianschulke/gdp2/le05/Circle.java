package com.maximilianschulke.gdp2.le05;

public class Circle extends Ellipse {	

	public Circle(Point pos, double radius) {
		super(pos, radius, radius);
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

}
