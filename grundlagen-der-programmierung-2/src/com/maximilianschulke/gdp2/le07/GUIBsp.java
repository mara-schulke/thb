package com.maximilianschulke.gdp2.le07;

import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.TextField;
import javafx.scene.input.MouseEvent;
import javafx.scene.control.Label;
import javafx.scene.control.Button;
import javafx.scene.layout.FlowPane;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

public class GUIBsp extends Application {

	Label hello;
	Label name;
	TextField input;
	Label label;
	Button ok;
	Button cancel;


	@Override
	public void start(Stage primaryStage) throws Exception {
		primaryStage.setTitle("GUIBsp");
		hello = new Label();
		hello.setText("Hallo");
		name = new Label();

		VBox layout = new VBox();
		layout.setPadding(new Insets(25, 25, 25, 25));
		layout.setSpacing(10);

		FlowPane outputPane = new FlowPane();
		outputPane.setHgap(5);
		outputPane.getChildren().addAll(hello, name);

		layout.getChildren().add(outputPane);

		label = new Label();
		label.setText("Name:");
		input = new TextField();

		FlowPane inputPane = new FlowPane();
		inputPane.setHgap(10);
		inputPane.getChildren().addAll(label, input);

		layout.getChildren().add(inputPane);

		FlowPane controlPane = new FlowPane();
		controlPane.setHgap(10);

		ok = new Button();
		ok.setText("Ok");

		cancel = new Button();
		cancel.setText("Cancel");

		ok.addEventHandler(MouseEvent.MOUSE_CLICKED, ev -> {
			if (input.getText().trim().equals("")) {
				input.clear();
				return;
			}

			name.setText(input.getText() + "!");
			input.clear();
		});

		cancel.addEventHandler(MouseEvent.MOUSE_CLICKED, ev -> {
			name.setText("");
			input.clear();
		});

		controlPane.getChildren().addAll(ok, cancel);
		layout.getChildren().add(controlPane);

		Scene scene = new Scene(layout);
		primaryStage.setScene(scene);
		primaryStage.setMinWidth(300);
		primaryStage.setMinHeight(150);
		primaryStage.show();
	}


	public static void main(String[] args) {
		launch(args);
	}

}

