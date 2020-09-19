package com.maximilianschulke.gdp2.le09;

import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.layout.*;
import javafx.scene.paint.Color;
import javafx.geometry.*;
import javafx.scene.control.*;
import javafx.scene.shape.*;
import javafx.scene.text.*;

public class GUIPaint extends Application {

	public double x0,x1,y0,y1;

	@Override
	public void start(Stage primaryStage) {
		try {
			Group root = new Group();
			Scene scene = new Scene(root, 600, 400);

			primaryStage.setScene(scene);
			primaryStage.setTitle("GUIPaint");
			primaryStage.show();

			Rectangle r = new Rectangle(250, 100, 150, 100);
			r.setFill(Color.GREEN);
			r.setStroke(Color.AQUAMARINE);

			Ellipse e = new Ellipse(200, 100, 100, 50);
			e.setFill(Color.CHOCOLATE);
			e.setStroke(Color.BROWN);

			Text t = new Text(130, 100, "Meine erste Zeichnung");
			t.setFont(new Font(15));
			t.setFill(Color.YELLOW);

			Shape su = Shape.union(r, e);
			Shape ss = Shape.subtract(e,r);
			root.getChildren().addAll(r,e,t);

			scene.setOnKeyTyped(me ->{
				System.out.println(me.getEventType()+ " " + me.getCharacter() + " " + me.getSource());
			});

			scene.setOnMousePressed(me ->{
				this.x0 = me.getX();
				this.y0 = me.getY();
				System.out.println(me.getEventType()+ " " + x0 + " "+ y0 + " "+ me.getSource());
			});

			scene.setOnMouseReleased(me->{
				this.x1 = me.getX();
				this.y1 = me.getY();
				System.out.println(me.getEventType()+ " " + x1 + " "+ y1 + " "+ me.getSource());
			root.getChildren().add(new Rectangle(x0,y0,x1-x0,y1-y0));
			});
		} catch(Exception e) {
			e.printStackTrace();
		}
	}


	public static void main(String[] args) {
		launch(args);
	}

}

