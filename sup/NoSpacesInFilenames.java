
//package com.trueframe;


import java.util.*;
import java.io.*;

public class NoSpacesInFilenames {

    static String replaceBadChars(String s) {
	return s.replaceAll("\\W+", "_");
//	return s.replaceAll( "[ \\[\\]\\(\\)\\{\\}\\!@\\#\\$\\%\\^\\&\\*\\?\\;\\'\\"]+", "X");
    }

    public static void main( String[] argv ) {
	try {
	    if ( 0 == argv.length ) {
		argv = new String[1];
		argv[0] = ".";
	    }

	    for ( int i = 0; i < argv.length; i++ ) {
//System.err.println(argv[i] + ":" + replaceBadChars(argv[i]) + ":");
//if (true) continue;
//System.err.println("a=" + argv[i]);
		File dir = new File( argv[i] );
		File[] files = dir.listFiles();
		for ( int j = 0; j < files.length; j++ ) {
		    String oldname = files[j].getName();
		    int k;
			    k = oldname.lastIndexOf(".");
			    if (-1 == k) {
//				System.out.println( "ERROR: file has no suffix: " + oldname );
				continue;
			    }
//System.err.println("oldname=" + oldname);
		    //if (true) {
		    if (oldname.matches(".*(webm|jpg|gif|png|avi|mpg|mp4|wmv|JPG|GIF|PNG|AVI|MPG|MP4|WMV)$")) {

//		    String newname = replaceBadChars(oldname);
		    String newname = replaceBadChars(oldname.substring(0,k)) +  oldname.substring( k );
//System.err.println("------ new=" + newname);
/*
		    String newname = oldname;
		    int k;
		    String badChars = " [](){}!@#$%^&*?;'\"";
		    for ( int m = 0; m < badChars.length(); m++ ) {
			while ( -1 != ( k = newname.indexOf( badChars.charAt(m) ) ) ) { 
			    newname =	newname.substring( 0, k ) + "_" +
					newname.substring( k + 1 );
			}
		    }
*/

		    if ( newname.length() > 30) {
			k = newname.lastIndexOf(".");
			newname = newname.substring(0, k > 30 ? 30 : k) + newname.substring(k);
		    }
			
		    if ( ! newname.equals( oldname ) ) {
			File newfile = new File( 
				files[j].getParent() + "/" + newname );
			for (int n = 1; newfile.exists(); n++) {
			    k = newname.lastIndexOf(".");
			    if (-1 == k) {
				System.out.println( "ERROR: file has no suffix: " + oldname );
				break;
			    }
			    String versionedname =  newname.substring( 0, k ) + "_" + n + 
						    newname.substring( k );
			    newfile = new File( 
				files[j].getParent() + "/" + versionedname );
			}
			if ( files[j].renameTo( newfile ) )
			    System.out.println( "Fixed filename: " + newfile.getName() );
			else
			    System.out.println( "ERROR: Failed to fix filename: " + oldname );
		    }
		    }
		}
	    }
	} catch ( Exception e ) {
	    System.out.println( "ERROR in NoSpacesInFilenames" );
	    e.printStackTrace();
	}
    }
}




