package com.maximilianschulke.gdp2.le10.model;

import java.util.ArrayList;

public class Drawing {

	private ArrayList<Figure> figures;


	public Drawing(Figure[] figs) {
		this.figures = new ArrayList<Figure>();

		for (Figure f : figs) {
			add(f);
		}
	}


	public void add(Figure f) {
		figures.add(f);
	}


	public void remove(Figure f) {
		figures.remove(f);
	}


	public void move(int index, Point pos) {
		figures.get(index).setPos(pos);
	}


	public void clear() {
		figures.clear();
	}

}
