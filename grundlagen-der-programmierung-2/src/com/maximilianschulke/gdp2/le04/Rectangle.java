package com.maximilianschulke.gdp2.le04;

public class Rectangle {

	private double x;
	private double y;
	private double a;
	private double b;


	public Rectangle(double x, double y, double a, double b) {
		setX(x);
		setY(y);
		setA(a);
		setB(b);
	}

	
	public double area() {
		return a * b;
	}


	public double perimeter() {
		return a + a + b + b;
	}


	public String toString() {
		return "Rectangle [ Pos [ " + getX() + ", " + getY() + " ], A " + getA() + ", B " + getB() + ", Area " + area() + ", Perimeter " + perimeter() + " ]";
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


	public double getA() {
		return a;
	}


	public void setA(double a) {
		this.a = a;
	}


	public double getB() {
		return b;
	}


	public void setB(double b) {
		this.b = b;
	}

}
