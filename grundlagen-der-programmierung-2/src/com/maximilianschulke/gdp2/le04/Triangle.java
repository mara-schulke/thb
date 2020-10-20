package com.maximilianschulke.gdp2.le04;

/**
 * Diese Klasse kann dazu verwendet werden den Flaecheninhalt
 * oder Umfang eines Dreiecks zu berechnen.
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class Triangle extends Polygon {

	/**
	 * Der Konstruktor
	 *
	 * @param x X-Position
	 * @param y Y-Position
	 * @param ax X-Position von Punkt A
	 * @param ay Y-Position von Punkt A
	 * @param bx X-Position von Punkt B
	 * @param by Y-Position von Punkt B
	 * @param cx X-Position von Punkt C
	 * @param cy Y-Position von Punkt C
	 */
	public Triangle(double x, double y, double ax, double ay, double bx, double by, double cx, double cy) {
		super(x, y, new double[][] {
			{ax, ay},
			{bx, by},
			{cx, cy}
		});
	}


	/**
	 * Formatiert die Instanz als String
	 *
	 * @return String-Darstellung
	 */
	public String toString()  {
		return super.toString().replaceAll("Polygon", "Triangle");
	}

}