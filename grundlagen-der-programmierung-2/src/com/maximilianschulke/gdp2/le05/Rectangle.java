package com.maximilianschulke.gdp2.le05;

/**
 * Diese Klasse kann dazu verwendet werden den Flaecheninhalt
 * oder Umfang eines Rechtecks zu berechnen.
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class Rectangle extends Figure implements Sizeable {

	/**
	 * Länge A
	 */
	private double a;

	/**
	 * Länge B
	 */
	private double b;

	
	/**
	 * Der Konstruktor
	 * 
	 * @param pos Position
	 * @param a Länge A
	 * @param b Länge B
	 */
	public Rectangle(Point pos, double a, double b) {
		super(pos);
		setA(a);
		setB(b);
	}


	/**
	 * Berechnet den Flächeninhalt
	 * 
	 * @return Flächeninhalt
	 */
	public double area() {
		return a * b;
	}


	/**
	 * Berechnet den Umfang
	 * 
	 * @return Umfang
	 */
	public double perimeter() {
		return a + a + b + b;
	}


	/**
	 * Getter für A
	 * 
	 * @return A
	 */
	public double getA() {
		return a;
	}


	/**
	 * Setter für A
	 * 
	 * @param A
	 */
	public void setA(double a) {
		this.a = a;
	}


	/**
	 * Getter für B
	 * 
	 * @return B
	 */
	public double getB() {
		return b;
	}


	/**
	 * Setter für B
	 * 
	 * @param B
	 */
	public void setB(double b) {
		this.b = b;
	}


	/**
	 * Formatiert die Instanz als String
	 * 
	 * @return String-Darstellung
	 */
	public String toString() {
		return "Rectangle [ Pos " + getPos() + ", A " + getA() + ", B " + getB() + ", Area " + area() + ", Perimeter " + perimeter() + " ]";
	}

}
