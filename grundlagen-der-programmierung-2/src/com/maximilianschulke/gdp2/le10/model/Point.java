package com.maximilianschulke.gdp2.le10.model;

public class Point {

	private double x;
	private double y;


	public Point (double x, double y) {
		this.setX(x);
		this.setY(y);
	}


	public double xDistanceTo(Point p) {
		return p.getX() - this.getX();
	}


	public double yDistanceTo(Point p) {
		return p.getY() - this.getY();
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


	public String toString() {
		return "[" + getX() + "; " + getY() + "]";
	}

}
