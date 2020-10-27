package com.maximilianschulke.gdp2.le05;

/**
 * Ein 2D-Punkt
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class Point {

	/**
	 * Die X Position
	 */
	private double x;

	/**
	 * Die Y-Position
	 */
	private double y;


	/**
	 * Der Konstruktor.
	 * 
	 * @param x Initialer X-Wert
	 * @param y Initialer Y-Wert
	 */
	public Point (double x, double y) {
		this.setX(x);
		this.setY(y);
	}


	/**
	 * Berechnet die Distanz auf der X-Achse zu einem anderen Punkt
	 * 
	 * @param p Zu vergleichender Punkt
	 * @return Distanz
	 */
	public double xDistanceTo(Point p) {
		return p.getX() - this.getX();
	}


	/**
	 * Berechnet die Distanz auf der Y-Achse zu einem anderen Punkt
	 * 
	 * @param p Zu vergleichender Punkt
	 * @return Distanz
	 */
	public double yDistanceTo(Point p) {
		return p.getY() - this.getY();
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
	 * Formatiert die Instanz als String
	 * 
	 * @return String-Darstellung
	 */
	public String toString() {
		return "[" + getX() + "; " + getY() + "]";
	}

}
