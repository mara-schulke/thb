import java.util.Arrays;

/**
 * Ein Labyrinth, bestehend aus Feldern, mit der Möglichkeit
 * rekursiv einen Lösungweg zu finden.
 * 
 * @version 1.0.0
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 */
public class Labyrinth {
	/**
	 * Felder & utilities zum verarbeiten von Feldern.
	 */
	enum Field {
		WALL,
		EMPTY,
		PLAYER;

		public String toString() {
			switch(this) {
				case WALL: return "X";
				case EMPTY: return " ";
				case PLAYER: return "*";
				default: return "";
			}
		}

		public static Field fromChar(char c) {
			switch(c) {
				case 'X': return WALL;
				case ' ': return EMPTY;
				case '*': return PLAYER;
				default: return EMPTY;
			}
		}

		public static Field[] fromStringToFields(String s) {
			return s.chars()
					.mapToObj(c -> Field.fromChar((char) c))
					.toArray(Field[]::new);
		}
	}

	/**
	 * Die Dimension eines Labyrinths.
	 */
	public static final int DIMENSION = 10;

	/**
	 * Der Mittelpunkt eines Labyrinths.
	 */
	public static final int MIDDLE = (DIMENSION / 2);

	/**
	 * Die Felder des Labyrinths.
	 */
	private Field[][] fields = new Field[DIMENSION][DIMENSION];

	/**
	 * Erstellt aus ein neues Labyrinth aus einer String-Darstellung.
	 * 
	 * @param f Das Lanbyrinth in String-Darstellung
	 */
	public Labyrinth(String f) {
		fields =
			f.lines()
			.map(s -> Field.fromStringToFields(s))
			.toArray(Field[][]::new);
	}

	/**
	 * Erstellt ein neues Labyrinth aus einem Array von Arrays mit Feldern.
	 * 
	 * @param f Die Felder
	 */
	public Labyrinth(Field[][] f) {
		fields = f;
	}

	/**
	 * escape() flieth aus dem Labyrinth.
	 */
	public void escape() {
		System.out.println("Labyrinth:");
		print();
		System.out.println("\n");

		boolean success = walk(MIDDLE - 1, MIDDLE - 1);

		if (success) {
			System.out.println("Fluchtweg:");
			print();
		} else {
			System.out.println("Es gibt leider keinen Fluchtweg!");
		}
	}

	/**
	 * walk() läuft rekusriv alle möglichen wege ab, bis wir am Rand angekommen sind.
	 * 
	 * @param x Momentane X Koordinate
	 * @param y Momentane Y Koordinate
	 */
	private boolean walk(int x, int y) {
		fields[y][x] = Field.PLAYER;
	
		if (!isInMaze(x,y)) {
			return true;
		}

		if (
			(x > 0 && fields[y][x-1] == Field.EMPTY && walk(x-1, y)) ||
			(x < DIMENSION - 1 && fields[y][x+1] == Field.EMPTY && walk(x+1, y)) ||
			(y > 0 && fields[y-1][x] == Field.EMPTY && walk(x, y-1)) ||
			(y < DIMENSION - 1 && fields[y+1][x] == Field.EMPTY && walk(x, y+1))
		) return true;
	
		fields[y][x] = Field.EMPTY;
	
		return false;
	}

	/**
	 * Eine Hilfsmethode um zu überprüfen, ob ein Feld noch innerhalb des Labyrinths liegt.
	 * 
	 * @param x X Koordinate
	 * @param y Y Koordinate
	 * @return Wahr wenn das Feld im Labyrinth liegt, Falsch wenn es ein Randfeld ist.
	 */
	private boolean isInMaze(int x, int y) {
		return x > 0 && x < DIMENSION - 1 && y > 0 && y < DIMENSION - 1;
	}

	/**
	 * Gibt das gesamte Labyrinth aus.
	 */
	public void print() {
		Arrays.stream(fields)
			.forEach(y -> {
				Arrays.stream(y).forEach(System.out::print);
				System.out.println("");
			});
	}

	public static void main(String[] args) {
		// Labyrinth aus der datei labyrinth-1
		Labyrinth mazeOne = new Labyrinth(
			"XX X  X X\n" +
			"X  XX   X\n" +
			" X  XX X \n" +
			"X  X  X X\n" +
			"   X  XXX\n" +
			"X XXX X X\n" +
			"  X    XX\n" +
			"XXXX XXXX\n" +
			"XXX   X X\n" +
			" X  XX X \n"
		);
	
		mazeOne.escape();

		System.out.println("\n\n\n");

		// Labyrinth aus der datei labyrinth-2
		Labyrinth mazeTwo = new Labyrinth(
			"X  XX X  \n" +
			"XX X  X X\n" +
			"X  X  X X\n" +
			"  X    XX\n" +
			"   X  XXX\n" +
			"XXXX XXXX\n" +
			"XXX   X X\n" +
			" X  XX X \n" +
			"X  XX   X\n" +
			"X XXX X X\n"
		);

		mazeTwo.escape();

		System.out.println("\n\n\n");

		// Um zu zeigen, dass auch unlösbare Labyrinthe erkannt werden.
		Labyrinth unsolveable = new Labyrinth(
			"XXXXXXXXX\n" +
			"XXXXXXXXX\n" +
			"XXXXXXXXX\n" +
			"XXXX XXXX\n" +
			"XXX   XXX\n" +
			"XXXX XXXX\n" +
			"XXXXXXXXX\n" +
			"XXXXXXXXX\n" +
			"XXXXXXXXX\n" +
			"XXXXXXXXX\n"
		);

		unsolveable.escape();
	}
}