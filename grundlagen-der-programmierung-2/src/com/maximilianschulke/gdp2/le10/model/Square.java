package com.maximilianschulke.gdp2.le10.model;

import javafx.scene.paint.Paint;

public class Square extends Rectangle {

	public Square(Point pos) {
		super(pos);
	}
	
	
	public Square(Point pos, Paint color) {
		super(pos, color);
	}


	public Square(Point pos, double a) {
		super(pos, a, a);
	}


	public String toString() {
		return super.toString().replaceAll("Rectangle", "Square");
	}

}