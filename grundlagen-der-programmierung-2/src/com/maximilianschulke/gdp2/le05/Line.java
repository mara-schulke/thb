package com.maximilianschulke.gdp2.le05;

/**
 * Diese Klasse kann dazu verwendet werden
 * die Länge einer Linie zu berechnen.
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class Line extends Figure {

	/**
	 * End-Position
	 */
	private Point dest;


	/**
	 * Der Konstruktor.
	 * 
	 * @param start Start-Position
	 * @param dest End-Position
	 */
	public Line(Point start, Point dest) {
		super(start);
		setDest(dest);
	}


	/**
	 * Berechnet die Länge
	 * 
	 * @return Länge
	 */
	public double length() {
		double xdiff = getPos().xDistanceTo(getDest());
		double ydiff = getPos().yDistanceTo(getDest());

		return Math.sqrt(Math.pow(xdiff, 2) + Math.pow(ydiff, 2));
	}


	/**
	 * Getter der End-Position
	 * 
	 * @return End-Position
	 */
	public Point getDest() {
		return dest;
	}


	/**
	 * Setter der End-Position
	 * 
	 * @param dest Neue End-Position
	 */
	public void setDest(Point dest) {
		this.dest = dest;
	}


	/**
	 * Formatiert die Instanz als String
	 * 
	 * @return String-Darstellung
	 */
	public String toString() {
		return "Line [ Pos " + getPos() + ", Dest " + getDest() + ", Length " + length() + " ]";
	}

}
