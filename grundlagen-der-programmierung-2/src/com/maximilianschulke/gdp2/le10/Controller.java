package com.maximilianschulke.gdp2.le10;

import com.maximilianschulke.gdp2.le10.model.*;

import javafx.fxml.FXML;
import javafx.collections.ListChangeListener;
import javafx.event.ActionEvent;
import javafx.scene.input.MouseEvent;
import javafx.scene.input.MouseButton;
import javafx.scene.layout.BorderPane;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.ColorPicker;
import javafx.scene.control.Label;
import javafx.scene.layout.Pane;
import javafx.scene.paint.Paint;
import javafx.scene.shape.Shape;

public class Controller {

	private Drawing drawing = new Drawing(new Figure[] {});  
	private Figure figure;
	private Point start;

	@FXML private BorderPane layout;
	@FXML private Pane root;
	@FXML private ChoiceBox<String> typeBox;
	@FXML private ColorPicker colorPicker;
	@FXML private Label mousePosition;
	@FXML private Label area;
	@FXML private Label perimeter;


	@FXML public void initialize() {
		drawing.getList().addListener(new ListChangeListener<Figure>() {
			@Override
	        public void onChanged(ListChangeListener.Change<? extends Figure> c) {
	            if (c.next()){
	            	root.getChildren().clear();
	            	c.getList().stream().forEach(f -> {
	            		root.getChildren().add(f.intoShape());
	            	});
            	}
	        }
	    });
	}


	@FXML protected void onMouseDown(MouseEvent ev) {
		if (!ev.isPrimaryButtonDown()) return;

		start = new Point(ev.getX(), ev.getY());
		figure = FigureType.fromString(typeBox.getValue()).intoFigure(start, colorPicker.getValue());
		drawing.add(figure);
	}


	@FXML protected void onMouseDragged(MouseEvent ev) {
		if (!ev.isPrimaryButtonDown()) return;

		onMouseMoved(ev);

		Point current = new Point(ev.getX(), ev.getY());

		switch (FigureType.fromString(typeBox.getValue())) {
			case CIRCLE:
				((Circle) figure).setRadius(Math.abs(new Line(start, current).length()));
				break;
			case ELLIPSE:
				((Ellipse) figure).setRadiusX(Math.abs(start.xDistanceTo(current)));
				((Ellipse) figure).setRadiusY(Math.abs(start.yDistanceTo(current)));
				break;
			case LINE:
				((Line) figure).setDest(current);
				break;
			case RECTANGLE:
				((Rectangle) figure).setA(start.xDistanceTo(current));
				((Rectangle) figure).setB(start.yDistanceTo(current));
				break;
			case SQUARE:
				if (start.xDistanceTo(current) < start.yDistanceTo(current)) {
					((Square) figure).setA(start.yDistanceTo(current));
					((Square) figure).setB(start.yDistanceTo(current));
				} else {
					((Square) figure).setA(start.xDistanceTo(current));
					((Square) figure).setB(start.xDistanceTo(current));
				}
				break;
			case POLYGON:
				break;
			case TRIANGLE:
				break;
		}

		drawing.update(figure);

		if (figure instanceof Sizeable) {
			area.setText((int)((Sizeable) figure).area() + "");
			perimeter.setText((int)((Sizeable) figure).perimeter() + "");
		} else {
			area.setText("0.0");
			perimeter.setText("0.0");
		}
	}


	@FXML protected void onMouseUp(MouseEvent ev) {
		if (!ev.getButton().equals(MouseButton.PRIMARY)) return;

		if (figure instanceof Sizeable && ((Sizeable) figure).perimeter() < 0) {
			drawing.remove(figure);
		} else if (start.getX() == ev.getX() && start.getY() == ev.getY()) {
			drawing.remove(figure);
		}

		start = null;
		figure = null;
		area.setText("0.0");
		perimeter.setText("0.0");
	}


	@FXML protected void onMouseMoved(MouseEvent ev) {
		mousePosition.setText(ev.getX() + " / " + ev.getY());
	}


	@FXML protected void onClear(ActionEvent ev) {
		drawing.clear();
	}

}