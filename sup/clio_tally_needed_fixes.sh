awk < $sss/clio.jay '
/^!/ { if (xin==0) {
	    xin=1;
	    nfixes++;
    }
}
/^[^!]/ { xin=0; }
END { print nfixes; }'
