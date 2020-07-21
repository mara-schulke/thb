/**
 * Ein Converter stellt methoden zur Konvertierung von 
 * String nach Int und Int nach String zu verfügung.
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class Converter {
	/**
	 * Nimmt einen Int und gibt die Stringdarstellung von ihm zurück.
	 * Hier wird die built in methode Integer.toString() verwendet
	 * 
	 * @param a Zu übersetzender Int
	 * @return String darstellung von a
	 */
	public static String convertIntToStringWithToString(int a) {
		return Integer.toString(a);
	}

	/**
	 * Nimmt einen Int und gibt die Stringdarstellung von ihm zurück.
	 * Hier konvertieren wir händisch über die ASCII tabelle.
	 * 
	 * @param a Zu übersetzender Int
	 * @return String darstellung von a
	 */
	public static String convertIntToStringWithASCII(int a) {
		boolean isNegative = false;
		
		// falls negativ, merken und mit dem absoluten wert von a weiter rechnen
		if(a < 0) {
			isNegative = true;
			a = Math.abs(a);
		}

		/*
		zur optimierung könnte man hier noch mathematisch die länge berechnen
		(z.B. nach dem ansatz, welche potzenz ist die höchste, die in a reinpasst)
		*/
		int length = Integer.toString(a).length();
		int[] numbers = new int[length];

		/*
		für jede stelle rechnen wir den wert der potenz aus,
		teilen ohne nachkommastellen, speichern diesen wert
		und ziehen dann den gespeicherten wert mal potenz von a ab,
		um im nächsten schritt mit der kleineren potenz weiter zu rechnen
		*/
		for (int i = length - 1; i >= 0; i--) {
			int index = (length - 1) - i;
			int power = (int) Math.pow(10, i);

			numbers[index] = (int) Math.floor(a / power);
			a -= numbers[index] * power;
		}

		// es gibt so viele chars wie es stellen gibt
		char[] output = new char[length];
		int index = 0;

		// wir schreibe für stelle den int + 48 in die liste, um den ASCII wert von dem int zu bekommen
		for(int i : numbers) {
			output[index] = (char) (i + 48);
			index++;
		}

		// falls die zahl negativ war, hänge das vorzeichen wieder an
		if(isNegative) {
			return "-" + new String(output);
		}
		
		// ansonsten konvertiere die zahl ohne vorzeichen
		return new String(output);
	}

	/**
	 * Nimmt einen String und gibt die Int-Darstellung von ihm zurück.
	 * Hier wird die built in methode Integer.parseInt() verwendet.
	 * 
	 * @param str Zu übersetzender String
	 * @return Int-Darstellung des Strings
	 */
	public static int convertStringToIntWithParsing(String str) {
		return Integer.parseInt(str);
	}

	/**
	 * Nimmt einen String und gibt die Int-Darstellung von ihm zurück.
	 * Hier konvertieren wir händisch über die ASCII tabelle.
	 * 
	 * @param str Zu übersetzender String
	 * @return Int-Darstellung des Strings
	 */
	public static int convertStringToIntWithASCII(String a) {
		boolean isNegative = false;

		// falls der vorderste char ein '-' ist, ist die zahl negativ
		if(a.charAt(0) == '-') {
			isNegative = true;
			a = a.substring(1);
		}

		// fang bei 0 an zu zählen
		int output = 0;
		// fang von der höchstwertigen stelle an
		int index = a.length() - 1;

		/*
		für jeden char im string überprüfen wir, ob wir in der richtigen
		ascii range sind, falls nein, ist der string ungültig.
		ansonsten rechnen wir den dezimalwert des chars aus, in dem wir 48 abziehen
		dann rechnen wir anhand der position die potenz aus und beachten dabei,
		ob es eine negative ist - alternativ könnten wir auch einmalig am ende * oder / -1 rechnen,
		um zu negieren, ich habe mich für diesen weg entschieden, weil er während der entwicklung
		leichter zu verstehen ist - der andere ist allerdings performanter
		*/
		for(char i : a.toCharArray()) {
			if(i < 48 || i > 58) return 0;

			int docimal = (i - 48);
			int power = (int) (isNegative ? -1 * Math.pow(10, index) : Math.pow(10, index));

			output += docimal * power;
			index--;
		}

		return output;
	}

	public static void main(String[] args) {
		/*
		um zu überprüfen, ob alles funktioniert,
		nehmen wir eine weite range von möglichen zahlen
		und prüfen sie gegen die java builtin methoden
		*/
		int[] testInts = { -2491, -212, -22, -0, 0, 10, 540, 20130, 24102, 2143021424 };

		System.out.println("convertStringToIntWithASCII:");
		for( int i : testInts ) {
			int convertedI = convertStringToIntWithASCII(String.valueOf(i));
			System.out.println(i + " == " + convertedI + " is " + (i == convertedI));
		}
		System.out.println("\n\n");

		System.out.println("convertStringToIntWithParsing:");
		for( int i : testInts ) {
			int convertedI = convertStringToIntWithParsing(String.valueOf(i));
			System.out.println(i + " == " + convertedI + " is " + (i == convertedI));
		}
		System.out.println("\n\n");

		System.out.println("convertIntToStringWithASCII:");
		for( int i : testInts ) {
			String convertedI = convertIntToStringWithASCII(i);
			System.out.println(i + " == " + convertedI + " is " + (String.valueOf(i).equals(convertedI)));
		}
		System.out.println("\n\n");

		System.out.println("convertIntToStringWithToString:");
		for( int i : testInts ) {
			String convertedI = convertIntToStringWithToString(i);
			System.out.println(i + " == " + convertedI + " is " + (String.valueOf(i).equals(convertedI)));
		}
	}
}