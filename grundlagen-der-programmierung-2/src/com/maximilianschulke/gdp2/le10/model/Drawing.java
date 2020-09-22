package com.maximilianschulke.gdp2.le10.model;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;


public class Drawing {

	private ObservableList<Figure> figures;


	public Drawing(Figure[] figs) {
		this.figures = FXCollections.observableArrayList();

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


	public void update(Figure f) {
		figures.set(figures.indexOf(f), f);
	}


	public void clear() {
		figures.clear();
	}


	public ObservableList<Figure> getList() {
		return figures;
	}

}
