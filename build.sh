#!bash

rm index.html

for x in *.txt;
  do echo "<a href=\"/$x\">$x</a></br></br>" >> index.html;
done
