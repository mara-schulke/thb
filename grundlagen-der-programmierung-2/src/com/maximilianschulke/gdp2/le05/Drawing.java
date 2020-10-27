package com.maximilianschulke.gdp2.le05;

import java.util.ArrayList;


/**
 * Stellt eine Zeichnung dar.
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class Drawing {

	/**
	 * Die Liste der Formen in dieser Zeichnung.
	 */
	private ArrayList<Figure> figures;


	/**
	 * Der Konstruktor.
	 * 
	 * @param figs Initiale Formen
	 */
	public Drawing(Figure[] figs) {
		this.figures = new ArrayList<Figure>();

		for (Figure f : figs) {
			add(f);
		}
	}


	/**
	 * Fügt eine Form zur Zeichnung hinzu.
	 * 
	 * @param f Form
	 */
	public void add(Figure f) {
		figures.add(f);
	}


	/**
	 * Entfernt eine Form von der Zeichnung.
	 * 
	 * @param f Form
	 */
	public void remove(Figure f) {
		figures.remove(f);
	}


	/**
	 * Verändert die Position einer Form mit dem gegebenen index
	 * 
 	 * @param index Index der Form
	 * @param pos Neue Position
	 */
	public void move(int index, Point pos) {
		figures.get(index).setPos(pos);
	}


	/**
	 * Löscht alle Formen der Zeichnung.
	 */
	public void clear() {
		figures.clear();
	}

}
