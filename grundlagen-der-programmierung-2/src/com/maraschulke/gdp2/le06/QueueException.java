package com.maraschulke.gdp2.le06;


/**
 * Eine QueueException fasst alle Ausnahmen die mit
 * dem Queues in Zusammenhang stehen zusammen
 * 
 * @author Mara Schulke <schulke@th-brandenbug.de>
 * @version 1.0.0
 */
public class QueueException extends Exception {
	public QueueException() {super();}
	public QueueException(String message) {super(message);}
}
