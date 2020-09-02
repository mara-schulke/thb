package com.maximilianschulke.gdp2.le04;


public class Triangle {

	private double a;
	private double b;
	private double c;

	public Triangle(double x, double y, double lengthA, double lengthB, double lengthC) {
		a = lengthA;
		b = lengthB;
		c = lengthC;
	}

	public double area() {
		System.out.println("Unimplemented");
		return 0.0;
	}

	public double circumference() {
		System.out.println("Unimplemented");
		return 0.0;
	}

	public void show() {
		System.out.println("a = " + a);
		System.out.println("b = " + b);
		System.out.println("c = " + c);
		System.out.println("area = " + area());
		System.out.println("circumference = " + circumference());
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
	
	public double getC() {
		return c;
	}

	public void setC(double newC) {
		c = newC;
	}

}
