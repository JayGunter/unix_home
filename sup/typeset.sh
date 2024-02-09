#!/bin/bash

out=$1.html

cat > $out << END
<html>
<body style="margin: 30px; margin-top: 30px;">
END

sed < $1 >> $out ' s@\#\#\# \(.*\)$@<h3>\1</h3>@; s@^  @<br/>\&nbsp;\&nbsp;\&nbsp;\&nbsp;@; s@\*\(.*\)\*@<i>\1</i>@g; s@^$@<p/>@; s@\(["?.]\)  @\1\&nbsp;\&nbsp;@g;  s@\(["?.]\)$@\1\&nbsp;\&nbsp;@g;  s@\.)@.)\&nbsp;\&nbsp;@g'

cat >> $out << END
</body>
</html>
END
