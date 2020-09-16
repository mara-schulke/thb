package com.maximilianschulke.gdp2.le10.model;

public abstract class Figure {

	private Point pos;


	public Figure(Point pos) {
		setPos(pos);
	}


	public Point getPos() {
		return pos;
	}


	public void setPos(Point pos) {
		this.pos = pos;
	}

}
