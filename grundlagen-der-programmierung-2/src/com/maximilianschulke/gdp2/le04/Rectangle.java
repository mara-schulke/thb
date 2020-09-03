package com.maximilianschulke.gdp2.le04;


public class Rectangle {

	private double x;
	private double y;
	private double a;
	private double b;

	
	public Rectangle(double x, double y, double lengthA, double lengthB) {

	}

	
	public double area() {
		return a * b;
	}

	
	public double perimeter() {
		return a + a + b + b;
	}

	
	public void show() {
		System.out.println("a = " + a);
		System.out.println("b = " + b);
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
