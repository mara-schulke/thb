package com.maximilianschulke.gdp2.le05;

public class Test {

	public static void main(String[] args) {
		Ellipse e = new Ellipse(new Point(0, 0), 10, 10);
		System.out.println("Eclipse:");
		e.show();

		Circle c = new Circle(new Point(0, 0), 15);
		System.out.println("\nCircle:");
		c.show();

		Polygon p = new Polygon(new Point(0, 0), new double[][] {
			{0, 0},
			{0, 4},
			{4, 4}
		});
		System.out.println("\nPolygon:");
		p.show();

		Line l = new Line(new Point(0, 0), new Point(10, 10));
		System.out.println("\nLine:");
		l.show();
	}

}
