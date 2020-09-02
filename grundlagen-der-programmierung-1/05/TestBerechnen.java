/**
 * Testet die Klasse Berechnen
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 * @see Berechnen
 */
public class TestBerechnen {
	public static void main(String[] args) {
		double radius = 20.0d;

		System.out.println("radius = " + radius);
		System.out.println("umfang = " + Berechnungen.berechneUmfang(radius));
		System.out.println("fläche = " + Berechnungen.berechneFlaeche(radius));
	}
}