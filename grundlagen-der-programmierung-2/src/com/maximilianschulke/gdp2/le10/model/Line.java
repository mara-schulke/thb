package com.maximilianschulke.gdp2.le10.model;

import javafx.scene.shape.Shape;

public class Line extends Figure {

	private Point dest;


	public Line() {
		super();
	}


	public Line(Point start, Point dest) {
		super(start);
		setDest(dest);
	}


	public double length() {
		double xdiff = getPos().xDistanceTo(getDest());
		double ydiff = getPos().yDistanceTo(getDest());

		return Math.sqrt(Math.pow(xdiff, 2) + Math.pow(ydiff, 2));
	}


	public String toString() {
		String s = "";
		s += "a = " + getPos() + "\n";
		s += "b = " + getDest() + "\n";
		s += "length = " + length() + "\n";
		return s;
	}


	public Point getDest() {
		return dest;
	}


	public void setDest(Point dest) {
		this.dest = dest;
	}


	public Shape intoShape() {
		return new javafx.scene.shape.Line(getPos().getX(), getPos().getY(), getDest().getX(), getDest().getY());
	}

}
