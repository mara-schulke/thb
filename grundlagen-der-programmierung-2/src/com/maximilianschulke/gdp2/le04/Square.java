package com.maximilianschulke.gdp2.le04;


public class Square extends Rectangle {

	public Square(double x, double y, double a) {
		super(x, y, a, a);
	}


	public String toString()  {
		return super.toString().replaceAll("Rectangle", "Square");
	}

}