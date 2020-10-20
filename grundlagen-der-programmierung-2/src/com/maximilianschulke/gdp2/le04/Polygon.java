package com.maximilianschulke.gdp2.le04;


/**
 * Diese Klasse kann dazu verwendet werden den Flaecheninhalt
 * oder Umfang eines Polygons zu berechnen.
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class Polygon {

	/**
	 * X-Positon
	 */
	private double x;

	/**
	 * Y-Positon
	 */
	private double y;

	/**
	 * Liste der Punkte
	 */
	private double[][] points;


	/**
	 * Der Konstruktor
	 * 
	 * @param x X-Position
	 * @param y Y-Position
	 * @param points Liste von Punkten
	 */
	public Polygon(double x, double y, double[][] points) {
		setX(x);
		setY(y);
		setPoints(points);
	}


	/**
	 * Gibt den nächsten Punkt für einen belibigen Index zurück
	 * 
	 * @param index
	 * @return Punkt
	 */
	private double[] nextPoint(int index) {
		return points[index == points.length - 1 ? 0 : index + 1];
	}


	/**
	 * Berechnet den Flächeninhalt
	 * 
	 * @see https://www.mathopenref.com/coordpolygonarea.html
	 * @return Flächeninhalt
	 */
	public double area() {
		double accum = 0.0;

		for (int i = 0; i < points.length; i++) {
			double[] current = points[i];
			double[] next = nextPoint(i);

			double x1 = current[0];
			double y1 = current[1];
			double x2 = next[0];
			double y2 = next[1];

			accum += (x1 * y2 - y1 * x2);
		}

		return Math.abs(accum / 2);
	}


	/**
	 * Berechnet den Umfang
	 * 
	 * @see https://www.mathopenref.com/polygonperimeter.html
	 * @return Umfang
	 */
	public double perimeter() {
		double accum = 0;

		for (int i = 0; i < points.length; i++) {
			double[] current = points[i];
			double[] next = nextPoint(i);

			double[] vec = {
				(next[0] - current[0]),
				(next[1] - current[1])
			};

			double len = Math.sqrt(Math.pow(vec[0], 2) + Math.pow(vec[1], 2));

			accum += Math.abs(len);
		}

		return accum;
	}


	/**
	 * Formatiert die Instanz als String
	 * 
	 * @return String-Darstellung
	 */
	public String toString() {
		String s = "Polygon [ Pos [ " + getX() + ", " + getY() + " ], Points = [  ";

		for (double[] p : points) {
			s += "[" + p[0] + "; " + p[1] + "], ";
		}

		s += "], Area " + area() + ", Perimeter " + perimeter() + " ]";
		return s;
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
	 * Getter für Punkte
	 * 
	 * @return Punkte
	 */
	public double[][] getPoints() {
		return points;
	}


	/**
	 * Setter für Punkte
	 * 
	 * @param Punkte
	 */
	public void setPoints(double[][] points) {
		this.points = points;
	}

}
