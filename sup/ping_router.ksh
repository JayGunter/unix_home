while [ 1 ]; do
    ping 192.168.1.1 | grep ^R | grep -v '=.ms' > /tmp/ping_router.out
    [ $? = 0 ] && echo `date` `cat  /tmp/ping_router.out`
done
