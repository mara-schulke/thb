package com.maximilianschulke.gdp2.le06;

import java.util.ArrayList;


/**
 * Eine Ringspeichers Queue-Implementation
 * 
 * @author Maximilian Schulke <schulke@th-brandenbug.de>
 * @version 1.0.0
 */
public class CircularQueue<T> implements IQueue<T> {

	/**
	 * Die Maximalgröße
	 */
	private int size;

	/**
	 * Index des ersten Elementes
	 */
	public int head;

	/**
	 * Index des letzten Elementes
	 */
	public int tail;

	/**
	 * Liste mit allen Elementen
	 */
	private ArrayList<T> queue;


	/**
	 * Der Konstruktor
	 * 
	 * @param size Maximalgröße
	 */
	public CircularQueue(int size) {
		head = 0;
		tail = 0;
		queue = new ArrayList<T>();
		this.size = size;

		for (int i = 0; i < size; i++) {
			queue.add(null);
		}
	}


	/**
	 * @see IQueue
	 */
	@Override
	public void push(T el) throws QueueException {
		if (isFull()) {
			head = (tail + 1) % size;
		}

		queue.set(tail, el);
		tail = (tail + 1) % size;
	}


	/**
	 * @see IQueue
	 */
	@Override
	public T pop() throws QueueException {
		if (isEmpty()) {
			throw new QueueException("Queue is empty!");
		}

		T el = queue.set(head, null);
		head = (head + 1) % size;

		return el;
	}


	/**
	 * @see IQueue
	 */
	@Override
	public T head() throws QueueException {
		if (queue.isEmpty()) {
			throw new QueueException("Queue is empty!");
		}

		return queue.get(head);
	}


	/**
	 * @see IQueue
	 */
	@Override
	public T tail() throws QueueException {
		if (queue.isEmpty()) {
			throw new QueueException("Queue is empty!");
		}

		return queue.get(tail);
	}


	/**
	 * @see IQueue
	 */
	@Override
	public int length() {
		int emptySlots = queue.stream().filter(el -> el == null).toArray().length;

		return size - emptySlots;
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
	public boolean isFull() {
		int emptySlots = queue.stream().filter(el -> el == null).toArray().length;
		
		return emptySlots == 0;
	}


	/**
	 * @see IQueue
	 */
	@Override
	public boolean isEmpty() {
		int emptySlots = queue.stream().filter(el -> el == null).toArray().length;

		return emptySlots == size;
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
		if (!queue.isEmpty()) {
			throw new QueueException("Can't set the size of a circular queue if it contains elements");
		}

		this.size = size;
	}


	/**
	 * Formatiert die Instanz als String
	 * 
	 * @return String
	 */
	public String toString() {
		String s = "CircularQueue [ ";
		String items = "";

		for (T el : queue) {
			items += el + " -> ";
		}

		items = items.subSequence(0, items.lastIndexOf(" -> ")).toString();

		s += items + " ]";

		return s;
	}


	/**
	 * Testet die Klasse
	 * 
	 * @param args Commandline Argumente
	 */
	public static void main(String[] args) {
		CircularQueue<Integer> q = new CircularQueue<Integer>(5);

		try {
			System.out.println(q);
			System.out.println("Head: " + q.head);
			System.out.println("Tail: " + q.tail);
			System.out.println("Full: " + q.isFull());
			System.out.println("Empty: " + q.isEmpty());
			System.out.println("Length: " + q.length());
			System.out.println("\n");

			for (int i = 0; i < 9; i++) {
				q.push(i);
				System.out.println(q);
				System.out.println("Head: " + q.head);
				System.out.println("Tail: " + q.tail);
				System.out.println("Full: " + q.isFull());
				System.out.println("Empty: " + q.isEmpty());
				System.out.println("Length: " + q.length());
				System.out.println("\n");
			}

			for (int i = 0; i < 5; i++) {
				Integer popped = q.pop();
				System.out.println(q);
				System.out.println("Head: " + q.head);
				System.out.println("Tail: " + q.tail);
				System.out.println("Full: " + q.isFull());
				System.out.println("Empty: " + q.isEmpty());
				System.out.println("Length: " + q.length());
				System.out.println("Popped: " + popped);
				System.out.println("\n");	
			}

			// Triggering the errror by popping an empty queue
			q.pop();
		} catch (Exception e) {
			System.out.println("not working: " + e);
		}
	}

}
