package com.maximilianschulke.gdp2.le07;

import javafx.application.Application;
import javafx.geometry.Orientation;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;
import javafx.scene.control.Label;
import javafx.scene.control.Button;
import javafx.scene.layout.FlowPane;
import javafx.stage.Stage;

public class GUIBsp extends Application {

	Label hello;
	Label name;
	TextField input;
	Label label;
	Button button;

    @Override
    public void start(Stage primaryStage) throws Exception {
        primaryStage.setTitle("GUIBsp");
        hello = new Label();
        hello.setText("Hallo");
        name = new Label();
        
        FlowPane layout = new FlowPane();
        layout.setOrientation(Orientation.VERTICAL);
        layout.setVgap(25);
        layout.setAlignment(Pos.CENTER);

        FlowPane outputPane = new FlowPane();
        outputPane.setHgap(5);
        outputPane.getChildren().addAll(hello, name);
        
        layout.getChildren().add(outputPane);
        
        label = new Label();
        label.setText("Name:");
        input = new TextField();

        FlowPane inputPane = new FlowPane();
        inputPane.setHgap(25);
        inputPane.getChildren().addAll(label, input);

        layout.getChildren().add(inputPane);
        
        button = new Button();
        button.setText("Grüßen");
        
        layout.getChildren().add(button);
        
        button.addEventHandler(MouseEvent.MOUSE_CLICKED, ev -> {
        	name.setText(input.getText() + "!");
        	input.clear();
        });

        Scene scene = new Scene(layout, 300, 250);
        primaryStage.setScene(scene);
        primaryStage.show();
    }


	public static void main(String[] args) {
	    launch(args);
	}

}
