package com.maximilianschulke.gdp2.le10;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

public class Main extends Application {

	@Override
	public void start(Stage stage) throws Exception {
		Parent root = FXMLLoader.load(getClass().getResource("view.fxml"));

		Scene scene = new Scene(root, 800, 600);

		stage.setTitle("Drawing App");
		stage.setScene(scene);
		stage.setMinWidth(800);
		stage.setMinHeight(600);
		stage.show();
	}


	public static void main(String[] args) {
		launch(args);
	}

}
