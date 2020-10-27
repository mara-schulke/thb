package com.maximilianschulke.gdp2.le05;

/**
 * Stellt eine abstrakte Form dar.
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
abstract class Figure {

	/**
	 * Die Position der Form.
	 */
	private Point pos;


	/**
	 * Der Konstruktor.
	 * 
	 * @param pos Initiale Position
	 */
	public Figure(Point pos) {
		setPos(pos);
	}


	/**
	 * Getter der Position
	 * 
	 * @return Position
	 */
	public Point getPos() {
		return pos;
	}


	/**
	 * Setter der Position
	 * 
	 * @param pos Position
	 */
	public void setPos(Point pos) {
		this.pos = pos;
	}

}
