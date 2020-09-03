package com.maximilianschulke.gdp2.le04;


public class Test {

	public static void main(String[] args) {
		Ellipse e = new Ellipse(0, 0, 10, 10);
		System.out.println("Eclipse:");
		e.show();
		
		Circle c = new Circle(0, 0, 15);
		System.out.println("\nCircle:");
		c.show();
	}

}
