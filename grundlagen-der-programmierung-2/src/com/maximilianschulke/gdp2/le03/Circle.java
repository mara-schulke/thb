package com.maximilianschulke.gdp2.le03;


/**
 * Diese Klasse kann dazu verwendet werden den Flächeninhalt oder Umfang
 * eines Kreises zu berechnen und auf die Konsole auszugeben.
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0 16.08.2020
 */
public class Circle {

	/**
	 * Hält den Radius des Kreises.
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
	 * Berechnet den Flächeninhalt anhand des gesetzten Radius.
	 * 
	 * @return Flächeninhalt
	 */
	public double area() {
		return Math.PI * Math.pow(r, 2);
	}

	/**
	 * Gibt den Radius, den Umfang und den Flächeninhalt auf die Konsole aus.
	 */
	public void show() {
		System.out.println("Radius = " + r);
		System.out.println("Umfang = " + circumference());
		System.out.println("Area = " + area());
	}

	/**
	 * Überschreibt den Radius des Kreises.
	 * 
	 * @param radius Neuer Radius
	 */
	public void setValue(double radius) {
		r = radius;
	}

	/**
	 * Gibt den Radius des Kreises zurück.
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
