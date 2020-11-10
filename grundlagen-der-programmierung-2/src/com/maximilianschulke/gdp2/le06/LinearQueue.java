package com.maximilianschulke.gdp2.le06;

import java.util.ArrayList;


/**
 * Eine lineare Queue-Implementation
 * 
 * @author Maximilian Schulke <schulke@th-brandenbug.de>
 * @version 1.0.0
 */
public class LinearQueue<T> implements IQueue<T> {

	/**
	 * Maximalgröße der Queue
	 */
	private int size;

	/**
	 * Enthält die Elemente der Queue
	 */
	private ArrayList<T> queue;


	/**
	 * Der Konstruktor
	 */
	public LinearQueue() {
		size = Integer.MAX_VALUE;
		queue = new ArrayList<>();
	}


	/**
	 * @see IQueue
	 */
	@Override
	public void push(T el) throws QueueException {
		if (isFull()) {
			throw new QueueException("The queue is full!");
		}

		queue.add(el);	
	}


	/**
	 * @see IQueue
	 */
	@Override
	public T pop() throws QueueException {
		if (queue.isEmpty()) {			
			throw new QueueException("The queue is empty!");
		}

		T el = queue.get(0);
		queue.remove(0);
		return el;
	}


	/**
	 * @see IQueue
	 */
	@Override
	public T head() throws QueueException {
		if (queue.isEmpty()) {
			throw new QueueException("The queue is empty!");
		}

		return queue.get(0);
	}


	/**
	 * @see IQueue
	 */
	@Override
	public T tail() throws QueueException {
		if (queue.isEmpty()) {
			throw new QueueException("The queue is empty!");
		}

		return queue.get(queue.size() - 1);
	}


	/**
	 * @see IQueue
	 */
	@Override
	public int length() {
		return queue.size();
	}


	/**
	 * @see IQueue
	 */
	@Override
	public boolean isFull() {
		return queue.size() >= this.size;
	}


	/**
	 * @see IQueue
	 */
	@Override
	public boolean isEmpty() {
		return queue.isEmpty();
	}


	/**
	 * @see IQueue
	 */
	@Override
	public void clear() {
		queue.clear();
	}


	/**
	 * @see IQueue
	 */
	@Override
	public int getSize() {
		return size;
	}


	/**
	 * @see IQueue
	 */
	@Override
	public void setSize(int size) throws QueueException {
		if (queue.size() > size) {
			throw new QueueException("You can't set a maximum size which is smaller than the length of the queue");
		}

		this.size = size;
	}


	/**
	 * Formatiert die Instanz als String
	 * 
	 * @return String
	 */
	public String toString() {
		String s = "LinearQueue [ ";
		String items = "";

		for (T el : queue) {
			items += el + " >- ";
		}

		items = items.subSequence(0, items.lastIndexOf(" >- ")).toString();
		items = new StringBuilder(items).reverse().toString();

		s += items + " ]";

		return s;
	}


	/**
	 * Testet die Klasse
	 * 
	 * @param args Commandline Argumente
	 */
	public static void main(String[] args) {
		LinearQueue<Integer> q = new LinearQueue<Integer>();

		try {			
			q.push(1);
			q.push(2);
			q.push(3);
			q.push(4);
			q.push(5);
			q.push(6);
			System.out.println(q + "\n" + q.pop() + " -> popped\n" + q.head() + " -> head\n" + q.tail() + " -> tail\n");
			System.out.println(q + "\n" + q.pop() + " -> popped\n" + q.head() + " -> head\n" + q.tail() + " -> tail\n");
			System.out.println(q + "\n" + q.pop() + " -> popped\n" + q.head() + " -> head\n" + q.tail() + " -> tail\n");
		} catch (Exception e) {
			System.out.println("not working");
		}
	}

}
