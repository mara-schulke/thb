/**
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 * @see Java Documentation
 */
public class Berechnungen {
	/**
	 * Die Zahl PI (3.141592653589793....)
	 * @see java.lang.Math
	 */
	public static final double PI = Math.PI;

	/**
	 * Berechnet den Umfang eines Kreises
	 * @param radius
	 * @return umfang
	 */
	public static double berechneUmfang(double radius) {
		return (2 * PI) * radius;
	}

	/**
	 * Berechnet den Flächeninhalt eines Kreises
	 * @param radius
	 * @return fläche
	 */
	public static double berechneFlaeche(double radius) {
		return PI * Math.pow(radius, 2);
	}

	public static void main(String[] args) {
		double radius = 10.0d;

		System.out.println("radius = " + radius);
		System.out.println("umfang = " + berechneUmfang(radius));
		System.out.println("fläche = " + berechneFlaeche(radius));
	}
}