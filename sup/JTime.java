import java.util.*;
import java.text.*;
class JTime {
    public static void usage() {
	if ( null != err_str ) {
	    System.out.println( err_str );
	} else {

	    System.out.println( "JTime format options:\n"
	     + " -i[\"SimpleDateFormat\"] specifies input format for following dates\n"
	     + " -f[\"SimpleDateFormat\"] prints in default or specifed date format\n"
	     + "   The default format is \"EEE MMM dd hh:mm:ss zzz yyyy\":"
	     + "         Thu Nov 18 13:10:33 PST 2004\n"
	     + " -e\"string to display on date parsing error\"\n"
	     + " -m prints in milliseconds\n"
	     + " -s prints in [[[#days] #hours] #minutes] #seconds\n"
	     + "\n"
	     + " -i can be specified multiple times.\n"
	     + " -f, -m and -s override each other.\n"
	     + " These options can be used in the following usages:\n"
	     + "\n"
	     + " JTime ms1|date1 \n"
	     + "	prints ms1 or date1 in requested style\n"
	     + " JTime -d ms1|date1 \n"
	     + "	returns #seconds between ms1 (or date1) and current time \n"
	     + " JTime ms1|date1 ms2|date2 \n"
	     + "	returns #seconds between ms1|date1 and ms2|date2 \n"
	     + " JTime -t ms1|date1 ... \n"
	     + "	returns sum ms1|date1 + ... \n"
	    ); 

	}
	System.exit( 1 );
    }

    public static final int FORMAT_SDF  = 0;
    public static final int FORMAT_MS   = 1;
    public static final int FORMAT_DHMS = 2;

    public static void main( String[] argv ) {
	String ret = go( argv );
	if ( null != ret && null == err_str ) System.out.println( ret );
    }

    public static String format(    String  value,
				    int	    outputFormat ) {
	String[] argv = new String[ 2 ];
	argv[0] = value;
	switch ( outputFormat ) {
	    case FORMAT_SDF:	argv[1] = "-f";  break;
	    case FORMAT_MS:	argv[1] = "-m";  break;
	    case FORMAT_DHMS:	argv[1] = "-s";  break;
	    default:		usage();    return null;
	}
	return go( argv );
    }

    public static String format(    String  inputFormat,
				    String  value,
				    int	    outputFormat ) {
	String[] argv = new String[ 3 ];
	argv[0] = "-i" + inputFormat;
	argv[1] = value;
	switch ( outputFormat ) {
	    case FORMAT_SDF:	argv[2] = "-f";  break;
	    case FORMAT_MS:	argv[2] = "-m";  break;
	    case FORMAT_DHMS:	argv[2] = "-s";  break;
	    default:		usage();    return null;
	}
	return go( argv );
    }

    static String err_str = null;

    public static String go( String[] argv ) {
	long now = (new Date()).getTime();
	long[] ms = { now, now };
	long sum = 0L;
	int s = 0;

	String default_SFD = "EEE MMM dd hh:mm:ss zzz yyyy";
	String in_SDF  = default_SFD;
	String out_SDF = default_SFD;

	int     format = FORMAT_SDF;

	boolean diff   = false;
	boolean total  = false;

	// JTime understands standard output of Unix 'date' utility.
	int n = argv.length;
	for ( int i = 0; i < n && null != argv[i]; i++ ) {
	    if ( 0 == argv[i].indexOf( "-" ) ) {
		char ch1 = argv[i].charAt(1);
		switch ( ch1 ) {
		    case 'e':	if ( argv[i].length() > 2 ) 
				    err_str = argv[i].substring( 2 );
				break;
		    case 'i':	if ( argv[i].length() > 2 ) 
				    in_SDF = argv[i].substring( 2 );
				break;
		    case 'f':	format = FORMAT_SDF;
				if ( argv[i].length() > 2 ) 
				    out_SDF = argv[i].substring( 2 );
				break;
		    case 'm':	format = FORMAT_MS;
				break;
		    case 's':	format = FORMAT_DHMS;
				break;
		    case 'd':	diff = true;
				break;
		    case 't':	total = true;
				break;
		    default:	usage();
				break;
		}
	    } else {
		long x = 0L;
		if ( -1 != argv[i].indexOf( ":" ) || 
		     -1 != argv[i].indexOf( " " ) ) {
		    SimpleDateFormat df = new SimpleDateFormat( in_SDF );
//System.out.println( "in_SDF ='" + in_SDF  + "'" );
//System.out.println( "zzz="+ DateFormat.getDateInstance().format(new Date()));

		    //Date dd = new Date( argv[i] );
		    Date dd = new Date();
		    try {
//System.out.println( "argv[i] ='" + argv[i]  + "'" );
			dd = df.parse( argv[i] );
//System.out.println( "dddd=" + dd );
			Date nn = new Date( now );
			/*
			System.out.println( "dd.getYear()='" + dd.getYear() + "'" );
			System.out.println( "dd.getMonth()='" + dd.getMonth() + "'" );
			System.out.println( "dd.getDate()='" + dd.getDate() + "'" );
			*/
			if ( 70 == dd.getYear() ) {
			    // If the year is missing, assume this year.
			    dd.setYear( nn.getYear() );
			}
		    } catch ( Exception e ) {
			//e.printStackTrace();
			if ( null == err_str ) {
			    System.err.println( "JTime: input date (" + argv[i] + ") is not in the format: " + in_SDF + "\n" );
			}
			usage();
		    }
		    x = dd.getTime();
		} else {
		    try {
			x = Long.parseLong( argv[i] );
		    } catch ( Exception e ) {
			//e.printStackTrace();
			if ( null == err_str ) {
			    System.err.println( "JTime: input date is not a long value: " + argv[i] + "\n" );
			}
			usage();
		    }
		}
		if ( total ) {
		    sum += x;
		} else {
		    ms[s++] = x;
		    if ( s > 1 ) {
			diff = true;
			//break;
		    }
		}
	    }
	}

	//if ( s == 1 && ! total ) format = true;
	long out = ms[0];
//System.out.println( "s0=" + ms[0] + ", s1=" + ms[1] + "\n" );
	if ( diff ) {
	    out = ms[0] - ms[1];
	    if ( FORMAT_SDF == format )	{
		// when subtracting dates only -m or -s makes sense
		format = FORMAT_DHMS;
	    }
	}
	if ( total ) {
	    out = sum;
	    //if ( ! advance ) diff = true;
	    //diff = true;
	}
	if ( out < 0 ) out = -out;
//System.out.println( "out=" + out + ", diff=" + diff + ", format=" + format + "\n" );
	String ret = null;
	switch ( format ) {
	    case FORMAT_DHMS:
		long mi = out % 1000;
		long se = ( out /= 1000 ) % 60;
		long mn = ( out /= 60 )   % 60;
		long hr = ( out /= 60 )   % 24;
		String d = "";
		if ( out > 0 ) d  = ( out /= 24 ) + " days ";
		if ( d.length() > 0 || hr  > 0 ) d += hr  + " hours ";
		if ( d.length() > 0 || mn  > 0 ) d += mn  + " mins ";
		d += se  + " secs";
		//System.out.println( d );
		ret = d;
		break;
	    case FORMAT_SDF:
		//Date f = new Date( out );
		//System.out.println( f );
		SimpleDateFormat df = new SimpleDateFormat( out_SDF );
		StringBuffer sb = new StringBuffer();
		//System.out.println( df.format( new Date( out ), sb, new FieldPosition( 0 ) ) );
		ret = df.format( new Date( out ), sb, new FieldPosition( 0 ) ).toString();
		break;
	    case FORMAT_MS:
		//System.out.println( out );
		ret = "" + out;
		break;
	}
	return ret;
    }
}
