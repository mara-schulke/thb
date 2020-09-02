package com.maximilianschulke.gdp2.le04;

public class Line {

	private double a;
	private double b;

	public Line(double x, double y, double pointA, double pointB) {
		a = pointA;
		b = pointB;
	}

	public double length() {
		return Math.abs(b - a);
	}

	public void show() {
		System.out.println("a = " + a);
		System.out.println("b = " + b);
		System.out.println("length = " + length());
	}

}
