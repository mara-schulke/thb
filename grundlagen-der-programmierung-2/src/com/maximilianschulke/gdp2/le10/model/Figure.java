package com.maximilianschulke.gdp2.le10.model;

import javafx.scene.paint.Paint;
import javafx.scene.shape.Shape;

public abstract class Figure {

	private Point pos;
	private Paint color;

	public Figure(Point pos) {
		setPos(pos);
	}

	public Figure(Point pos, Paint color) {
		this(pos);
		setColor(color);
	}


	abstract public Shape intoShape();


	public Point getPos() {
		return pos;
	}


	public void setPos(Point pos) {
		this.pos = pos;
	}


	public Paint getColor() {
		return color;
	}


	public void setColor(Paint color) {
		this.color = color;
	}

}
