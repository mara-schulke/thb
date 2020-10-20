package com.maximilianschulke.gdp2.le04;

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
		Ellipse e = new Ellipse(0, 0, 10, 10);
		System.out.println(e);

		Circle c = new Circle(0, 0, 15);
		System.out.println(c);

		Polygon p = new Polygon(0, 0, new double[][] {
			{0, 0},
			{0, 4},
			{4, 4}
		});
		System.out.println(p);
	}

}
