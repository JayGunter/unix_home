import java.io.*;
import java.util.*;
import java.text.*;
class FileModStamp {

    public static void main( String[] argv ) {
	go( argv );
    }

    public static void go( String[] argv ) {
	try {
	String SDF = "yyMMdd";
	SimpleDateFormat df = new SimpleDateFormat( SDF );
	File f = new File( argv[0] );
	long mod = f.lastModified();
	String ret = df.format( new Date( mod ) );
	System.out.println( ret  );
	} catch ( Exception e ) {
	    e.printStackTrace();
	}
    }
}
