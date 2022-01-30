
echo =========================================================================
echo Killing running server...
ps | egrep '(depot910|startWeblogic)' | awk '{print $1}'
kill -9 `ps | egrep '(depot910|startWeblogic)' | awk '{print $1}'`
echo After killing running server...
ps | egrep '(depot910|startWeblogic)' | awk '{print $1}' > C:/_tmp/oam.pids
[ -s C:/_tmp/oam.pids ] && {
    echo Something still running.  Aborting.
    exit
}
#exit

echo =========================================================================
echo Compiling...
cd C:/depot910/dev/src910/wli/jpd9/oam
ant compile_jsp

echo =========================================================================
echo Deploying...
ant deploy

echo =========================================================================
echo Restarting server in background...
echo Just rerun this script to kill-rebuild-restart
# restart server 
# (in background, so just rerun this script to kill-rebuild-restart)
cd C:/depot910/src910_15004jr/bea/weblogic90/test/jpd9DRT
./startWebLogic.cmd &

