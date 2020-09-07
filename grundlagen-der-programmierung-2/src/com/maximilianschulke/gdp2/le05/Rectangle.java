package com.maximilianschulke.gdp2.le05;

public class Rectangle extends Figure implements Sizeable {

	private double a;
	private double b;

	
	public Rectangle(Point pos, double a, double b) {
		super(pos);
		setA(a);
		setB(b);
	}


	public double area() {
		return a * b;
	}


	public double perimeter() {
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
		super.show();
		System.out.println("a = " + a);
		System.out.println("b = " + b);
		System.out.println("area = " + area());
		System.out.println("perimeter = " + perimeter());
	}

}
