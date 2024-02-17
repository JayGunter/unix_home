#!/bin/bash

out=$1.html

cat > $out << END
<html>
<body style="margin: 30px; margin-top: 30px;">
END

sed < $1 >> $out ' 
  s@\#\#\# \(.*\)$@<h3>\1</h3>@; 
  s@^  @<br/>\&emsp;@;
  s@\*\(.*\)\*@<i>\1</i>@g; s@^$@<p/>@;
  s@\(["?.]\)  @\1\&ensp;@g;
  s@\(["?.]\) *$@\1@;
  s@\(["?.]\)$@\1\&ensp;@g;  
  s@\.)@.)\&ensp;@g
  '

cat >> $out << END
</body>
</html>
END
