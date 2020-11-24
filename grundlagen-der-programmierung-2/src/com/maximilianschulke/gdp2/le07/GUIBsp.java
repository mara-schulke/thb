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


/**
 * Eine Beispiel GUI
 * 
 * @version 1.0.0
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 */
public class GUIBsp extends Application {

	/**
	 * Das Hello Label
	 */
	Label hello;

	/**
	 * Das Name Label
	 */
	Label name;

	/**
	 * Das Textfeld für die Eingabe
	 */
	TextField input;

	/**
	 * Das Label für das Textfeld
	 */
	Label label;

	/**
	 * Der Button um zu bestätigen
	 */
	Button ok;

	/**
	 * Der Button um abzubrechen
	 */
	Button cancel;


	/**
	 * Baut die GUI auf einer Stage
	 * 
	 * @param primaryStage Stage
	 */
	@Override
	public void start(Stage primaryStage) throws Exception {
		// Setze Window-Titel
		primaryStage.setTitle("GUIBsp");

		// Erstelle Labels
		hello = new Label();
		hello.setText("Hallo");
		name = new Label();

		// Erstelle Layouts und füge Ausgabe-Labels hinzu
		VBox layout = new VBox();
		layout.setPadding(new Insets(25, 25, 25, 25));
		layout.setSpacing(10);

		FlowPane outputPane = new FlowPane();
		outputPane.setHgap(5);
		outputPane.getChildren().addAll(hello, name);

		layout.getChildren().add(outputPane);

		// Erstelle Eingabe-Textfeld
		label = new Label();
		label.setText("Name:");
		input = new TextField();

		FlowPane inputPane = new FlowPane();
		inputPane.setHgap(10);
		inputPane.getChildren().addAll(label, input);

		layout.getChildren().add(inputPane);

		// Erstelle Buttons
		FlowPane controlPane = new FlowPane();
		controlPane.setHgap(10);

		ok = new Button();
		ok.setText("Ok");

		cancel = new Button();
		cancel.setText("Cancel");

		// EventHandler für "OK"
		ok.addEventHandler(MouseEvent.MOUSE_CLICKED, ev -> {
			if (input.getText().trim().equals("")) {
				input.clear();
				return;
			}

			name.setText(input.getText() + "!");
			input.clear();
		});

		// EventHandler für "Abbrechen"
		cancel.addEventHandler(MouseEvent.MOUSE_CLICKED, ev -> {
			name.setText("");
			input.clear();
		});

		controlPane.getChildren().addAll(ok, cancel);
		layout.getChildren().add(controlPane);

		// Zeichne das Layout mit Größenbeschränkungen
		Scene scene = new Scene(layout);
		primaryStage.setScene(scene);
		primaryStage.setMinWidth(300);
		primaryStage.setMinHeight(150);
		primaryStage.show();
	}


	/**
	 * Main Methode
	 * 
	 * @param args CLI Argumente
	 */
	public static void main(String[] args) {
		launch(args);
	}

}
