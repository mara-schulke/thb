package com.maximilianschulke.gdp2.le05;

public class Triangle extends Polygon {

	public Triangle(Point pos, double ax, double ay, double bx, double by, double cx, double cy) {
		super(pos, new double[][] {
			{ax, ay},
			{bx, by},
			{cx, cy}
		});
	}

}