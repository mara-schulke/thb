package com.maximilianschulke.gdp2.le04;


public class Test {

	public static void main(String[] args) {
		Ellipse e = new Ellipse(0, 0, 10, 10);
		System.out.println("Eclipse:\n" + e);

		Circle c = new Circle(0, 0, 15);
		System.out.println("\nCircle:\n" + c);

		Polygon p = new Polygon(0, 0, new double[][] {
			{0, 0},
			{0, 4},
			{4, 4}
		});
		System.out.println("\nPolygon:\n" + p);
	}

}
