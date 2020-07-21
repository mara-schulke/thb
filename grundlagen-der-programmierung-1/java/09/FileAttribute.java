import java.io.File;
import java.nio.file.Paths;
import java.util.Scanner;

/**
 * FileAttribute ist ein Hilfsprogramm um Datei- und Ordner-Infos auszugeben.
 * Pfade können entweder über stdin oder als cli parameter übergeben werden. 
 * 
 * @author Maximilian Schulke <schulke@th-brandenburg.de>
 * @version 1.0.0
 */
public class FileAttribute {

    /**
     * Löst den gegebenen Pfad zu einer Datei oder einem Ordner auf und
     * gibt Daten zu Ort, Größe, Berechtigungen etc an stdout aus.
     * 
     * @param filename Dateipfad
     */
    public static void logFile(String filename) {
        File file = new File(filename);

        System.out.println("-- " + file + " --");

        if (!file.exists()) {
            System.out.println("exists\tfalse");
            return;
        }

        System.out.println("[meta]");
        System.out.println("\ttype\t\t" + (file.isDirectory() ? "dir" : "file"));
        System.out.println("\thidden\t\t" + file.isHidden());
        System.out.println("\tmodified\t" + file.lastModified());
        System.out.println("\tURI\t\t" + file.toURI());
        
        System.out.println("\n[path]");
        if (!file.isAbsolute())
            System.out.println("\trelative\t" +  filename);
        System.out.println("\tabsolute\t" + file.getAbsolutePath());
        
        System.out.println("\n[size]");
        System.out.println("\tsize\t\t" + file.length());

        System.out.println("\n[permissions]");
        System.out.println("\treadable\t" + file.canRead());
        System.out.println("\twriteable\t" + file.canWrite());
        System.out.println("\texecuteable\t" + file.canExecute());
        
        System.out.println("\n[misc]");
        System.out.println("\thashed\t\t" + file.hashCode());
        if (file.isDirectory())
            System.out.println("\tfiles\t\t" + String.join(", ", file.list()));

    }

    /**
     * Enthält Logik um die Pfade an das Kernprogramm zu übergeben.
     * 
     * @param args Datei- oder Ordner-Pfade (optional)
     */
    public static void main(String[] args) {
        if (args.length > 0) {
            for (int i = 0; i < args.length; i++)
                logFile(args[i]);
            
            return;
        }            
    
        System.out.println("Enter path to scan:");
        Scanner scanner = new Scanner(System.in);
        String filename = scanner.nextLine();
		logFile(filename);
		scanner.close();
    }

}