package com.maximilianschulke.gdp2.le04;

public class Polygon {

	private double x;
	private double y;
	private double[][] points;


	public Polygon(double x, double y, double[][] points) {
		setX(x);
		setY(y);
		setPoints(points);
	}


	private double[] nextPoint(int index) {
		return points[index == points.length - 1 ? 0 : index + 1];
	}


	/**
	 * @see https://www.mathopenref.com/coordpolygonarea.html
	 * @return Area of the Polygon
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
	 * @see https://www.mathopenref.com/polygonperimeter.html
	 * @return Perimeter of the Polygon
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


	public String toString() {
		String s = "";
		s += "x = " + getX() + "\n";
		s += "y = " + getY() + "\n";
		s += "points = {\n";

		for (double[] p : points) {
			s += "\t [" + p[0] + "; " + p[1] + "]\n";
		}

		s += "}\n";
		s += "area = " + area() + "\n";
		s += "perimeter = " + perimeter() + "\n";
		return s;
	}


	public double getX() {
		return x;
	}


	public void setX(double x) {
		this.x = x;
	}


	public double getY() {
		return y;
	}


	public void setY(double y) {
		this.y = y;
	}


	public double[][] getPoints() {
		return points;
	}


	public void setPoints(double[][] points) {
		this.points = points;
	}

}
