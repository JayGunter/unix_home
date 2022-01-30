echo sup/setExamplesEnv.ksh...

export BEA_HOME=C:/bea61

export WL_HOME=$BEA_HOME/wlserver6.1

export JAVA_HOME=$BEA_HOME/jdk131

[ ! -f $JAVA_HOME/jre/bin/java.exe ] && {
	echo The JDK was not found in directory $JAVA_HOME.
}

[ ! -d $WL_HOME/lib ] && {
	echo The WebLogic Server was not found in directory $WL_HOME.
}

export APPLICATIONS=$WL_HOME/config/examples/applications
export CLIENT_CLASSES=$WL_HOME/config/examples/clientclasses
export SERVER_CLASSES=$WL_HOME/config/examples/serverclasses
export EX_WEBAPP_CLASSES=$WL_HOME/config/examples/applications/examplesWebApp/WEB-INF/classes

export CLASSPATH=$JAVA_HOME/lib/tools.jar
export CLASSPATH="$CLASSPATH;"$WL_HOME/lib/weblogic_sp.jar
export CLASSPATH="$CLASSPATH;"$WL_HOME/lib/weblogic.jar
export CLASSPATH="$CLASSPATH;"$WL_HOME/lib/xmlx.jar
export CLASSPATH="$CLASSPATH;"$WL_HOME/samples/eval/cloudscape/lib/cloudscape.jar
export CLASSPATH="$CLASSPATH;"$WL_HOME/samples/eval/cloudscape/lib/tools.jar
export CLASSPATH="$CLASSPATH;"$CLIENT_CLASSES
export CLASSPATH="$CLASSPATH;"$SERVER_CLASSES
export CLASSPATH="$CLASSPATH;"$EX_WEBAPP_CLASSES
export CLASSPATH="$CLASSPATH;"$BEA_HOME

#export CLASSPATH=$JAVA_HOME/lib/tools.jar:$WL_HOME/lib/weblogic_sp.jar:$WL_HOME/lib/weblogic.jar:$WL_HOME/lib/xmlx.jar:$WL_HOME/samples/eval/cloudscape/lib/cloudscape.jar:$CLIENT_CLASSES:$SERVER_CLASSES:$EX_WEBAPP_CLASSES:$BEA_HOME

#append_path $WL_HOME/bin
#append_path $JAVA_HOME/bin
#append_path C:/mks/mksnt
#export PATH="$PATH;$WL_HOME/bin;$JAVA_HOME/bin;/mks/mksnt"
