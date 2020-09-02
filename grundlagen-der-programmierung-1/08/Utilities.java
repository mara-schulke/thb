/**
 * Beinhaltet nützliche Funktionen.
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class Utilities {

	/**
	 * Rekursive Implementierung der mathematischen Fakultäts-Funktion.
	 * 
	 * @param n Zahl dessen Fakultät berechnet werden soll
	 * @return Mathematische Fakultät von n
	 */
	public static int fakultaet(int n) {
		if (n <= 0) return 1;

		return n * fakultaet(n - 1);
	}

	/**
	 * Rukursive Implementierung der mathematischen Potenz.
	 * 
	 * @param n
	 * @param power
	 * @return n^power
	 */
	public static int potenz(int n, int power) {
		if (power <= 0) return 1;

		return n * potenz(n, power - 1);
	}

	public static void main(String[] args) {
		System.out.println("fakultaet(5) = " + fakultaet(5) + "\t 5! = 120");
		System.out.println("fakultaet(10)= " + fakultaet(10) + "\t 10! = 3628800");
		System.out.println("fakultaet(8) = " + fakultaet(8) + "\t 8! = 40320");
		System.out.println("fakultaet(2) = " + fakultaet(2) + "\t 2! = 2");

		System.out.println("potenz(5,2) = " + potenz(5,2) + "\t 5^2 = 25");
		System.out.println("potenz(10,4)= " + potenz(10,4) + "\t 10^4 = 10000");
		System.out.println("potenz(8,9) = " + potenz(8,9) + "\t 8^9 = 134217728");
		System.out.println("potenz(2,12)= " + potenz(2,12) + "\t 2^12 = 2");
	}

}