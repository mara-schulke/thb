package com.maximilianschulke.gdp2.le04;

/**
 * Diese Klasse kann dazu verwendet werden den Flaecheninhalt
 * oder Umfang eines Vierecks zu berechnen.
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class Square extends Rectangle {

	/**
	 * Der Konstruktor
	 * 
	 * @param x X-Position
	 * @param y Y-Position
	 * @param a Länger einer Seite
	 */
	public Square(double x, double y, double a) {
		super(x, y, a, a);
	}


	/**
	 * Formatiert die Instanz als String
	 * 
	 * @return String-Darstellung
	 */
	public String toString()  {
		return super.toString().replaceAll("Rectangle", "Square");
	}

}