//package com.trueframe;


import java.util.*;
import java.text.*;
import java.io.*;

public class Typeset {
    static void debug( String s ) {
	if ( true ) System.out.println( s );
    }

    public static void usage() {
	System.out.println( 
		"usage: java Typeset 1(single page output too) a(author's remarks) l(linenums of search hits) search-string page-num-to-debug\n" );
	System.exit( 1 );
    }

    public static String[] line = new String[100];
    public static String[] foot = new String[100];
    public static String base_dir_name = "./";
    public static File base_dir = null;
    public static int chapter = 0;
    public static boolean set_chapter=false;
    public static int prev_chapter=0;
    public static int next_chapter=0;
    public static int linenum = 0;
    public static int maxline = 0;
    public static int maxfoot = 0;
    public static int line_len = 0;
    public static int disp_lines = 0;
    public static int wrap_width = 66;
    public static int foot_wrap_width = 60;
    public static int wrap_chars = 0;
    public static int def_pagelen = 32;
    public static int pagelen = def_pagelen;
    public static int body_footnum = 0;
    public static String this_footlead = null;
    public static String cont_footlead = null;
    public static HashMap<String,String> footnum_map = new HashMap<String,String>();
    public static int footnum = 0;
    public static int lastfootnum = 0;
    public static boolean seenfoot = false;
    //public static boolean doingfoot = false;
    public static boolean infoot = false;
    public static int cont_foot = 0;
    public static String cont_foot_markup = "";
    public static String next_page_cont_foot_markup = "";
    public static String a_tag = "";
    public static boolean incomment = false;
    public static boolean tabbed = false;
    public static boolean lastwastabbed = false;
    public static boolean done = false;
    public static BufferedReader c = null;
    public static BufferedWriter fout = null;
    public static BufferedWriter fout1 = null;
    public static BufferedWriter chap_js = null;
    public static String[] clio = null;
    public static String[] head1 = null;
    public static String[] tail1 = null;
    public static int lines_for_chap_head = 10;
    public static int lines_for_elipsis = 4;
    public static String page_starts_with_chap = null;


    public static String[] arrayFromFile( String path ) {
	Vector<String> v = new Vector<String>();
	String line = null;
	try {
	    BufferedReader c = new BufferedReader( new FileReader( new File( base_dir, path )));
	    while ( null != ( line = c.readLine() ) ) 
		v.addElement( line );
	    c.close();
	} catch (Exception esl) {
		note( esl + ": Could not read file " + path + ", base_dir=" + base_dir );
	}
	String[] ret = new String[ v.size() ];
	v.copyInto( ret );
	return ret;
    }

    public static void out( String[] lines ) {
	for ( int i = 0; i < lines.length; i++ ) {
	    out( lines[i] );
	}
    }
    public static void out1( String[] lines ) {
	for ( int i = 0; i < lines.length; i++ ) {
	    out1( lines[i] );
	}
    }
    public static void out( String line ) {
	try {
	    //fout.write( "" + linenum + " " );
	    /*
	    fout.write( line + '\n' );
	    fout1.write( line + '\n' );
	    */
	    out1( line );
	    out2( line );
	} catch ( Exception e ) {
	    e.printStackTrace();
	}
    }
    public static void out1( String line ) {
	try {
	    //fout.write( "" + linenum + " " );
	    if ( null != fout1 ) fout1.write( line + '\n' );
	} catch ( Exception e ) {
	    e.printStackTrace();
	}
    }
    public static void out2( String line ) {
	try {
	    //fout.write( "" + linenum + " " );
	    fout.write( line + '\n' );
	} catch ( Exception e ) {
	    e.printStackTrace();
	}
    }

    public static String turn_page_msg = "Turn pages using the arrow keys if you like.  Hit ? for details.";

    public static void out1_pagenum( int page ) {
	out1( "<br><table width=100%><tr><td class=\"page_num\" align=center>" +
	    "<a title=\"" + turn_page_msg + "\" onclick=\"keyhandle(37);return;\"><img src=\"../config/images/left_arrow.gif\" alt=\"" + turn_page_msg + "\"></a>&nbsp;&nbsp;" +
	    page + 
	    "&nbsp;&nbsp;<a title=\"" + turn_page_msg + "\" onclick=\"keyhandle(39);return;\"><img src=\"../config/images/right_arrow.gif\" alt=\"" + turn_page_msg + "\"></a>" +
	    " </td></tr></table><br>"
	);
    }

    public static void td_margin() {
	//out( "<td style=\"background-color: blue;\" width=\"10px\">&nbsp;&nbsp;</td>" );
	out2( "<td class=\"mypage\" width=\"10px\">&nbsp;&nbsp;</td>" );
    }

    public static void td( int pct, String align ) {
	//out( "<td class=\"mypage\" valign=\"top\" align=\"" + align + "\" width=\"" + pct + "%\" style=\"font-family: Times New Roman; font-size: 10pt;\"><div align=justify>" );
	String valign = "valign=\"top\"";
	if ( page == 0 ) valign = "";
	//out2( "<td class=\"mypage\" valign=\"top\" align=\"" + align + "\" width=\"" + pct + "%\"><div align=justify>" );
	out2( "<td class=\"mypage\" " + valign + " align=\"" + align + "\" width=\"" + pct + "%\"><div align=justify>" );
    }
    public static void td( int pct ) {
	td( pct, "left" );
    }
    public static void td1() {
	//out( "<div align=justify class=\"mypage\" style=\"font-family: Times New Roman; font-size: 10pt;\">" );
	String align = "center";
	String pct = "100";
	String valign = "valign=\"top\"";
	if ( page == 0 ) valign = "";
	//out1( "<td class=\"mypage\" valign=\"top\" width=\"" + pct + "%\"><div align=justify>" );
	out1( "<td class=\"mypage\" " + valign + " width=\"" + pct + "%\"><div align=justify>" );
	out( "<div align=justify class=\"mypage\">" );
    }

    public static void pageout() {
	try {
	    //out( "<br>" );
	    out( "<span class=whiteonwhite>----_____x----_____x----_____x----_____x----_____x----_____x</span><br>" );
	    
	    //doingfoot = false;
	    /*
	    if ( null != lastTextMarkup ) {
		//System.out.println( page + ", " + markat + ", " + lastTextMarkup + ", " + markedline );
		String s = stringRemove( lastTextMarkup, "\"" );
		out( stringRemove( s, "`" ) );
	    }
	     * */

	    for ( int i = 0; i < maxline; i++ ) 
		out( line[i] );

	    out( "</span>" );

	    if ( inChandler ) out( endChandler );

	    //footnum = lastfootnum;

	    if ( 0 < maxfoot ) {
		//doingfoot = true;
		//out( "<hr><div style=\"background-color: #ffffbb; font-size=smaller;\"><table>" );
		String debug = "";
		//debug += maxline + "," + maxfoot;
		
		//out( "</div>" + debug + "<hr><div class=\"footnote\"><table>" );

		out( "</div>" + debug + 
		    ( maxline > 0 ? "<hr>" : "" ) + 
		    "<div class=\"footnote\"><table>" );

		if ( null != cont_footlead ) {
		    int i = cont_footlead.indexOf( "&nbsp;</sup>" );
		    if ( -1 == i )
			i = cont_footlead.indexOf( ")</sup>" );
		    if ( -1 == i )
			note( "ERROR!!  wierd cont_footlead" );
		    else
			cont_footlead = 
			    cont_footlead.substring( 0, i ) +
			    "&nbsp;cont." +
			    cont_footlead.substring( i ) +
			    cont_foot_markup;

		    out( cont_footlead );
		    //System.out.println( "@@@@@@@@@@@ cont_footlead ='" + cont_footlead  + "'" );
		}

		cont_foot_markup = next_page_cont_foot_markup; 

		for ( int i = 0; i < maxfoot; i++ ) 
		    out( foot[i] );

		out( "</table></div>" );
	    }
	} catch ( Exception e ) {
	    e.printStackTrace();
	}

	lastTextMarkup = thisTextMarkup;
	lastFootMarkup = thisFootMarkup;
    }
	
    public static boolean inChandler = false;
    public static boolean hadChandler = false;
    public static String beginChandler = "<div class=chandler>";
    public static String endChandler = "</div><!-- endChandler -->";
    public static boolean justBeganChandler = false;
    public static boolean justEndedChandler = false;
    public static boolean prevLineEndedChandler = false;
    public static int pagesSinceChandler = 0;

    public static String laststring = "";
    public static String lastfound = "";
    public static String thisFootMarkup = "";
    public static int markat = -1;
    public static String markedline = null;
    public static String thisTextMarkup = null;
    public static String lastFootMarkup = "";
    public static String lastTextMarkup = null;
    public static boolean instyle = false;
    public static String stringReplace( String s, String old, String _new ) {
	String ret = "";
	String t = s;
	int i = 0;
	while ( -1 != ( i = t.indexOf( old ) ) ) {
	    if ( old.startsWith( "." ) && i >= 2 && ( -1 != ".D".indexOf( t.charAt( i - 2 ) ) ) ) {
		// in cases like 3:29 p.m. and S.P.F.D. and Dr.,
		// don't replace old with _new,
		// don't insert an inappropriate end-of-sentence double-space.
		ret += t.substring( 0, i + old.length() );
		t = t.substring( i + old.length() );
	    } else {
		lastfound = _new;
		laststring = s;
		ret += t.substring( 0, i ) + _new;
		t = t.substring( i + old.length() );
	    }
	}
	ret += t;
	return ret;
    }
    public static String stringRemove( String s, String _del ) {

	String ret = s;
	int i = 0;
	if ( -1 != ( i = s.indexOf( _del ) ) ) {
	    ret = s.substring( 0, i ) + s.substring( i + _del.length() );
	}
	return ret;
    }

    public static boolean saidSinceChandler = false;
    public static boolean saidExtend = false;
    public static boolean startedfoot = false;
    public static boolean footnote_in_footnote = false;
    public static int linesIn = 0;
    public static int pageload() {
	int ret = 0;
	int start_line = linesIn;
	pagelen = def_pagelen;
	saidSinceChandler = false;
	saidExtend = false;
	seenfoot = false;
	a_tag = "";
	try {
	    maxline = 0;
	    maxfoot = 0;
	    disp_lines = 0;
	    wrap_chars = 0;
	    String buf = null;


	    if ( null != page_starts_with_chap ) {
		line[maxline++] = page_starts_with_chap;
		page_starts_with_chap = null;
		pagelen -= lines_for_chap_head;
	    }

//if (119<page && page<124)
//System.out.println( "inChandler ='" + inChandler  + "'" + page );
	    if ( inChandler ) {
		//out( beginChandler );
		line[maxline++] = beginChandler;
	    }

	    if ( null != lastTextMarkup ) {
		//System.out.println( page + ", " + markat + ", " + lastTextMarkup + ", " + markedline );
		String s = stringRemove( lastTextMarkup, "\"" );
		//out( stringRemove( s, "`" ) );
		line[maxline++] = stringRemove( s, "`" );
	    }

	    cont_footlead = this_footlead;

	    while ( true ) {
		debug_page( page, "pagelen=" + pagelen + ",maxline=" + maxline + ", maxfoot=" + maxfoot );
		prevLineEndedChandler = justEndedChandler | justBeganChandler;
		justEndedChandler = justBeganChandler = false;

		//if ( null == ( buf = c.readLine() ) ) 
		if ( linesIn >= clio.length ) {
		    done = true;
		    break;
		}

		buf = clio[linesIn];

		linesIn++;

		if ( 0 == buf.indexOf( "jjj" ) ) {
		    done = true;
		    break;
		}

		if ( 0 == buf.indexOf( "$" ) ) {
		    note( "!!!!!!!!!!!!! maxline=" + maxline + ", maxfoot=" + maxfoot );
		    continue;
		}
		if ( 0 == buf.indexOf( "//" ) ) {
		    continue;
		}
		if ( 0 == buf.indexOf( "*/" ) ) {
		    incomment = false;
		    continue;
		}
		if ( 0 == buf.indexOf( "/*" ) ) 
		    incomment = true;
		if ( incomment )
		    continue;
		if ( 0 == buf.indexOf( "!" ) && ! include_authors_remarks )
		    continue;

		// do not break up a footnote that will end soon.
		boolean foot_ends_soon = false;
		if ( infoot ) {
		    // This is very inefficient.  For every line in a footnote
		    // I am checking to see it that footnote "ends soon".
		    // But comments make it hard to know with certainty
		    // how "soon" the current footnote will end.
		    if ( buf.equals( "." ) ) {
				    foot_ends_soon = true;
		    } else {
			int soon = 3;
			boolean comment_skipping = false;
			String soon_buf = "";
			for ( int i = linesIn;
				i < clio.length && soon > 0;
				i++ ) {
			    soon_buf = clio[i];
			    if (    0 == soon_buf.indexOf( "$" ) ||
				    0 == soon_buf.indexOf( "//" ) ||
				    0 == soon_buf.indexOf( "EC" ) ||
				    0 == soon_buf.indexOf( "!" ) )
				continue;
			    if ( 0 == soon_buf.indexOf( "*/" ) ) {
				comment_skipping = false;
				continue;
			    }
			    if ( 0 == soon_buf.indexOf( "/*" ) )
				comment_skipping = true;
			    if ( comment_skipping )
				continue;
			    if ( soon_buf.equals( "." ) ) {
				    foot_ends_soon = true;
				    break;
			    }
			    soon--;
			}
			/*
			if ( 0 != soon ) 
			    foot_ends_soon = true;
			*/
		    }
		}

		//if ( ( ( ret = maxline + maxfoot ) > pagelen ) && 
		if ( ( ( ret = disp_lines ) > pagelen ) && 
			// ! infoot )
			! foot_ends_soon )
		{
		    // a long footnote can cause an overlong page.
		    // need to be able to split a footnote across pages.
		    if ( infoot ) {
			cont_foot = body_footnum;
			foot[maxfoot++] = 
			    " <Sup class=\"footnote_num\"> continued</sup>";
		    }

		    // reprocess the current line for the next page
		    linesIn--; 

		    break;
		}

		if ( ! infoot && ! buf.startsWith( "*" ) )
		    footnote_in_footnote = false;
		search_page( page, buf );
		int ibc = buf.indexOf( "BC" );
		if ( -1 != ibc ) {
		    hadChandler = true;
		    if ( pagesSinceChandler > 10 ) 
			if ( ! saidSinceChandler ) {
			    note( "pagesSinceChandler=" + pagesSinceChandler );
			    saidSinceChandler = true;
			}
		}
		if ( 0 == ibc && 2 == buf.length() ) {
		    inChandler = true;
		    if ( infoot) {
			foot[maxfoot++] = beginChandler;
			next_page_cont_foot_markup = beginChandler;
		    } else {
			line[maxline++] = beginChandler;
		    }
		    justBeganChandler = true;
		    continue;
		}
		if ( 0 == buf.indexOf( "EC" ) ) {
		    inChandler = false;
		    if ( infoot ) {
			foot[maxfoot++] = endChandler;
			next_page_cont_foot_markup = "";
		    } else {
			line[maxline++] = endChandler;
		    }
		    justEndedChandler = true;
		    continue;
		}
		if ( 0 == buf.indexOf( "EOP" ) ) {
		    int x = 0;
		    try { x = Integer.parseInt( buf.substring( 3 ) ); }
		    catch ( Exception e ) { }
//System.out.println( "\npage = " + page + ", x ='" + x  + ", maxline ='" + maxline  + "'" + ", maxfoot='" + maxfoot + "'" + "', maxline + maxfoot ='" + (maxline + maxfoot)  + "'" );
		    if ( maxline + maxfoot > x )
			break;
		    else
			continue;
		}

		    //note( "disp_lines='" + disp_lines + ", buf=" + buf );
		line_len = buf.length();
		if ( 0 == buf.indexOf( "\t" ) || 0 == buf.indexOf( "=" ) ||
		     0 == buf.indexOf( " " ) ) {
		    disp_lines++;   // poem lines and new paragraph always on new line
		    if ( wrap_chars > 0 ) {
			wrap_chars = 0;
			//note( "^^^^^^^^^^^^ buf=" + buf );
			disp_lines++;	// need another line for prev wrap chars
		    }
		    wrap_chars = line_len - wrap_width;
		} else {
		    wrap_chars += line_len;
		    /*
		    if ( wrap_chars <= wrap_width ) {
			wrap_chars = 0;
		    } else {
			*/
		    int ww = ( wrap_width - ( infoot ? 6 : 0 ) );
			while ( wrap_chars > ww ) {
			    disp_lines++;
			    //note( "disp_lines='" + disp_lines + "' wrap_chars='" + wrap_chars + "'" );
			    wrap_chars -= ww;
			}
		    //}
		}
		if ( wrap_chars < 0 ) wrap_chars = 0;

		if ( 0 == buf.indexOf( ",,," ) ) {
		    boolean isChapter  = ( 3 == buf.indexOf( 'C' ) );
		    int sp = buf.indexOf( ' ' );
		    String chap_title = "";
		    if ( -1 != sp )
			chap_title = buf.substring( sp );
		    String xx = "";
		    inChandler = ( buf.startsWith( ",,,m" ) || buf.startsWith( ",,,m" ) );
		    if ( inChandler ) {
			hadChandler = true;
			if ( pagesSinceChandler > 10 ) 
			    if ( ! saidSinceChandler ) {
				note( "pagesSinceChandler=" + pagesSinceChandler );
				saidSinceChandler = true;
			    }
			xx = beginChandler;
			justEndedChandler = true;
		    }
		    if ( isChapter ) {
			chapter++;
			if ( ! set_chapter ) {
			    set_chapter = true;
			    prev_chapter = chapter - 1;
			}
			next_chapter = chapter;
			int chap_page = page;
			//String chap = "</div></div><br><br><br><br><table width=100%><tr><td align=center><span class=chapter>&nbsp;&nbsp;&nbsp;" + (chapter) + "&nbsp;...</span></td></tr></table><br><br>" + xx + "<div align=justify>";
			String chap = "</div></div><br><br><br><br><table width=100%><tr><td align=center><span class=chapter>&nbsp;&nbsp;&nbsp;(" + (chapter) + ")&nbsp;" + chap_title + "&nbsp;...</span></td></tr></table><br><br>" + xx + "<div align=justify class=\"mypage\">";
			//if ( maxline+maxfoot+lines_for_chap_head > pagelen ) {
			if ( disp_lines + lines_for_chap_head > pagelen ) {
			    page_starts_with_chap = chap;
			    //disp_lines += lines_for_chap_head;
			    pagelen -= lines_for_chap_head;
			    chap_page++;
			    next_chapter--;
			    // handle case where ,,,m style would bleed into
			    // footnote if followed by ,,,C that got bumped
			    // to next page
			    line[maxline++] = "</Div></div>";
			} else {
			    line[maxline++] = chap;
			    //disp_lines += lines_for_chap_head;
			    pagelen -= lines_for_chap_head;
			}
			chap_js.write( "chap_page[" + chapter + "] = " + chap_page + "\n" );
				//+ (chap_page%2==0 ? chap_page : chap_page-1) + "\n" );
		    } else {
			//disp_lines += lines_for_elipsis;
			pagelen -= lines_for_elipsis;
			//line[maxline++] = "</div></div><table width=100%><tr><td align=center><span class=heavy2>...</span></td></tr></table>" + xx + "<div align=justify class=\"mypage\">";
			line[maxline++] = "</div></div><br><table width=100%><tr><td align=center><span class=heavy>" +
			    chap_title +
			    "...</span></td></tr></table>" + "<div align=justify class=\"mypage\">" + xx;
		    }
		    continue;
		}
		if ( 0 == buf.trim().length() ) {
		    if ( infoot ) 
			foot[maxfoot++] = "<BR/>";
		    else
			if ( maxline > 0 )
			    line[maxline++] = "<BR>";
		    continue;
		//} else if ( '.' == buf.charAt( 0 ) ) {
		} else if ( buf.startsWith( "." ) ) {
		    this_footlead = null;
		    infoot = false;
		    continue;
		//} else if ( -1 != "*".indexOf( buf.charAt( 0 ) ) ) {
		} else if ( buf.startsWith( "*" ) ) {
// encouraging subsequent footnotes to push to next page
// doesn't help much, still get overlong pages.
// The problem is with footnotes that 
//pagelen -= 1; 
		    infoot = true;
		    startedfoot = true;
		    this_footlead =
		    foot[maxfoot] = "<tr><td nowrap align=right valign=toP>" + stylize( buf ) + "&nbsp;&nbsp;</td><td align=justify>" + a_tag;
		    // stylize has a chunk of code that handles footnote
		    // starter lines, e.g. "*1".
		    // This somewhat buried chunk of code should probably 
		    // be moved into a separate function, since none of 
		    // the other stylize operations apply to it.
		    // The code is in stylize because at one time I wanted to
		    // allow very short footnotes to be written as a single 
		    // line, e.g.  "*1  And so it goes."
		    // But now all footnotes must begin with "*1" and end with
		    // a line containing just "."
		} else if ( infoot ) {
		    //doingfoot = true;
		    if ( startedfoot ) {
			foot[maxfoot++] += stylize( buf );
			startedfoot = false;
		    } else {
			foot[maxfoot++] = stylize( buf );
		    }
		    if ( -1 != lastfound.indexOf( "<span" ) )
			thisFootMarkup = lastfound;
	        } else {
		    //doingfoot = false;
		    String s = 
		    line[maxline++] = stylize( buf );

		    int start = s.lastIndexOf( "<span" );
		    int end   = s.lastIndexOf( "</span" );
		    if ( -1 != start || -1 != end ) {
			instyle = ( start > end );
			if ( instyle ) {
			    markat = start;
			    markedline = s;
			    s = s.substring( start );
			    thisTextMarkup = s.substring( 0, s.indexOf( ">" ) + 1 );

			} else
			    thisTextMarkup = null;
		    }
		}
	    }
	    // Continuing a footnote in Chandler mode
	    // is handled by next_page_cont_foot_markup.
	    // (To make this work, had to require BC and EC to begin line.)
	    //
	    // Continuing main text in Chandler mode
	    // is handled by other shit.  Holy Christ.
	    if ( infoot && inChandler ) inChandler = false; 
	} catch ( Exception e ) {
	    System.out.println( "\n\nERROR: maxline='" + maxline + 
				"'\n       page='" + page + "'" +
				"'\n       linesIn='" + linesIn + "'" );
	    e.printStackTrace();
	}
//line[maxline-1] = "maxline ='" + maxline  + "'" + ", maxfoot='" + maxfoot + "'" + "', maxline + maxfoot ='" + (maxline + maxfoot)  + "'" ;

//if (119<page && page<124)
//System.out.println( "inChandler ='" + inChandler  + "'" + page + ".");
	debug_page( page, "start line: " + start_line + ", end line: " + linesIn + ", lines: " + ( linesIn - start_line ) );
	return ret;
    }

    public static String filename( int pagenum ) {
	return "out/page_" + pagenum + "_" + ( pagenum + 1 ) + ".html";
    }
    public static String filename1( int pagenum ) {
	return "out/page_" + pagenum + ".html";
    }

    public static boolean in_remark = false;

    public static String stylize( String line ) {
	if ( inChandler ) {
	    String[] tooModern = { "Money", "Syd", "Heaven", "Aia", "Ninth", "Ludwig" };
	    for ( int i = 0; i < tooModern.length; i++ ) {
		if ( -1 != line.indexOf( tooModern[i] ) )
		    System.out.println( "WARNING: in Chandler, found '" +
			tooModern[i] + "', page=" + page + ", linesIn=" + linesIn );
	    }
	}
	linenum++;
	String ret = "";

	String s = line;
	
	if ( 0 == s.indexOf( "!" ) ) {
	    s = s.substring(1);
	    if ( ! in_remark ) s = "<br>" + s;
	    s = "<span class=author_remark>" + s + "</span><br>";
	    in_remark = true;
	    return s;
	}
	in_remark = false;

	if ( 0 == s.indexOf( "-" ) )
	    s = "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" + s.substring( 1 );

	s = stringReplace( s, "--", "&mdash;" );

	//boolean prevLineEndedChandler = justEndedChandler;
	//int ec = s.indexOf( "EC" );
	//justEndedChandler = ( ec == s.length() - 2 );
	//int ec = s.indexOf( "C" );
	//justEndedChandler = ( ec == s.length() - 1 );
	if ( justEndedChandler ) {
	    //System.out.println( "s='" + s + "'" );
	}
	// !! Is there any real advantage to allowing BC/EC codes mid-line?
	// It makes it harder to keep the inChandler flag correct.  
	/*
	s = stringReplace( s, "BC ", beginChandler );
	s = stringReplace( s, "BC", beginChandler );
	s = stringReplace( s, "EC", endChandler );
	s = stringReplace( s, " EC", endChandler );
	s = stringReplace( s, " EC ", endChandler );
	*/

	// Get the visual two spaces between a period and the next sentence.
	// There are a lot of cases here, I just did the most common.
	s += " ";
	// We add the nbsp and then an ordinary space.
	// If the ordinary space is first and then the nbsp,
	// the browser can sometimes wrap the nbsp to the next line,
	// creating an undesirable blank line.
	//
	// Welcome to side-effect city.
	// Below, I further massage the line, replacing sentenceSep stuff
	// to add fancy rquotes.  Then, later, I massage that, ripping 
	// the rquotes out (since we're in color).
	// So, beware: changes have ripple effects.
	String noExtraSpace = "noExtraSpace";
	s = stringReplace( s, ".... ", "++++" );
	s = stringReplace( s, "... ", "..." + noExtraSpace );
	s = stringReplace( s, "Mr. ", "Mr." + noExtraSpace );
	s = stringReplace( s, "Ms. ", "Ms." + noExtraSpace );
	s = stringReplace( s, "Mrs. ", "Mrs." + noExtraSpace );
	s = stringReplace( s, "++++", "...." );
	String sentenceSep = "&nbsp; ";
	/*
	s = stringReplace( s, ". ", "." + sentenceSep );
	s = stringReplace( s, ".` ", ".`" + sentenceSep );
	s = stringReplace( s, ".\" ", ".\"" + sentenceSep );
	//s = stringReplace( s, ".\"} ", ".\"} &nbsp;" );
	s = stringReplace( s, ".\"} ", ".\"}" + sentenceSep );
	s = stringReplace( s, ".\") ", ".\")" + sentenceSep );
	if ( s.length() - 1 == s.lastIndexOf( "." ) )
	    s += "&nbsp;";
	s = stringReplace( s, "? ", "?" + sentenceSep );
	s = stringReplace( s, "?` ", "?`" + sentenceSep );
	s = stringReplace( s, "?\" ", "?\"" + sentenceSep );
	s = stringReplace( s, "?\"} ", "?\"}" + sentenceSep );
	s = stringReplace( s, "?\") ", "?\")" + sentenceSep );
	if ( s.length() - 1 == s.lastIndexOf( "?" ) )
	    s += "&nbsp;";
	*/
	String[] sentEnd = { ".", "?", "!" };
	for ( int i = 0; i < sentEnd.length; i++ ) {
	    String x = sentEnd[i];
	    s = stringReplace( s, x + "  ", x + sentenceSep );
	    s = stringReplace( s, x + "`  ", x + "`" + sentenceSep );
	    s = stringReplace( s, x + "\"  ", x + "\"" + sentenceSep );
	    s = stringReplace( s, x + "\"}  ", x + "\"}" + sentenceSep );
	    s = stringReplace( s, x + "\")  ", x + "\")" + sentenceSep );
	    if ( s.length() - 1 == s.lastIndexOf( x ) )
		s += "&nbsp;";
	}


	s = stringReplace( s, noExtraSpace, " " );

	//s = stringReplace( s, "_>", "</i>" );
	s = stringReplace( s, "__", "</i>" );
	s = stringReplace( s, "_", "<i>" );

	if ( -1 != s.indexOf( "@" ) )
	    pagelen -= 0;
	s = stringReplace( s, "@>", "</span>" );
	s = stringReplace( s, "@2", "<span class=heavy2>" );
	s = stringReplace( s, "@y", "<span class=heavy_yellow>" );
	s = stringReplace( s, "@b", "<span class=heavy_blue>" );
	s = stringReplace( s, "@", "<span class=heavy>" );

	//s = stringReplace( s, "    Flip.", "<table width=100%><tr><td align=center><span class=heavy2>...</span></td></tr></table>" );

	s = stringReplace( s, "((\"", "<span class=p2p_private>&ldquo;" );
	s = stringReplace( s, "(\"", "<span class=p2p>&ldquo;" );
	s = stringReplace( s, "\")", "&rdquo;</span>" );

	//s = stringReplace( s, "-{\"", "<span class=o2p_private>&ldquo;" );
	//s = stringReplace( s, "{{\"", "<span class=p2o>&ldquo;" );
	s = stringReplace( s, "{{\"", "<span class=o2p_private>&ldquo;" );
	s = stringReplace( s, "{\"", "<span class=p2o>&ldquo;" );
	s = stringReplace( s, "\"}", "&rdquo;</span>" );

	//s = stringReplace( s, "	`", "<span class=c2a>`" );
	s = stringReplace( s, "``", " <span class=c2a>&ldquo;" );
	s = stringReplace( s, " `", " <span class=a2c>&ldquo;" );
	s = stringReplace( s, "` ", "&rdquo;</span> " );
	s = stringReplace( s, "`&nbsp;", "&rdquo;</span> " );
	//s = stringReplace( s, "`*", "`</span>*" );
	s = stringReplace( s, "`*", "</span>&rdquo;*" );
	s = stringReplace( s, "\"*", "</span>&rdquo;*" );
	s = stringReplace( s, "`,", "</span>&rdquo;," );


	if ( 0 == s.indexOf( "`" ) )
	    s = "<span class=a2c>&ldquo;" + s.substring( 1 );
	int qi = s.lastIndexOf( "`" );
	if ( s.length() - 1 == qi ) {
	    s = s.substring( 0, s.length() - 1 ) + "&rdquo;</span>";
	} 
/*else if ( qi + 1 == s.length() - 1 == s.lastIndexOf( "`" ) ) {*/

	if ( 0 == s.indexOf( "\"" ) )
	    s = "&ldquo;<span class=aloud>" + s.substring( 1 );
	s = stringReplace( s, " \"", " &ldquo;<span class=aloud>" );

	// this handles aftermath of sentenceSep stuff, above
	// (why was I replacing the nbsp with a just plain space?)
	//s = stringReplace( s, "\"&nbsp;", "</span>&rdquo; " );
	s = stringReplace( s, "\"&nbsp;", "</span>&rdquo;&nbsp; " );

	// this handles cases not covered by sentenceSep, like ",\" "
	s = stringReplace( s, "\" ", "</span>&rdquo; " );
	if ( s.length() - 1 == s.lastIndexOf( "\"" ) )
	    s = s.substring( 0, s.length() - 1 ) + "</span>&rdquo;";

	// remember markup if footnote wraps to next page
	if ( infoot ) {
	    int last_open_span = s.lastIndexOf( "<span" );
	    int last_close_span = s.lastIndexOf( "</span" );
	    if ( last_close_span > last_open_span ) {
		next_page_cont_foot_markup = "";
	    } else if ( last_open_span > last_close_span ) {
		String span = s.substring( last_open_span );
		int end_span = span.indexOf( ">" );
		next_page_cont_foot_markup = span.substring( 0, end_span + 1 );
	    }
	}


if(true){
	String t = s;
	String s2 = "";
	String fn = "";
	int i = 0;
	int f = 0;
	while ( -1 != ( i = t.indexOf( "*" ) ) ) {
	    if ( i + 1 >= t.length() ) break;
	    //fn = t.substring( i + 1, i + 2 );
	    if ( true ) {
		String preceding_page = "";
		String foot_id = "";
		//String a_tag = "";
		String foot_css = "footnote_num";
		//if ( infoot )	foot_css += "2";
		//if ( infoot && 0 == i )	
		if ( 0 == i )	{
		    //f = ++foot_footnum;
		    String xx = t.substring( i + 1, i + 2 );
		    //System.out.println( "xx ='" + xx  + "'" );
		    String fs = (String) footnum_map.get( xx );
		    f = Integer.parseInt( fs );
		    //System.out.println( "f ='" + f  + "'" );
		    debug_page( page, "f=" + f + ", s=" + s + ", linesIn=" + linesIn + ", s=" + s );
		    if ( ! seenfoot ) {
			preceding_page = ". . . ";
			//note( "footnote " + f + " referring to preceding page");
		    }
		    a_tag = "<a onmouseover=\"flashfoot(" + f + ");return false;\" onmouseout=\"unflashfoot(" + f + ");return false;\">";
		    //a_tag = "<a onmouseover=\"flashfoot(" + f + ");return false;\">";
		} else {
		    if ( infoot ) footnote_in_footnote = true;
    		    f = ++body_footnum;
		    String yy = t.substring( i + 1, i + 2 );
		    //System.out.println( "yy ='" + yy  + "'" );
		    //System.out.println( "f ='" + f  + "'" );
		    footnum_map.put( yy, "" + f );
		    foot_id = " id=\"foot" + f + "\" ";
		    seenfoot = true;
		}
		s2 += t.substring( 0, i ) 
		    + ( infoot && i == 0 ? a_tag : "" )
		    //+ "</a><Sup " + foot_id + "class=\"" + foot_css + "\">" 
		    + "<Sup " + foot_id + "class=\"" + foot_css + "\">" 
		    // for what did I need the </span>?
		    //+ "</span><Sup class=\"footnote_num\">" 
		    //
		    //+ "<sup style=\"background-color: #ffffbb; color:#009999;\">" 
		    + preceding_page 
		    + ( i == 0 && footnote_in_footnote ? "(" : "" ) 
		    + f 
		    + ( infoot ? ( i == 0 && footnote_in_footnote ? ")" : "&nbsp;" ) : "" )
		    + "</sup>"
		    + ( infoot && i == 0 ? "</a>" : "" )
		    ;
	    /*
	    } else {
	    if ( -1 != "123".indexOf( fn ) ) {
		s2 += t.substring( 0, i ) 
		    + "</span><span class=\"footnote_num\">" 
		    + "&sup" + fn + ";</span>";
	    } else {
		// 060520 This never happens!  
		s2 += t.substring( 0, i ) 
		    + "</span><sUp class=\"footnote_num\">" 
		    + fn + "</sup>";
	    }
	    */
	    }
	    t = t.substring( i + 2 );
	}
	s2 += t;
	s = s2;
}

	s = stringReplace( s, "\"<span>", "</span>\"<span>" );
	s = stringReplace( s, "\"&sup", "</span>\"&sup" );
	s = stringReplace( s, "\"<sup>", "</span>\"<sup>" );

	// give a nice apostrophe instead of the vertical tick
	s = stringReplace( s, "'", "&rsquo;" );

	// strip all double-quotes since dialog is colorized?
	s = stringReplace( s, "&ldquo;", "" );
	/*
	s = stringReplace( s, "&ldquo;", "&mdash;" );
	int j = s.indexOf( "&mdash;" );
	if ( j != -1 ) 
	    s = s.substring( 0, j + 7 ) + stringReplace( s, "&mdash;", "" );
	    */
	s = stringReplace( s, "&rdquo;", "" );

	// put desired quotes in place
	s = stringReplace( s, "%\"", "&ldquo;" );
	s = stringReplace( s, "\"%", "&rdquo;" );

	tabbed = false;
	if ( 0 == s.indexOf( "	" ) ) tabbed = true;
	if ( 0 == s.indexOf( "=	" ) ) tabbed = true;
	if ( tabbed /* && ! doingfoot */ ) {
	    if ( true || infoot ) {
//if ( page == 4 ) System.out.println( "ml=" + maxline + ", pl=" + pagelen );
		//if ( true && maxfoot + maxline >= pagelen ) {
		if ( disp_lines >= pagelen ) {
		    if ( ! saidExtend ) {
			note( "extending page for poem, s=" + s );
			saidExtend = true;
		    }
		    pagelen++;
		}
		if ( 0 == s.indexOf( "=" ) ) 
		    s = "<span class=c2a>" + s.substring( 1 ) + "</span>";

		s = "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>" + s + "</i>";
	    }
	} else if ( 0 == s.indexOf( "   " ) )
	    // if this is the first line in the footer (startedfoot==true)
	    // or this is the first line in the page (maxline<2)
	    // then do not add a line break to the beginning of the line
	    if ( startedfoot || ( ! infoot && maxline < 2 ) ) 
	    //if ( ! infoot && maxline < 2 ) 
		//ret += "&nbsp;&nbsp;&nbsp;&nbsp;";
		ret += "<img src=\"../config/images/clear.gif\" height=1px width=20px>";
	    else
		if ( prevLineEndedChandler )
		    //ret += "<Br>&nbsp;&nbsp;&nbsp;&nbsp;";
		    ret += "<img src=\"../config/images/clear.gif\" height=1px width=20px>";
		else {
		    String br = "<Br>";
		    if ( maxline > 0 && maxline < 3 )
			// the >0 handles pages that are all footnotes,
			// the <3 handles pages that start with beginChandler
			br = "";
		    if ( maxfoot == 1 && null != cont_footlead )
			br = "";
		    ret += br + "<img src=\"../config/images/clear.gif\" height=1px width=21px>";
		}
	else if ( lastwastabbed && ! infoot ) {
	    ret += "<bR>";
	}

	ret += s.trim() + " ";

	lastwastabbed = tabbed;

	//return "" + maxline+"/"+maxfoot+" "+ ret;
	if ( include_authors_remarks ) 
	    ret = "<span class=author_remark>" + linesIn + "</span> " + ret;


//	trackActiveStyles( ret );

	return ret;
	//return disp_lines + "(" + line_len + "+" + wrap_chars + ") " + ret;
    }
// end stylize

	
    
/*
    public static void trackActiveStyles( String s ) {
	int i = 0;
	int j = 0;
	while (  -1 != ( i = s.indexOf( "<", i ) ) ) {
	    if ( -1 == ( j = s.indexOf( ">", i + 1 ) ) ) { 
		// error: no matching > for <
	    }
	    if ( "/" == 
	    styleStack.push( s.substring( i, j );

    }
*/

    public static int page = 0;
    public static boolean do_single_pages = false;
    public static boolean include_authors_remarks = false;
    static void note( String s ) {
	if ( true || search_strings.length == 0 ) 
	    System.out.println( "NOTE: page=" + page + ", linesIn=" + linesIn + ": " + s );
    }

    public static String[] search_strings = { "Ducky" };
    public static boolean search_context = true;
    public static void search_page( int page, String line ) {
	int x;
	String s;
	for ( int i = 0; i < search_strings.length; i++ ) {
	    s = search_strings[i];
	    if ( -1 != ( x = line.indexOf( s ) ) )
		if ( search_context )
		    System.out.println( "FOUND page=" + page + ", linesIn=" + linesIn + ": " + line.substring( 0, x ) + " >>> " + s + " <<< " + line.substring( x + s.length() ) );
		else
		    System.out.println( "FOUND page=" + page + ", linesIn=" + linesIn + ": " + s );
	}
    }

    public static String debug_pages = "";
    public static void debug_page( int page, String msg ) {
	if ( -1 != debug_pages.indexOf( ":" + page + ":" ) )
	    System.out.println( "DEBUG: page: " + page + ", " + msg );
    }

    public static void main( String[] argv ) {
    	/*
    	String p = null;
    	p = "user.dir";
    	p = "base_dir";
    	debug( "System.getProperty("+p+")='" + System.getProperty(p) + "'" );
    	System.setProperty(p, "C:\\Documents and Settings\\jay\\workspace\\Typesetter\\xxx");
    	debug( "System.getProperty("+p+")='" + System.getProperty(p) + "'" );
    	Properties pp = System.getProperties();
    	 try {
    	pp.storeToXML(System.out, "props");
    	} catch (Exception e) {
    		note( "@#$@#$" );
    	}
    	*/

	Vector<String> search_strs = new Vector<String>();
	for ( int i = 0; i < argv.length; i++ ) {
	    if ( "usage".equals( argv[i] ) ) {
		usage();
	    } else if ( argv[i].startsWith( "base_dir=" ) ) {
	    	base_dir_name = argv[i].substring( "basedir=".length() + 1 );
	    } else if ( "1".equals( argv[i] ) ) {
		do_single_pages = true;
		System.out.println( "generating both double and single page formats");
	    } else if ( "a".equals( argv[i] ) ) {
		include_authors_remarks = true;
		System.out.println( "including author's remarks");
	    } else if ( -1 != "123456789".indexOf( argv[i].charAt( 0 ) ) ) {
		debug_pages += ":" + argv[i];
	    } else if ( "l".equals( argv[i] ) ) {
		search_context = false;
	    } else {
		search_strs.add( stringReplace( argv[i], "_", " " ) );
	    }
	}
	debug_pages += ":";
	if ( 0 != search_strs.size() ) {
	    search_strings = new String[ search_strs.size() ];
	    search_strs.copyInto( search_strings );
	}

	try {
		base_dir = new File( base_dir_name );
		
	    head1 = arrayFromFile( "typesetting_templates/head1" );
	    tail1 = arrayFromFile( "typesetting_templates/tail1" );

	    clio = arrayFromFile( "clio.jay" );
	    //c =  new BufferedReader( new FileReader( new File( base_dir, "clio.jay" ) ) );

	    int lines = 0;
	    String prevname = null;
	    String fname = null;
	    String fname1 = null;

	    chap_js = new BufferedWriter( new FileWriter( new File( base_dir, "out/chapter_pages.js" ) ) );
	    chap_js.write( "var chap_page = new Array(100);\n" );
	    chap_js.write( "chap_page[0] = 0\n" );

	    for ( page = 0; page < 500; page += 1 ) {
		fname = filename( page );
		fout = new BufferedWriter( new FileWriter( new File( base_dir, fname ) ) );
		if ( do_single_pages ) {
		    fname1 = filename1( page );
		    fout1 = new BufferedWriter( new FileWriter( new File( base_dir, fname1 ) ) );
		}

		out( head1 );
		out( "<script>" );
		out( "var left_page_num=" + page + ";");

		out1( "var single_page=true;" );
		out2( "var single_page=false;" );

		out( "</script>" );
		//out( "s.setValue(" + page + ");</script></form>" );

		out1( "<table cellpadding=50px cellspacing=0><tr>" );
		out2( "<table cellspacing=0><tr>" );
		td_margin();
		td(50);
		td1();

		set_chapter = false;
		prev_chapter = chapter;
		if ( prev_chapter < 0 ) prev_chapter = 0;
		if ( null != page_starts_with_chap ) {
		    set_chapter = true;
		    prev_chapter--;
		}

		pageload();
		pageout();

		//if ( page > 0 ) out( "<br><br>" + page );

		if ( hadChandler ) pagesSinceChandler = 0;
		else pagesSinceChandler++;
		hadChandler = false;

		out2( "</td><td class=\"mypage\" >&nbsp;</td><td width=\"11px\" style=\"white-space: nowrap; background-repeat: norepeat;\" background=\"../config/images/crease.gif\"><img width=\"10px\" src=\"../config/images/clear.gif\"></td><td class=\"mypage\">&nbsp;</td>" );

		td(50);
		/*
		if ( done ) {
		    fout.flush();
		    fout.close();
		    break;
		}
		*/

		if ( null == page_starts_with_chap )
		    next_chapter = chapter + 1;
		else
		    next_chapter = chapter;

		out1( tail1 );
		out1( "<script>" );
		out1( "var prev_chapter=" + prev_chapter );
		out1( "var next_chapter=" + next_chapter );
		out1( "</script>" );
		out1( "</body></html>" );
		if ( page > 0 )
		    //out1( "<br><table width=100%><tr><td class=\"page_num\" align=center>- " + page + " -</td></tr></table>" );
		    out1_pagenum( page );

		if ( do_single_pages ) {
		    fout1.flush();
		    fout1.close();
		}

		    fout1 = null;

		int left_pagenum = page;
		int right_pagenum = page + 1;

		if ( !done ) {
		    page += 1;
		    if ( do_single_pages ) {
			fname1 = filename1( page );
			fout1 = new BufferedWriter( new FileWriter( new File( base_dir, fname1 ) ) );
		    }

		    out1( head1 );
		    out1( "<script>" );
		    out1( "var left_page_num=" + page + ";" );
		    out1( "var single_page=true;" );
		    out1( "</script>" );
		    out1( "<table cellpadding=50px cellspacing=0><tr>" );
		    td1();

		    pageload();
		    pageout();
		    td_margin();

		    //out1( "<br><table width=100%><tr><td class=\"page_num\" align=center>- " + page + " -</td></tr></table><br>" );
		    out1_pagenum( page );

		    if ( hadChandler ) pagesSinceChandler = 0;
		    else pagesSinceChandler++;
		    hadChandler = false;
		} else {
		    out( "<td class=\"mypage\"></td>" );
		}

		if ( null == page_starts_with_chap )
		    next_chapter = chapter + 1;
		else
		    next_chapter = chapter;

		//out( "<br><br><table width=\"100%\"><tr>" );
		//td(100,"right");
		//out( "" + page + "</td></tr></table>" );
		
		//out( "</td></tr></table>" );
		out2( "</td></tr>" );

		String left = "";
		if ( page > 1 ) left = "" + left_pagenum;
		out2( "<tr>" );
		td_margin();
		//out2( "<td class=\"page_num\" width=\"50%\" align=left><br>" + left + "</td><td class=\"mypage\">&nbsp;</td><td width=\"11px\" style=\"white-space: nowrap; background-repeat: norepeat;\" background=\"../config/images/crease.gif\"><img width=\"10px\" src=\"../config/images/clear.gif\"></td><td class=\"mypage\">&nbsp;</td><td class=\"page_num\" width=\"50%\" align=right><br>" + right_pagenum + "<br>&nbsp;</td>" );
		out2("<td class=\"page_num\" width=\"50%\" align=left><table valign=middle><tr><td></td><td>" +
		    ( page > 1 ? "<a title=\"" + turn_page_msg + "\" onclick=\"keyhandle(37);return;\"><img src=\"../config/images/left_arrow.gif\" alt=\"" + turn_page_msg + "\"></a>" : "" ) +
		    "</td><td>" + left + "</td></tr></table></td><td class=\"mypage\">&nbsp;</td><td width=\"11px\" style=\"white-space: nowrap; background-repeat: norepeat;\" background=\"../config/images/crease.gif\"><img width=\"10px\" src=\"../config/images/clear.gif\"></td><td class=\"mypage\">&nbsp;</td><td class=\"page_num\" width=\"50%\" align=right><br><table><tr><td>" + right_pagenum + " <td><a title=\"" + turn_page_msg + "\" onclick=\"keyhandle(39);return;\"><img src=\"../config/images/right_arrow.gif\" alt=\"" + turn_page_msg + "\"></a></td></tr></table>&nbsp;</td>" );
		td_margin();
		out( "</tr></table>" );


		out( tail1 );
		out( "<script>" );
		out( "var prev_chapter=" + prev_chapter );
		out( "var next_chapter=" + next_chapter );
		out( "</script>" );
		out( "</body></html>" );

		fout.flush();
		fout.close();

		if ( null != fout1 ) {
		    fout1.flush();
		    fout1.close();
		}

		if ( done ) {
		    break;
		}
	    }

	    //c.close();

	    fout = new BufferedWriter( new FileWriter( new File( base_dir, "out/numpages.js" ) ) );
	    fout.write( "var numpages = " + page + '\n' );
	    fout.flush();
	    fout.close();

	    fout = new BufferedWriter( new FileWriter( new File( base_dir, "out/index.html" ) ) );
	    fout.write( "<html><body onload=\"document.location='page_0_1.html';\">Loading...</body></html>\n" );
	    fout.flush();
	    fout.close();

	    chap_js.write( "chap_page["+(++chapter)+"] = -1\n" );
	    chap_js.flush();
	    chap_js.close();
	    
	} catch ( Exception e ) {
	    System.out.println( "page='" + page + "'" );
	    e.printStackTrace();
	}
    }
}




