package com.maximilianschulke.gdp2.le05;

import java.util.Arrays;

public class Polygon extends Figure implements Sizeable {

	private Point[] points;


	public Polygon(Point pos, Point[] points) {
		super(pos);
		setPoints(points);
	}


	private Point nextPoint(int index) {
		return points[index == points.length - 1 ? 0 : index + 1];
	}


	/**
	 * @see https://www.mathopenref.com/coordpolygonarea.html
	 * @return Area of the Polygon
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
	 * @see https://www.mathopenref.com/polygonperimeter.html
	 * @return Perimeter of the Polygon
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


	public void show() {
		System.out.println("x = " + getPos().getX());
		System.out.println("y = " + getPos().getY());

		System.out.println("points = {");
		Arrays.stream(points)
			.forEach(p -> System.out.println("  " + p + ","));
		System.out.println("}");

		System.out.println("area = " + area());
		System.out.println("perimeter = " + perimeter());
	}


	public Point[] getPoints() {
		return points;
	}


	public void setPoints(Point[] points) {
		this.points = points;
	}

}
