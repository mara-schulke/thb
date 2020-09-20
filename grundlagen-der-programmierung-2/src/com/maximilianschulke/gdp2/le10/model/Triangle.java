package com.maximilianschulke.gdp2.le10.model;

public class Triangle extends Polygon {

	public Triangle(Point pos) {
		super(pos);
	}


	public Triangle(Point pos, Point a, Point b, Point c) {
		super(pos, new Point[] {a, b, c});
	}

}