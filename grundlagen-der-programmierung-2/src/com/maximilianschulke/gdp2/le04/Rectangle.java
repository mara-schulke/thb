package com.maximilianschulke.gdp2.le04;


public class Rectangle {

	private double a;
	private double b;

	public Rectangle(double x, double y, double lengthA, double lengthB) {
		a = lengthA;
		b = lengthB;
	}

	public double area() {
		return a * b;
	}

	public double circumference() {
		return a + a + b + b;
	}

	public double getA() {
		return a;
	}

	public void setA(double newA) {
		a = newA;
	}

	public double getB() {
		return b;
	}

	public void setB(double newB) {
		b = newB;
	}

	public void show() {
		System.out.println("a = " + a);
		System.out.println("b = " + b);
		System.out.println("area = " + area());
		System.out.println("circumference = " + circumference());
	}
}
