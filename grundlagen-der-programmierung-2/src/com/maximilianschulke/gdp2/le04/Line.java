package com.maximilianschulke.gdp2.le04;

public class Line {

	private double ax;
	private double ay;
	private double bx;
	private double by;


	public Line(double ax, double ay, double bx, double by) {
		setAX(ax);
		setAY(ay);
		setBX(bx);
		setBY(by);
	}


	public double length() {
		double x = bx - ax;
		double y = by - ay;

		return Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));
	}


	public String toString() {
		return "Line [ Pos [ " + getAX() + ", " + getAY() + " ], Dest [ " + getBX() + ", " + getBY() + " ], Length " + length() + " ]";
	}


	public double getAX() {
		return ax;
	}


	public void setAX(double ax) {
		this.ax = ax;
	}


	public double getAY() {
		return ay;
	}


	public void setAY(double ay) {
		this.ay = ay;
	}	


	public double getBX() {
		return bx;
	}


	public void setBX(double bx) {
		this.bx = bx;
	}

	
	public double getBY() {
		return by;
	}


	public void setBY(double by) {
		this.by = by;
	}

}
