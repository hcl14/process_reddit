import java.io.*;

public class CharFilter {

    public static void main(String[] args) throws IOException {


        String fileName = args[0];
        FileInputStream fencrypt;
        try {
            fencrypt = new FileInputStream(fileName);
        } catch (FileNotFoundException fnf) {
            System.out.println("File Not Found!");
            return;
        }
        byte[] buf = new byte[10240];
        int length;
        String s;
        StringBuilder builder = new StringBuilder();
        String outName = args.length > 1 ? args[2] : "out.txt";
        BufferedWriter writer = new BufferedWriter(new FileWriter(outName));
        try {
            while (true) {
                length = fencrypt.read(buf);
                if (length == -1) {
                    break;
                }
                s = new String(buf);
                builder.setLength(0);
                for (int i = 0; i < s.length(); i++){
                    if (!Character.isIdentifierIgnorable(s.charAt(i))){
                        builder.append(s.charAt(i));
                    }

                }
                writer.write(builder.toString());
                writer.flush();
            }
        } catch (IOException io) {
            System.out.println("Error Reading File!");
        } finally {
            fencrypt.close();
            writer.close();
        }
        System.out.println("Success");
    }
} 
