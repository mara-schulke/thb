package com.maximilianschulke.gdp2.le05;

/**
 * Diese Klasse kann dazu verwendet werden den Flächeninhalt
 * oder Umfang einer Ellipse zu berechnen.
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class Ellipse extends Figure implements Sizeable {

	/**
	 * Der Radius in der horizontalen
	 */
	private double radiusX;

	/**
	 * Der Radius in der vertikalen
	 */
	private double radiusY;


	/**
	 * Der Konstruktor
	 * 
	 * @param pos Position
	 * @param rx Radius in der horizontalen
	 * @param ry Radius in der vertikalen
	 */
	public Ellipse(Point pos, double rx, double ry) {
		super(pos);
		setRadiusX(rx);
		setRadiusY(ry);
	}


	/**
	 * Berechnet den Flächeninhalt
	 * 
	 * @return Flächeninhalt
	 */
	public double area() {
		return radiusX * radiusY * Math.PI;
	}


	/**
	 * Berechnet den Umfang
	 * 
	 * @return Umfang
	 */
	public double perimeter() {
		if (radiusX == 0 && radiusY == 0) return 0;

		double h = Math.pow(radiusX - radiusY, 2) / Math.pow(radiusX + radiusY, 2);

		return Math.PI * (radiusX + radiusY) * (1 + 3 * h / (10 + Math.sqrt(4 - 3 * h)));
	}


	/**
	 * Getter für RadiusX
	 * 
	 * @return Radius X
	 */
	public double getRadiusX() {
		return radiusX;
	}


	/**
	 * Setter für RadiusX
	 * 
	 * @param Radius X
	 */
	public void setRadiusX(double radiusX) {
		this.radiusX = radiusX;
	}


	/**
	 * Getter für RadiusY
	 * 
	 * @return Radius Y
	 */
	public double getRadiusY() {
		return radiusY;
	}


	/**
	 * Setter für RadiusY
	 * 
	 * @param Radius Y
	 */
	public void setRadiusY(double radiusY) {
		this.radiusY = radiusY;
	}


	/**
	 * Formatiert die Instanz als String
	 * 
	 * @return String-Darstellung
	 */
	public String toString() {
		return "Ellipse [ Pos [ " + getPos() + " ], RadiusX " + getRadiusX() + ", RadiusY " + getRadiusY() + ", Area " + area() + ", Perimeter " + perimeter() + " ]";
	}

}
