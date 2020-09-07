package com.maximilianschulke.gdp2.le05;

public class Line extends Figure {

	private Point dest;


	public Line(Point start, Point dest) {
		super(start);
		setDest(dest);
	}


	public double length() {
		double xdiff = getPos().xDistanceTo(getDest());
		double ydiff = getPos().yDistanceTo(getDest());

		return Math.sqrt(Math.pow(xdiff, 2) + Math.pow(ydiff, 2));
	}


	public void show() {
		System.out.println("a = " + getPos());
		System.out.println("b = " + getDest());
		System.out.println("length = " + length());
	}


	public Point getDest() {
		return dest;
	}


	public void setDest(Point dest) {
		this.dest = dest;
	}

}
