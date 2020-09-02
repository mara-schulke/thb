/**
 * StringChange experimentiert mit dem Verhalten von String und char[]
 * 
 * @author Maximilian Schulke <schulke@th-brandeburg>
 * @version 1.0.0
 */
public class StringChange {
	public static void main(String[] args) {
		String str = "Hello Welt!";
		char[] chars = str.toCharArray();

		chars[1] = 'a';

		System.out.println("String = " + str + ";\nchar[] = " + chars.toString());
		System.out.print("char[] elements output one by one = ");

		for ( char c : chars ) {
			System.out.print(c);
		}
		
		System.out.print('\n');
		System.out.print("char[] as String = " + new String(chars));
	}
}