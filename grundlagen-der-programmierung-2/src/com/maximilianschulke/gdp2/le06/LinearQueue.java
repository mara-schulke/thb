package com.maximilianschulke.gdp2.le06;

import java.util.ArrayList;


public class LinearQueue<T> implements IQueue<T> {
	
	private int max;


	private ArrayList<T> queue;


	public LinearQueue() {
		max = Integer.MAX_VALUE;
		queue = new ArrayList<>();
	}


	@Override
	public void push(T el) throws QueueException {
		if (isFull()) {
			throw new QueueException("The queue is full!");
		}

		queue.add(el);	
	}


	@Override
	public T pop() throws QueueException {
		if (queue.isEmpty()) {			
			throw new QueueException("The queue is empty!");
		}

		T el = queue.get(0);
		queue.remove(0);
		return el;
	}


	@Override
	public T head() throws QueueException {
		if (queue.isEmpty()) {
			throw new QueueException("The queue is empty!");
		}

		return queue.get(0);
	}


	@Override
	public T tail() throws QueueException {
		if (queue.isEmpty()) {
			throw new QueueException("The queue is empty!");
		}

		return queue.get(queue.size() - 1);
	}


	@Override
	public int size() {
		return queue.size();
	}


	@Override
	public boolean isFull() {
		return queue.size() >= this.max;
	}


	@Override
	public boolean isEmpty() {
		return queue.isEmpty();
	}


	@Override
	public void clear() {
		queue.clear();
	}


	@Override
	public int getMaximumSize() {
		return max;
	}


	@Override
	public void setMaximumSize(int max) throws QueueException {
		if (queue.size() > max) {
			throw new QueueException("You can't set a maximum which is smaller than the length of the queue");
		}
		
		this.max = max;
	}


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
