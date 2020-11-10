package com.maximilianschulke.gdp2.le06;


/**
 * Ein generisches Interface für alle Queue ähnlichen
 * Datenstrukturen
 * 
 * @author Maximilian Schulke <schulke@th-brandenbug.de>
 * @version 1.0.0
 */
public interface IQueue<T> {

	/**
	 * Fügt ein Element ans Ende an
	 * 
	 * @param el Element
	 * @throws QueueException
	 */
	public void push(T el) throws QueueException;

	/**
	 * Entfernt das erste Element
	 * 
	 * @return Entferntes Element
	 * @throws QueueException
	 */
	public T pop() throws QueueException;

	/**
	 * Gibt das erste Element zurück
	 * 
	 * @return Erstes Element
	 * @throws QueueException
	 */
	public T head() throws QueueException;

	/**
	 * Gibt das letztes Element zurück
	 * 
	 * @return Letztes Element
	 * @throws QueueException
	 */
	public T tail() throws QueueException;

	/**
	 * Gibt die Länge der Queue zurück
	 * 
	 * @return Länge
	 */
	public int length();	

	/**
	 * Entfernt alle Element
	 */
	public void clear();

	/**
	 * Gibt an ob die Queue voll ist
	 * 
	 * @return Ist die Liste voll
	 */
	public boolean isFull();

	/**
	 * Gibt an ob die Queue leer ist
	 * 
	 * @return Ist die Queue leer?
	 */
	public boolean isEmpty();

	/**
	 * Gibt die Maximalgröße zurück
	 * 
	 * @return Maximalgröße
	 */
	public int getSize();

	/**
	 * Setzt die Maximalgröße
	 * 
	 * @param size Maximalgröße
	 * @throws QueueException
	 */
	public void setSize(int size) throws QueueException;

}
