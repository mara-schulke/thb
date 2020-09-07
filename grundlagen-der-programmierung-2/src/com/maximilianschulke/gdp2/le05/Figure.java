package com.maximilianschulke.gdp2.le05;

abstract class Figure {

	private Point pos;


	public Figure(Point pos) {
		setPos(pos);
	}


	public void show() {
		System.out.println("x = " + pos.getX());
		System.out.println("y = " + pos.getY());
	}


	public Point getPos() {
		return pos;
	}


	public void setPos(Point pos) {
		this.pos = pos;
	}

}
