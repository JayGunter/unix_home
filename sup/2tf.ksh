cat << END > c:/tmp/2tf.ftp.script
w13a024
mypeZY97
lcd C:/_Jay/jay/sss
cd  /private/backup/story
put clio.jay
lcd C:/_Jay/jay/sss/config
cd  /private/backup/story/config
put novel.css
put page_controls.js
lcd C:/_Jay/jay/sss/config/images
cd  /private/backup/story/config/images
put crease.gif
put clear.gif
lcd C:/_Jay/jay/sss/typesetting_templates
cd  /private/backup/story/typesetting_templates
put head1
put tail1
lcd C:/_Jay/sup
cd  /private/backup/story/sup
put Typeset.java
bye
END
cd /tmp
ftp -s:2tf.ftp.script ftp.trueframe.com
