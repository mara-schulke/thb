import java.util.Scanner;
import java.util.Locale;

/**
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class Kalkulator {
	/**
	 * Eine Aufzählung der möglichen Operatoren
	 */
	enum Operator {
		Plus,
		Minus,
		Mal,
		Geteilt;

		/**
		 * Erstellt einen Operator aus einem String
		 * @param op Der Operator als String
		 * @return Den konvertierten Operator
		 * @throws Exception
		 */
		public static Operator from(String op) throws Exception {
			switch(op.trim()) {
				case "+": return Plus;
				case "-": return Minus;
				case "*": return Mal;
				case "/": return Geteilt;
				default: throw new Exception("Unbekannter Operator");
			}
		}

		/**
		 * Führt eine Berechnung mit diesem Operator aus.
		 * @param op1 Linker Operand
		 * @param op2 Rechter Operand
		 * @return Gibt das Ergebnis zurück
		 */
		public double exec(double op1, double op2) {
			switch(this) {
				case Plus: return op1 + op2;
				case Minus: return op1 - op2;
				case Mal: return op1 * op2;
				case Geteilt: return op1 / op2;
				default: return 0; // Kann niemals eintreten
			}
		}

		/**
		 * Serialisiert den Operator als String
		 * @return Zeichen des Operator
		 */
		public String toString() {
			switch(this) {
				case Plus: return "+";
				case Minus: return "-";
				case Mal: return "*";
				case Geteilt: return "/";
				default: return ""; // Kann niemals eintreten
			}
		}
	}

	/**
	 * Kalkuliert das Ergebnis der übergebenen Parameter
	 * 
	 * @param operand1 Linker Operand
	 * @param operator Operator
	 * @param operand2 Rechter Operand
	 * @return Ergebnis
	 */
	static double kaklukiere(double operand1, Operator operator, double operand2) {
		return operator.exec(operand1, operand2);
	}

	/**
	 * Liest einen Boolean ein.
	 * @param prompt Text zur Eingabeaufforderung
	 * @return Ergebnis der Eingabe
	 */
	static boolean liesBool(Scanner scanner, String prompt) {
		System.out.println(prompt);
		while(true) {
			try {
				String input = scanner.next().trim().toLowerCase();

				if(
					input.equals("y") ||
					input.equals("yes") ||
					input.equals("j") ||
					input.equals("ja")
				)
					return true;
				else if(
					input.equals("n") ||
					input.equals("no") ||
					input.equals("nein")
				)
					return false;
				else {
					throw new Exception("Nicht lesbar.");
				}
			} catch(Exception e) {
				System.out.println("Das hat leider nicht geklappt. Bitte versuchen Sie es erneut:");
				continue;
			}
		}
	}

	/**
	 * Liest einen Double ein.
	 * @param prompt Text zur Eingabeaufforderung
	 * @return Ergebnis der Eingabe
	 */
	static double liesDouble(Scanner scanner, String prompt) {
		System.out.println(prompt);

		while (true) {
			try {
				return Double.parseDouble(scanner.next());
			} catch(Exception e) {
				System.out.println("Das hat leider nicht geklappt. Bitte versuchen Sie es erneut:");
				continue;
			}
		}
	}

	/**
	 * Liest einen Operator ein.
	 * @param prompt Text zur Eingabeaufforderung
	 * @return Ergebnis der Eingabe
	 */
	static Operator liesOperator(Scanner scanner, String prompt) {
		System.out.println(prompt);
		while(true) {
			try {
				return Operator.from(scanner.next());
			} catch(Exception e) {
				System.out.println("Das hat leider nicht geklappt. Bitte versuchen Sie es erneut:");
				continue;
			}
		}
	}

	/**
	 * Führt solange Berechnungen aus, bis der Benutzer das Programm stoppt.
	 * @param args cli args
	 */
	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		scanner.useLocale(Locale.US);

		while(true) {
			System.out.print("\033[H\033[2J");

			double operand1 = liesDouble(scanner, "Bitte den ersten Operanden eingeben:");
			Operator operator = liesOperator(scanner, "Gebe einen Operator ein (+-*/):");
			double operand2 = liesDouble(scanner, "Bitte den zweiten Operanden eingeben:");

			System.out.println("\n" + operand1 + " " + operator + " " + operand2 + " = " + operator.exec(operand1, operand2) + "\n");

			boolean restart = liesBool(scanner, "Weitere Berechnung starten (ja/nein)?");

			if(!restart) {
				break;
			}
		}
	}
}