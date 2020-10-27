package com.maximilianschulke.gdp2.le05;

/**
 * Diese Klasse kann dazu verwendet werden den Flächeninhalt
 * oder Umfang eines Kreises zu berechnen.
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class Circle extends Ellipse {	

	/**
	 * Der Konstruktor
	 * 
	 * @param pos Position
	 * @param radius Radius
	 */
	public Circle(Point pos, double radius) {
		super(pos, radius, radius);
	}


	/**
	 * Berechnet den Umfang
	 * 
	 * @return Umfang
	 */
	public double circumference() {
		return perimeter();
	}


	/**
	 * Getter für Radius
	 * 
	 * @return Radius
	 */
	public double getRadius() {
		return getRadiusX();
	}


	/**
	 * Setter für Radius
	 * 
	 * @param radius
	 */
	public void setRadius(double radius) {
		setRadiusX(radius);
		setRadiusY(radius);
	}


	/**
	 * Formatiert die Instanz als String
	 * 
	 * @return String-Darstellung
	 */
	public String toString() {
		return super.toString().replaceAll("Ellipse", "Circle").replaceAll("Perimeter", "Circumference");
	}
}
