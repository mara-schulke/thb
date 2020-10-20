package com.maximilianschulke.gdp2.le04;

/**
 * Diese Klasse kann dazu verwendet werden den Flaecheninhalt
 * oder Umfang eines Rechtecks zu berechnen.
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class Rectangle {

	/**
	 * X-Position
	 */
	private double x;

	/**
	 * Y-Position
	 */
	private double y;

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
	 * @param x X-Position
	 * @param y Y-Position
	 * @param a Länge A
	 * @param b Länge B
	 */
	public Rectangle(double x, double y, double a, double b) {
		setX(x);
		setY(y);
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
	 * Formatiert die Instanz als String
	 * 
	 * @return String-Darstellung
	 */
	public String toString() {
		return "Rectangle [ Pos [ " + getX() + ", " + getY() + " ], A " + getA() + ", B " + getB() + ", Area " + area() + ", Perimeter " + perimeter() + " ]";
	}


	/**
	 * Getter für X
	 * 
	 * @return X
	 */
	public double getX() {
		return x;
	}


	/**
	 * Setter für X
	 * 
	 * @param X
	 */
	public void setX(double x) {
		this.x = x;
	}


	/**
	 * Getter für Y
	 * 
	 * @return Y
	 */
	public double getY() {
		return y;
	}


	/**
	 * Setter für Y
	 * 
	 * @param Y
	 */
	public void setY(double y) {
		this.y = y;
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

}
