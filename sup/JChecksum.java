import java.security.*;
import java.io.*;
//import java.util.zip.CRC32;
//import java.util.zip.Checksum;

public class JChecksum {
    public static int ret = 0;

    public static void main(String[] args) {
	if ( args.length < 2 ) {
	    System.out.println(
		"Usage : java JChecksum create fileX fileY fileZ\n" +
                "will create fileX.MD5, fileY.MD5 and fileZ.MD5\n\n" +
		"Usage : java JChecksum check fileX fileY fileZ\n" +
                "will report whether fileX.MD5 is still the correct checksum for fileX, ...\n");
	    System.exit(101);
	}

	for (int i=1; i<args.length; i++) {
	    if	    (args[0].equals("create")) {
		new JChecksum().create(args[i]);
	    }
	    else if (args[0].equals("check")) {
		new JChecksum().check(args[i]);
	    }
	}
	System.exit(ret);

    }

    public int create(String filename){
        try {
	    byte[] chk = createChecksum(filename);
	    File f = new File(filename + ".MD5");
	    OutputStream os = new FileOutputStream(f);
	    os.write(chk);
	    os.close();
	    return 0;
	}
	catch(Exception e) {
            System.out.println("ERROR: Failed to create: " + filename + ".MD5: " + e.getMessage() );
	    //e.printStackTrace();
	    System.exit(102);
	    return 0;
	}

    }

    public int check(String filename){
        int rc = 0;
        try {
            byte[] chk1 = createChecksum(filename);
            byte[] chk2 = new byte[chk1.length];
            File f = new File(filename + ".MD5");
            InputStream is = new FileInputStream(f);

            is.read(chk2);

            if (new String(chk2).equals(new String(chk1))) {
                System.out.println("JChecksum: " + filename + " checksum matches.");
            }
            else {
                System.out.println("JChecksum: " + filename + " checksum does not match!");
                ++ret;
            }
            is.close();
            return ret;
        }
        catch(Exception e) { 
	    System.out.println("ERROR: Failed to check: " + filename );
	    e.printStackTrace();
	    return -3;
	}
    }

    public byte[] createChecksum(String filename) throws Exception{
	InputStream fis =  new FileInputStream(filename);

	byte[] buffer = new byte[1024];
	MessageDigest complete = MessageDigest.getInstance("MD5");
	int numRead;
	do {
	    numRead = fis.read(buffer);
	    if (numRead > 0) {
		complete.update(buffer, 0, numRead);
	    }
	} while (numRead != -1);
	fis.close();
	return complete.digest();
    }
}
