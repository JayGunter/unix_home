#!/bin/bash

out=${1%.txt}.html

cat > $out << END
<html>
<body style="margin: 30px; margin-top: 30px;">
END

sed < $1 >> $out ' 
# title
  s@\#\#\# \(.*\)$@<h3>\1</h3>@; 
# paragraph
  s@^  @<br/>\&emsp;@;
# italicize stuff between asterisks
  s@\*\([^*]*\)\*@<i>\1</i>@g; s@^$@<p/>@;
# n-dash after mid-line sentence ending
  s@\(["?.]\)  @\1\&ensp;@g;
# n-dash after end-line sentence ending with trailing spaces
  s@\(["?.]\) *$@\1@;
# n-dash after end-line sentence ending
  s@\(["?.]\)$@\1\&ensp;@g;  
# n-dash after sentence ending in close-paren
  s@\.)@.)\&ensp;@g;
# remove // comments in text
  /^\/\//d;
# long hyphen
  s@--@\&mdash;@g;
  '

cat >> $out << END
</body>
</html>
END
