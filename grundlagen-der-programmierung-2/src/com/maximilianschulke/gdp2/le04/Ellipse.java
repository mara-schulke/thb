package com.maximilianschulke.gdp2.le04;

/**
 * Diese Klasse kann dazu verwendet werden den Flaecheninhalt
 * oder Umfang einer Ellipsezu berechnen.
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class Ellipse {

	/**
	 * Die X-Position
	 */
	private double x;

	/**
	 * Die Y-Position
	 */
	private double y;

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
	 * @param x X-Position
	 * @param y Y-Position
	 * @param rx Radius in der horizontalen
	 * @param ry Radius in der vertikalen
	 */
	public Ellipse(double x, double y, double rx, double ry) {
		setX(x);
		setY(y);
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
	 * Formatiert die Instanz als String
	 * 
	 * @return String-Darstellung
	 */
	public String toString() {
		return "Ellipse [ Pos [ " + getX() + ", " + getY() + " ], RadiusX " + getRadiusX() + ", RadiusY " + getRadiusY() + ", Area " + area() + ", Perimeter " + perimeter() + " ]";
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

}
