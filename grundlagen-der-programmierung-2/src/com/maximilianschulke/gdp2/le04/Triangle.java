package com.maximilianschulke.gdp2.le04;

public class Triangle extends Polygon {

	public Triangle(double x, double y, double ax, double ay, double bx, double by, double cx, double cy) {
		super(x, y, new double[][] {
			{ax, ay},
			{bx, by},
			{cx, cy}
		});
	}


	public String toString()  {
		return super.toString().replaceAll("Polygon", "Triangle");
	}

}