package com.maximilianschulke.gdp2.le05;


/**
 * Diese Klasse kann dazu verwenden die anderen
 * Klassen in diesem Package zu testen.
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class Test {

	/**
	 * Die main methode
	 * 
	 * @param args
	 */
	public static void main(String[] args) {
		Ellipse e = new Ellipse(new Point(0, 0), 10, 10);
		System.out.println(e);

		Circle c = new Circle(new Point(0, 0), 15);
		System.out.println(c);

		Polygon p = new Polygon(new Point(0, 0), new Point[] {
			new Point(0, 0),
			new Point(0, 4),
			new Point(4, 4)
		});
		System.out.println(p);

		Line l = new Line(new Point(0, 0), new Point(10, 10));
		System.out.println(l);
	}

}
