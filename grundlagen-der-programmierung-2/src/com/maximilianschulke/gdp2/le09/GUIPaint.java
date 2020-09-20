package com.maximilianschulke.gdp2.le09;

import javafx.application.Application;
import javafx.stage.Stage;
import javafx.scene.Group;
import javafx.scene.Scene;
import javafx.scene.paint.Color;
import javafx.scene.shape.*;

public class GUIPaint extends Application {

	public double x0,x1,y0,y1;

	@Override
	public void start(Stage primaryStage) {
		try {
			Group root = new Group();
			Scene scene = new Scene(root, 600, 400);

			primaryStage.setScene(scene);
			primaryStage.setTitle("GUIPaint");
			primaryStage.setMinWidth(600);
			primaryStage.setMinHeight(400);
			primaryStage.show();

			Rectangle sky = new Rectangle(0, 000, 600, 300);
			sky.setFill(Color.LIGHTBLUE);

			Rectangle earth = new Rectangle(0, 300, 600, 100);
			earth.setFill(Color.GREEN);

			Group house = new Group();

			Polygon roof = new Polygon(200.0, 150.0, 300.0, 100.0, 400.0, 150.0);
			roof.setFill(Color.ORANGE);

			Rectangle body = new Rectangle(200, 150, 200, 150);
			body.setFill(Color.BEIGE);

			Rectangle window1 = new Rectangle(237.5, 175, 25, 40);
			window1.setFill(Color.WHITE);

			Rectangle window2 = new Rectangle(237.5, 225, 25, 40);
			window2.setFill(Color.WHITE);

			Rectangle door = new Rectangle(285, 250, 30, 50);
			door.setFill(Color.SADDLEBROWN);

			Rectangle window3 = new Rectangle(337.5, 175, 25, 40);
			window3.setFill(Color.WHITE);

			Rectangle window4 = new Rectangle(337.5, 225, 25, 40);
			window4.setFill(Color.WHITE);

			Rectangle window5 = new Rectangle(287.5, 175, 25, 40);
			window5.setFill(Color.WHITE);

			house.getChildren().addAll(roof, body, window1, window2, door, window3, window4, window5);
			root.getChildren().addAll(sky, earth, house);

			scene.setOnKeyTyped(me -> {
				System.out.println(me.getEventType() + " " + me.getCharacter() + " " + me.getSource());
			});

			scene.setOnMousePressed(me -> {
				this.x0 = me.getX();
				this.y0 = me.getY();
				System.out.println(me.getEventType() + " " + x0 + " " + y0 + " " + me.getSource());
			});

			scene.setOnMouseReleased(me -> {
				this.x1 = me.getX();
				this.y1 = me.getY();
				System.out.println(me.getEventType() + " " + x1 + " " + y1 + " " + me.getSource());
				root.getChildren().add(new Rectangle(x0, y0, x1-x0, y1-y0));
			});
		} catch(Exception e) {
			e.printStackTrace();
		}
	}


	public static void main(String[] args) {
		launch(args);
	}

}

