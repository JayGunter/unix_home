import java.io.*;
 
public class FileUtil {
 
	public static void main(String[] args) throws IOException {
		
		/*
		File source = new File( args[0] );
		File destination = new File( args[1] );
		
		
		copyDirectory(source, destination);
		if(!delete(source)) {
			throw new IOException("Unable to delete original folder");
		}
		*/ 
		
	    if ( args.length > 0 ) {
		if ( "rename".equals( args[0] ) ) {
		    rename( args[1], args[2] );
		}
	    }
	}
	
	
public static void copyFile(File source, File dest) throws IOException {
	
	if(!dest.exists()) {
		dest.createNewFile();
	}
        InputStream in = null;
        OutputStream out = null;
        try {
        	in = new FileInputStream(source);
        	out = new FileOutputStream(dest);
    
	        // Transfer bytes from in to out
	        byte[] buf = new byte[1024];
	        int len;
	        while ((len = in.read(buf)) > 0) {
	            out.write(buf, 0, len);
	        }
        }
        finally {
        	in.close();
            out.close();
        }
        
}
	
public static void copyDirectory(File sourceDir, File destDir) throws IOException {
		
	if(!destDir.exists()) {
		destDir.mkdir();
	}
	
	File[] children = sourceDir.listFiles();
	
	for ( int i = 0; i < children.length; i++ ) {
		File sourceChild = children[i];
		String name = sourceChild.getName();
		File destChild = new File(destDir, name);
		if(sourceChild.isDirectory()) {
			copyDirectory(sourceChild, destChild);
		}
		else {
			copyFile(sourceChild, destChild);
		}
	}	
}
	
public static boolean delete(File resource) throws IOException { 
	if(resource.isDirectory()) {
		File[] children = resource.listFiles();
		for ( int i = 0; i < children.length; i++ ) {
			delete(children[i]);
		}
					
	}
	return resource.delete();
	
}

public static void rename( String oldpath, String newpath ) throws IOException {
	
	File source = new File( oldpath );
	File destination = new File( newpath );
	
	source.renameTo(destination);
}

}


