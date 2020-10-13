package com.maximilianschulke.gdp2.le03;


/**
 * Diese Klasse kann dazu verwendet werden den Flaecheninhalt oder Umfang
 * eines Kreises zu berechnen und auf die Konsole auszugeben.
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0 16.08.2020
 */
public class Circle {

	/**
	 * Haelt den Radius des Kreises.
	 */
	private double r;

	/**
	 * Der Konstruktor der Klasse
	 * 
	 * @param radius Der Radius des Kreises
	 */
	public Circle (double radius) {
		r = radius;
	}

	/**
	 * Berechnet den Umfang anhand des gesetzten Radius.
	 * 
	 * @return Umfang
	 */
	public double circumference() {
		return 2 * Math.PI * r;
	}

	/**
	 * Berechnet den Flaecheninhalt anhand des gesetzten Radius.
	 * 
	 * @return Flaecheninhalt
	 */
	public double area() {
		return Math.PI * Math.pow(r, 2);
	}


	/**
	 * Formatiert die Instanz als String.
	 *
	 * @return String der Klasse
	 */
	public String toString() {
		return "Circle [ Radius " + getValue() + ", Area " + area() + ", Circumference " + circumference() + " ]";
	}

	/**
	 * Gibt den Radius, den Umfang und den Flaecheninhalt auf die Konsole aus.
	 */
	public void show() {
		System.out.println(toString());
	}

	/**
	 * Ueberschreibt den Radius des Kreises.
	 * 
	 * @param radius Neuer Radius
	 */
	public void setValue(double radius) {
		r = radius;
	}

	/**
	 * Gibt den Radius des Kreises zurueck.
	 * 
	 * @return Radius des Kreises
	 */
	public double getValue() {
		return r;
	}

	/**
	 * Testet die Klasse Circle.
	 * 
	 * @param args CLI-Argumente
	 */
	public static void main(String[] args) {
		Circle c = new Circle(13.5);
		c.show();
	}

}
