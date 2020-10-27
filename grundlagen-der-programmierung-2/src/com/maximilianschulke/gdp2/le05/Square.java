package com.maximilianschulke.gdp2.le05;


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
	 * @param pos Position
	 * @param a Seitenlänge
	 */
	public Square(Point pos, double a) {
		super(pos, a, a);
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