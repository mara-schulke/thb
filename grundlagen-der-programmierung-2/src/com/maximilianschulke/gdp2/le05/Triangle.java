package com.maximilianschulke.gdp2.le05;


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
	 * @param pos Position
	 * @param a Punkt A
	 * @param b Punkt B
	 * @param c Punkt C
	 */
	public Triangle(Point pos, Point a, Point b, Point c) {
		super(pos, new Point[] {a, b, c});
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