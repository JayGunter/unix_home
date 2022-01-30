tr -d '\015' | awk ' { a[$0]++ } END { for (x in a) { printf("%4d: %s\n", a[x], x) } }' | sort
