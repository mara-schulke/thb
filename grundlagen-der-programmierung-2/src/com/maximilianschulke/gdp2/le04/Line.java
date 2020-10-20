package com.maximilianschulke.gdp2.le04;


/**
 * Diese Klasse kann dazu verwendet werden
 * die Länge einer Linie zu berechnen.
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class Line {

	/**
	 * X-Wert der Start-Position
	 */
	private double ax;

	/**
	 * Y-Wert der Start-Position
	 */
	private double ay;

	/**
	 * X-Wert der End-Position
	 */
	private double bx;

	/**
	 * Y-Wert der End-Position
	 */
	private double by;


	/**
	 * Der Konstruktor
	 * 
	 * @param ax X-Wert der Start-Position
	 * @param ay Y-Wert der Start-Position
	 * @param bx X-Wert der End-Position
	 * @param by Y-Wert der End-Position
	 */
	public Line(double ax, double ay, double bx, double by) {
		setAX(ax);
		setAY(ay);
		setBX(bx);
		setBY(by);
	}


	/**
	 * Berechnet die Länge
	 * 
	 * @return Länge
	 */
	public double length() {
		double x = bx - ax;
		double y = by - ay;

		return Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));
	}


	/**
	 * Formatiert die Instanz als String
	 * 
	 * @return String-Darstellung
	 */
	public String toString() {
		return "Line [ Pos [ " + getAX() + ", " + getAY() + " ], Dest [ " + getBX() + ", " + getBY() + " ], Length " + length() + " ]";
	}


	/**
	 * Getter für AX
	 * 
	 * @return AX
	 */
	public double getAX() {
		return ax;
	}


	/**
	 * Setter für AX
	 * 
	 * @param AX
	 */
	public void setAX(double ax) {
		this.ax = ax;
	}


	/**
	 * Getter für AY
	 * 
	 * @return AY
	 */
	public double getAY() {
		return ay;
	}


	/**
	 * Setter für AY
	 * 
	 * @param AY
	 */
	public void setAY(double ay) {
		this.ay = ay;
	}	


	/**
	 * Getter für BX
	 * 
	 * @return BX
	 */
	public double getBX() {
		return bx;
	}


	/**
	 * Setter für BX
	 * 
	 * @param BX
	 */
	public void setBX(double bx) {
		this.bx = bx;
	}


	/**
	 * Getter für BY
	 * 
	 * @return BY
	 */
	public double getBY() {
		return by;
	}


	/**
	 * Setter für BY
	 * 
	 * @param BY
	 */
	public void setBY(double by) {
		this.by = by;
	}

}
