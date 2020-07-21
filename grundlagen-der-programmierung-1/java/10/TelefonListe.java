import java.io.File;
import java.io.IOException;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;

/**
 * Die Klasse TelefonListe kann Telefonlisten-Einträge verwalten, speichern und laden. 
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class TelefonListe {

	/**
	 * Ein Fehler, der geworfen werden soll, wenn ein Eintrag bereits in einer Liste vorhanden ist.
	 */
	public static class EntryAlreadyInListException extends Exception {}

	/**
	 * Ein Fehler, der geworfen werden soll, wenn ein Eintrag nicht in einer Liste gefunden wurde.
	 */
	public static class EntryNotFoundException extends Exception {}

	/**
	 * Der Speicherort der Einträge
	 */
	public static ArrayList<String> liste = new ArrayList<String>();

	/**
	 * Löscht die gesamte Liste.
	 */
	public static void clear() {
		liste = new ArrayList<String>();
	}

	/**
	 * Fügt einen Eintrag zur Liste hinzu, falls dieser noch nicht vorhanden ist.
	 * 
	 * @param entry Der Eintrag, der hinzugefügt werden soll.
	 * @throws EntryAlreadyInListException
	 */
	public static void add(String entry) throws EntryAlreadyInListException {
		if (liste.indexOf(entry) != -1) throw new EntryAlreadyInListException();

		liste.add(entry);
	}

	/**
	 * Entfernt einen Eintrag aus der Liste, falls dieser vorhanden ist.
	 * 
	 * @param entry Der Eintrag, der entfernt werden soll.
	 * @throws EntryNotFoundException
	 */
	public static void remove(String entry) throws EntryNotFoundException {
		if (liste.indexOf(entry) == -1) throw new EntryNotFoundException();

		liste.remove(entry);
	}

	/**
	 * Speichert die Liste in eine Datei. Überschreibt ggf. eine bereits vorhandene Version der Datei.
	 * 
	 * @param file Die Datei, in die die Liste gespeichert werden soll.
	 * @throws IOException
	 */
	public static void save(File file) throws IOException {
		if (file.exists()) file.delete();

		file.createNewFile();

		BufferedWriter writer = new BufferedWriter(new FileWriter(file));

		for(String eintrag : liste)
			writer.append(eintrag +  "\n");

		writer.close();
	}

	/**
	 * Läd die Liste aus einer Datei.
	 * 
	 * @param file
	 * @throws IOException
	 */
	public static void load(File file) throws IOException {
		if (!file.exists()) throw new IOException("File not found.");
		clear();

		BufferedReader reader = new BufferedReader(new FileReader(file));

		String ln = reader.readLine();

		while (ln != null) {
			liste.add(ln);
			ln = reader.readLine();
		}

		reader.close();
	}

	/**
	 * Gibt die gesamte Telefonliste auf der Konsole aus.
	 */
	public static void print() {
		if (liste.size() < 1) return;

		System.out.println("Telefonliste:");
		liste.forEach(System.out::println);
		System.out.println();
	}

	/**
	 * Gibt einen Eintrag der Liste auf der Konsole aus.
	 * 
	 * @param n Index des Eintrags in der Liste.
	 */
	public static void printNth(int n) {
		if (n < 0 || liste.size() < n - 1) return;

		System.out.println(liste.get(n));
	}

	/**
	 * Liest einen Eintrag von der Konsole ein.
	 * 
	 * @param br Die BufferedReader Instanz, die verwendet werden soll, um inputs anzufragen.
	 * @return Der eingelesene Eintrag
	 */
	public static String readEntry(BufferedReader br) {
		String name = "";

		System.out.println("Bitte gebe einen Namen ein:");

		while (true) {
			try {
				name = br.readLine().trim();

				if (name.equals("")) continue;

				break;
			} catch (Exception e) {
				System.err.println("Eingabefehler");
			}
		}

		String number = "";

		System.out.println("Bitte gebe eine Telefonnummer ein:");

		while (true) {
			try {
				number = br.readLine().trim();

				if (number.equals("")) continue;

				break;
			} catch (Exception e) {
				System.err.println("Eingabefehler");
			}
		}

		return name + " " + number;
	}

	/**
	 * Leert die Konsole.
	 */
	public static void blank() {
		System.out.print("\033[H\033[2J");
		System.out.flush();
	}

	/**
	 * Lässt das Programm eine Sekunde schlafen.
	 * Nützlich um einen Loop kurzzeitig zu pausieren um Fehler anzuzeigen.
	 */
	public static void sleep() {
		try {
			java.lang.Thread.sleep(2000);
		} catch (Exception e) {}
	}

	/**
	 * Gibt eine Komando-Übersicht auf die Konsole aus.
	 */
	public static void help() {
		String[] text = {
			"TelefonListe.java - Laden, Speichern und Bearbeiten von Telefonlisten",
			"",
			"Usage:",
			"    telefonliste [option]",
			"",
			"Options:",
			"    -load <Dateipfad>\t\tDatei, aus der eine Telefonliste wiederhergestellt werden soll.",
			"",
			"Interactive Commands:",
			"    a\t\t\t\tHinzufügen",
			"    d\t\t\t\tLöschen",
			"    r\t\t\t\tLaden",
			"    w\t\t\t\tSpeichern",
			"    h\t\t\t\tHilfe",
			"    q\t\t\t\tSchließen"
		};
		
		Arrays
			.stream(text)
			.forEach(System.out::println);
	};

	/**
	 * Ein kleines interaktives Konsolen-Programm, dass die Funktionalität der Klasse testet.
	 * 
	 * @param args Übergebene Arguments.
	 */
	public static void main(String[] args) {
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));

		if (args.length > 0) {
			if (args.length == 2 && args[0].equals("-load") && args[1].length() >= 1) {
				try {
					System.out.println("Lade Telefonliste..");
					load(new File(args[1]));
					System.out.println("Telefonliste geladen..");
					print();
				} catch (Exception e) {
					System.err.println("Datei " + args[1] + " ist nicht lesbar oder existiert nicht.");
					return;
				}
			} else {
				help();
				return;
			}
		} 
		
		while (true) {
			blank();
			print();
			System.out.println("Was möchtest du tun? [a,d,r,w,h,q]");
			System.out.print(">>> ");
			char command;

			while (true) {
				try {
					command = (char) br.read();

					if((int) command == 10) continue;

					break;
				} catch (Exception e) {
					System.err.println("Eingabefehler");
				}
			}

			switch (command) {
				case 'a':
					String entry = readEntry(br);
					
					try {
						add(entry);
					} catch(EntryAlreadyInListException e) {
						System.err.println("Dieser Eintrag existiert schon.");
						sleep();			
					}

					continue;

				case 'd':
					System.out.println("Bitte gebe die Zeilennummer ein, die du löschen möchtest");
					int index;

					while (true) {
						try {
							index = Integer.parseInt(br.readLine());
							break;
						} catch (Exception e) {}
					}

					try {				
						remove(liste.get(index - 1));
					} catch (Exception e) {
						System.err.println("Eintrag nicht gefunden.");
						sleep();			
					}

					continue;

				case 'r':
					System.out.println("Bitte gebe einen Dateipfad ein, aus dem du die Telefonliste laden möchtest:");
					String source;
					
					while (true) {
						try {
							source = br.readLine();

							if (source.length() == 0) continue;

							break;
						} catch (Exception e) {}
					}

					File s = new File(source);

					if (s.isDirectory()) {
						System.out.println("Ein ordner ist keine gültige datei.");
						sleep();
					}

					try {
						load(s);
					} catch (IOException e) {
						System.err.println("Datei konnte nicht gelesen werden.");
						sleep();
					}

					continue;


				case 'w':
					System.out.println("Bitte gebe den Dateinamen ein, in den du die Telefonliste speichern möchtest:");
					String target;
					
					while (true) {
						try {
							target = br.readLine();

							if (target.length() == 0) continue;

							break;
						} catch (Exception e) {}
					}

					File f = new File(target);

					if (f.isDirectory()) {
						System.out.println("Ein ordner ist keine gültige datei.");
						sleep();
					}

					try {
						save(f);
					} catch (IOException e) {
						System.err.println("Datei konnte nicht beschrieben werden.");
						sleep();
					}

					continue;

				case 'q':
					blank();
					return;

				case 'h':
					help();
					sleep();			
					continue;

				default:
					System.out.println("Befehl nicht verstanden");
					sleep();			
					continue;
			}
		}
	}
}
