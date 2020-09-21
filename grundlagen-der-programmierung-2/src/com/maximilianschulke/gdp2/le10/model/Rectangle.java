package com.maximilianschulke.gdp2.le10.model;

import javafx.scene.paint.Paint;
import javafx.scene.shape.Shape;

public class Rectangle extends Figure implements Sizeable {

	private double a;
	private double b;


	public Rectangle(Point pos) {
		super(pos);
		setA(0);
		setB(0);
	}

	
	public Rectangle(Point pos, Paint color) {
		this(pos);
		setColor(color);
	}
	

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


	public String toString() {
		String s = "";
		s += "pos = " + getPos() +  "\n";
		s += "a = " + getA() +  "\n";
		s += "b = " + getB() +  "\n";
		s += "area = " + area() +  "\n";
		s += "perimeter = " + perimeter() +  "\n";
		return s;
	}


	public Shape intoShape() {
		Shape shape = new javafx.scene.shape.Rectangle(getPos().getX(), getPos().getY(), getA(), getB());
		shape.setFill(getColor());
		return shape;
	}

}
