import java.util.*;
import java.text.*;
import java.io.*;

public class BreakUp {

    public static void main( String[] argv ) {
	InputStream f = null;
	try {
	    f = System.in;
	    int c = 0;
	    while ( -1 != ( c = f.read( ) ) ) {
		System.out.print( (char) c );
		if ( '>' == c ) 
		    System.out.print( '\n' );
	    }


	} catch ( Exception e ) {
	    System.out.println( "boo!");
	    e.printStackTrace();
	} finally {
	    try {
		f.close();
	    } catch ( Exception e ) {
		e.printStackTrace();
	    }
	}
    }
}
