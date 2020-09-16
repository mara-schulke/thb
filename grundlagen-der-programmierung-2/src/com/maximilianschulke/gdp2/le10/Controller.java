package com.maximilianschulke.gdp2.le10;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

public class Controller extends Application {

	@Override
    public void start(Stage stage) throws Exception {
    	Parent root = FXMLLoader.load(getClass().getResource("view.fxml"));
    
    	Scene scene = new Scene(root, 800, 800);
    
    	stage.setTitle("Drawing App");
    	stage.setScene(scene);
    	stage.show();
    }


	public static void main(String[] args) {
	    launch(args);
	}

}
