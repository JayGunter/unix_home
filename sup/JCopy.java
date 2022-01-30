package jay;

import java.util.*;
import java.text.*;
import java.io.*;

public class JCopy {
    static void debug( String s ) {
	if ( true ) System.out.println( s );
    }

    public static void usage() {
	System.out.println( 
		"usage: java JCopy from_file to_dir items\n" );
	System.exit( 1 );
    }

    public static void main( String[] argv ) {
	//debug( "System.getProperty(user.dir)='" + System.getProperty("user.dir") + "'" );
	String ret = go( argv );
	if ( null != ret ) debug( ret );
    }

    public static String go( String[] argv ) {
	String ret = null;
	if ( argv.length < 3 ) usage();
	return go( argv[0], argv[1], argv, 2 );
    }

    public static String go( String from_dir, String to_dir, String[] items ) {
	return go( from_dir, to_dir, items, 0 );
    }

    public static String go( String from_dir, String to_dir, String[] items, int offset ) {
	debug( "from_dir='" + from_dir + "'" );
	debug( "to_dir='" + to_dir + "'" );
	String ret = null;
	String task = "?";
	try {
	    task = "check from_dir=" + from_dir;
	    debug( "task ='" + task  + "'" );
	    if ( null == from_dir || 0 == from_dir.length() ) 
		from_dir = ".";
	    File from = new File( from_dir );
	    if ( ! from.exists() ) 
		return "JCopy abort: from_dir does not exist: " + from_dir;
	    if ( ! from.isDirectory() ) 
		return "JCopy abort: from_dir is not a directory: " + from_dir;
	    
	    task = "check to_dir=" + to_dir;
	    debug( "task ='" + task  + "'" );
	    if ( null == to_dir ) 
		return "JCopy abort: to_dir undefined.";
	    File to = new File( to_dir );
	    if ( ! to.exists() ) {
		if ( ! to.mkdirs() ) 
		    return "JCopy abort: could not create: " + to_dir;
		if ( ! to.isDirectory() ) 
		    return "JCopy abort: target dir not created: " + to_dir;
	    } else {
		if ( ! to.isDirectory() ) 
		    return "JCopy abort: to_dir is not a directory: " + to_dir;
	    }
	    
	    task = "check items";
	    debug( "task ='" + task  + "'" );
	    if ( null == items )
		return "JCopy abort: missing item list.";
	    if ( offset >= items.length )
		return "JCopy abort: empty item list.";

	    for ( int i = offset; i < items.length; i++ ) {
		task = "check item: " + items[i];
	    debug( "task ='" + task  + "'" );
		debug( "items[i]='" + items[i] + "'" );
		int lastSlash = items[i].lastIndexOf( "/" );
		String targetDir = to_dir;
		if ( -1 != lastSlash ) { 
		    String subdir = items[i].substring( 0, lastSlash );
		    targetDir = to_dir + "/" + subdir;
		    File dir = new File( targetDir );
		    if ( dir.exists() ) {
			if ( ! dir.isDirectory() ) 
			    return "JCopy abort: target subdir is not a directory: " + targetDir;
		    } else {
			if ( ! dir.mkdirs() ) 
			    return "JCopy abort: target subdir could not created: " + targetDir;
			if ( ! dir.isDirectory() ) 
			    return "JCopy abort: target subdir was not created: " + targetDir;
		    }
		}

		File src = new File( from, items[i] );
		if ( ! src.exists() ) 
		    return "JCopy abort: not found: " + from_dir + "/" + items[i];
		
		if ( src.isDirectory() ) {
		    task = "copy dir: " + items[i];
	    debug( "task ='" + task  + "'" );
		    String[] subitems = src.list();
		    if ( null != subitems && 0 != subitems.length ) {
			String err = null;
			if ( null != ( err = go( src.getAbsolutePath(),
						 to_dir + "/" + items[i],
						 subitems ) ) )
			    return err;
		    }
		} else {
		    byte[] buf = new byte[ 10000 ];
		    int n = -1;
		    task = "open input stream for file: " + items[i];
	    debug( "task ='" + task  + "'" );
		    FileInputStream fis = new FileInputStream( src );
		    task = "open output stream for file: " + 
			    to_dir + "/" + items[i];
	    debug( "task ='" + task  + "'" );
		    FileOutputStream fos = new FileOutputStream( 
						    new File( to, items[i] ) );
		    task = "copy file: " + items[i];
	    debug( "task ='" + task  + "'" );
		    while ( -1 != ( n = fis.read( buf ) ) )
			fos.write( buf, 0, n );
		}
	    }
	    
	} catch ( Exception e ) {
	    debug( "task ='" + task  + "'" );
	    e.printStackTrace();
	    return "JCopy abort: could not " + task + "\n" + e;
	}
	return ret;
    }
}
