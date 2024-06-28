clear
rm -f aout
bison -d syntax.y
flex lexical.l
gcc -o aout syntax.tab.c lexical.c -lfl -lm
./aout input.txt
