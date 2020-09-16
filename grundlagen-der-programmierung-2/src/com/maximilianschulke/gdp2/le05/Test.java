package com.maximilianschulke.gdp2.le05;

public class Test {

	public static void main(String[] args) {
		Ellipse e = new Ellipse(new Point(0, 0), 10, 10);
		System.out.println("Eclipse:\n" + e);

		Circle c = new Circle(new Point(0, 0), 15);
		System.out.println("\nCircle:\n" + c);

		Polygon p = new Polygon(new Point(0, 0), new Point[] {
			new Point(0, 0),
			new Point(0, 4),
			new Point(4, 4)
		});
		System.out.println("\nPolygon:\n" + p);

		Line l = new Line(new Point(0, 0), new Point(10, 10));
		System.out.println("\nLine:\n" + l);
	}

}
