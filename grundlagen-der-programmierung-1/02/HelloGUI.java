import java.awt.*;
import javax.swing.*;

/**
 * HelloGUI opens a window with a given title.
 * 
 * @author Maximilian Schulke schulke@th-brandenburg.de
 * @version 1.01
 * @see <a href="https://docs.oracle.com/javase/10/docs/api/javax/swing/JFrame.html">JFrame</a>
 */
public class HelloGUI extends JFrame {

	/**
	 * HelloGUI constructs the window and defines behavior.
	 * 
	 * @param title The window title.
	 */
	public HelloGUI(String title) {
		super(title);
		getContentPane().add("North", new JButton("Hello World"));
		setSize(300, 200);
		setVisible(true);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	}

	/**
	 * The paint method is responsible for drawing the window contents.
	 * It is called automatically by JFrame so you should avoid calling it directly.
	 * 
	 * @param g The java swing Graphics class.
	 * @see <a href="https://docs.oracle.com/javase/10/docs/api/java/awt/Graphics.html">Graphics</a>
	 */
	public void paint(Graphics g) {
		g.drawString("Hello World!", 100, 100);
		g.drawRect(80, 80, 120, 30);
	}

	/**
	 * The main method. (This gets executed by the jvm directly)
	 * 
	 * @param args The commandline arguments.
	 */
	public static void main(String args[]) {
		new HelloGUI("Hello World ");
	}
}