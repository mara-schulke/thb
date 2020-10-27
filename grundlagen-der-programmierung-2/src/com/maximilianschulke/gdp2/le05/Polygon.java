package com.maximilianschulke.gdp2.le05;


/**
 * Diese Klasse kann dazu verwendet werden den Flaecheninhalt
 * oder Umfang eines Polygons zu berechnen.
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class Polygon extends Figure implements Sizeable {

	/**
	 * Liste der Punkte
	 */
	private Point[] points;


	/**
	 * Der Konstruktor
	 * 
	 * @param pos Position
	 * @param points Liste der Punkte
	 */
	public Polygon(Point pos, Point[] points) {
		super(pos);
		setPoints(points);
	}


	/**
	 * Gibt den nächsten Punkt für einen belibigen Index zurück
	 * 
	 * @param index
	 * @return Punkt
	 */
	private Point nextPoint(int index) {
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
			Point current = points[i];
			Point next = nextPoint(i);

			accum += (current.getX() * next.getY() - current.getY() * next.getX());
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
			Point current = points[i];
			Point next = nextPoint(i);
			
			Line vec = new Line(
				new Point(0, 0),
				new Point(current.xDistanceTo(next), current.yDistanceTo(next))
			);
			
			accum += vec.length();
		}

		return accum;
	}


	/**
	 * Getter für Punkte
	 * 
	 * @return Punkte
	 */
	public Point[] getPoints() {
		return points;
	}


	/**
	 * Setter für Punkte
	 * 
	 * @param Punkte
	 */
	public void setPoints(Point[] points) {
		this.points = points;
	}


	/**
	 * Formatiert die Instanz als String
	 * 
	 * @return String-Darstellung
	 */
	public String toString() {
		String s = "Polygon [ Pos " + getPos() + ", Points = [  ";

		for (Point p : points) {
			s += p + ", ";
		}

		s += "], Area " + area() + ", Perimeter " + perimeter() + " ]";
		return s;
	}

}
