/**
 * @author schulke@th-brandenburg.de
 * @version 1.0.0
 * @see Java Documentation
 */
class Operatoren {
	public static void main(String[] args) {
		// Zufällige Startzahlen
		int x = 4;
		int b = 2;
		int c = 5;
		
		
		// 1. Arithmetische Ausdrücke
		double a = 2 * Math.PI / 3;
		double z = Math.pow(x, 2);

		System.out.println("2PI/3 = " + a);
		System.out.println(x + "^2 = " + z);

		z = Math.pow(x, 5);
		System.out.println(x + "^5 = " + z);
		
		double d = a / b;
		System.out.println(a + "/" + b + " = " + d);
		d = (5 * ((a + 1) / (b - c))) - (d * ((3 * a + b)/(b - (c * a)) * ((2*a)/(c + 3 * a))));
		System.out.println("d = " + d);

		// 2. Multiplikation und Division ganzzahliger Ausdrücke mit Zweierpotenzen
		int newA = b << 1;
		System.out.println("2" + b + " = " + newA);
		newA = b << 7;
		System.out.println("128" + b + " = " + newA);
		newA = b >> 1;
		System.out.println(b + "/2 = " + newA);
		newA = b >> 10;
		System.out.println(b + "/1024 = " + newA);


		// 3. Vergleichsoperatoren
		int k = 1;
		int y = 2;
		boolean vgl = a < b && b <= c;
		System.out.println(a + " < " + b + " <= " + c + " = " + vgl);
		vgl = (x != y) && (z > 0);
		System.out.println(x + " != " + y + " und " + z + " > 0 = " + vgl);
		vgl = (x > y) || ((0 < k) && k < 100);
		System.out.println(x + " > " + y + " oder ( 0 < " + k + " und k < 1000 ) = " + vgl);


		// 4. Setzen und Abfragen von Bitmustern
		int bitmuster = 0x0001;
		System.out.println("bitmuster 0x0001 = " + Integer.toHexString(bitmuster));
		bitmuster = bitmuster | (1 << 2);
		System.out.println("3. bit auf 1 setzen = " + Integer.toHexString(bitmuster));
		bitmuster = (bitmuster & ~(1 << 2)) & ~(1 << 6);
		System.out.println("3. und 7. bit auf 0 setzen = " + Integer.toHexString(bitmuster));
		boolean status = bitmuster > 0;
		System.out.println("wahrheitswert des bitmusters = " + status);
		boolean fuenftesBit = (bitmuster >> 4) > 0;
		System.out.println("5. bit gesetzt = " + fuenftesBit);
	}
}