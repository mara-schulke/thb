package com.maximilianschulke.gdp2.le06;


public interface IQueue<T> {

	public void push(T el) throws QueueException;

	public T pop() throws QueueException;

	public T head() throws QueueException;

	public T tail() throws QueueException;

	public int size();	

	public void clear();

	public boolean isFull();

	public boolean isEmpty();

	public int getMaximumSize();

	public void setMaximumSize(int max) throws QueueException;

}
