/**
 * @author Maximilian Schulke schulke@th-brandenburg.de
 * @version 1.0.0
 * @see Java Documentation
 */
public class DataTypes {
	/**
	 * Gibt Konstanten primitiver Daten-Typen aus.
	 * Definiert lokale Variablen und zeigt Beispiele für literals.
	 * Gibt eine Liste von Cast-Operationen aus.
	 * 
	 * @param args command line argumente
	 */
	public static void main(String[] args) {
		// Kostanten
		System.out.printf("Byte%nMIN-> %d%nMAX-> %d%n%n", Byte.MIN_VALUE, Byte.MAX_VALUE);
		System.out.printf("Short%nMIN-> %d%nMAX-> %d%n%n", Short.MIN_VALUE, Short.MAX_VALUE);
		System.out.printf("Integer%nMIN-> %d%nMAX-> %d%n%n", Integer.MIN_VALUE, Integer.MAX_VALUE);
		System.out.printf("Long%nMIN-> %d%nMAX-> %d%n%n", Long.MIN_VALUE, Long.MAX_VALUE);
		System.out.printf("Float%nMIN-> %f%nMAX-> %.10e%n%n", Float.MIN_VALUE, Float.MAX_VALUE);
		System.out.printf("Double%nMIN-> %f%nMAX-> %.10e%n", Double.MIN_VALUE, Double.MAX_VALUE);

		// Wertebereiche
		byte negativeByte = -128;
		byte positiveByte = 127;

		short negativeShort = -32768;
		short positiveShort = 32767;

		char charZ = 'Z';
		char numZ = 90; 

		int negativeInt = -2_147_483_648;
		int positiveInt = 2_147_483_647;

		long negativeLong = -9_223_372_036_854_775_808l;
		long positiveLong = 9_223_372_036_854_775_807l;

		float negativeFloat = -3402823.0f;
		float positiveFloat = 3402823.0f;

		double negativeDouble = -179_028_210_232_223.0;
		double positiveDouble = 179_028_221_322_113.0;

		// Konvertierung / Casting
		System.out.println("\n:::::::::::::::::::::::::::::::\n");

		// Char -> Int funktioniert, da wir die Länge von 2 Byte auf 4 Byte erhöhen.
		System.out.println("Char -> Int");
		char A = 'A';
		int intA = A;
		System.out.println(A + " -> " + intA);
		System.out.println();

		// Int -> Long funktioniert, da wir die Länge von 4 Byte auf 8 Byte erhöhen.
		System.out.println("Int -> Long");
		int B = 402102;
		long longB = B;
		System.out.println(B + " -> " + longB);
		System.out.println();

		// Long -> Short funktioniert nicht, da wir die Länge von 8 Byte nicht auf 2 Byte verkleinern können. (Da wir die Zahl unter Umständen nicht mehr darstellen könnten)
		System.out.println("Long -> Short");
		System.out.println("Funktioniert nicht, da wir die Länge von 8 Byte nicht auf 2 Byte verkleinern können. (Da wir die Zahl unter Umständen nicht mehr darstellen könnten)");
		System.out.println();

		// Int -> Float funktioniert, da wir die Länge von 4 Bytes beibehalten.
		System.out.println("Int -> Float");
		int C = 21472;
		float floatC = C;
		System.out.println(C + " -> " + floatC);
		System.out.println();

		// Long -> Double funktioniert, da wir die Länge von 8 Bytes beibehalten.
		System.out.println("Long -> Double");
		long D = 21_472_214_321l;
		double doubleD = D;
		System.out.println(D + " -> " +  doubleD);
		System.out.println();

		// Double -> Long funktioniert, da wir die Länge von 8 Bytes beibehalten.
		System.out.println("Double -> Long");
		long castedD = (long) doubleD; // Via casting 
		long roundedD = Math.round(doubleD); // mit Math.round
		System.out.println(doubleD + " -> " +  castedD);
		System.out.println();

		// Char -> Float funktioniert, da wir die Länge von 2 Bytes auf 4 Bytes erhöhen.
		System.out.println("Char -> Float");
		char E = 'E';
		float floatE = E;
		System.out.println(E + " -> " +  floatE);
		System.out.println();	

		// Float -> Double funktioniert, da wir die Länge von 4 Bytes auf 8 Bytes erhöhen.
		System.out.println("Float -> Double");
		float F = 1.0f;
		double doubleF = F;
		System.out.println(F + " -> " +  doubleF);
	}
}