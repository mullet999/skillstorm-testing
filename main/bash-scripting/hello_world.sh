#! usr/bin/bash


#add a new line
echo ""
echo "Hello World"


#add a new line
echo ""
echo "greeting with variables"
greetings=Hello
name=Tux
echo $greetings $name


#add a new line
echo ""
echo "Adding numbers"
var=$((3+9))
echo $var


#add a new line
echo ""
echo "Adding two numbers using user input"
read -p "Enter a numner for a: " a
read -p "Enter a numner for b: " b
var=$((a+b))
echo $var


#add a new line
echo ""
echo "Compairing two numbers using user input"
read -p "Enter a numner for x: " x
read -p "Enter a numner for y: " y
if [ $x -gt $y ]
then
echo X is greater than Y
elif [ $x -lt $y ]
then
echo X is less than Y
elif [ $x -eq $y ]
then
echo X is equal to Y
fi


#add a new line
echo ""
echo "Triangle type using user input"
read -p "Enter a numner for side a: " a
read -p "Enter a numner for side b: " b
read -p "Enter a numner for side c: " c
if [ $a == $b -a $b == $c -a $a == $c ]
then
echo EQUILATERAL
elif [ $a == $b -o $b == $c -o $a == $c ]
then 
echo ISOSCELES
else
echo SCALENE
fi


#add a new line
echo ""
echo "Using for loop with numbers"
for i in {1..5}
do
    echo $i
done


#add a new line
echo ""
echo "Using for loop with strings"
for X in cyan magenta yellow  
do
	echo $X
done


#add a new line
echo ""
echo "Using while loop"
i=1
while [[ $i -le 10 ]] ; do
   echo "$i"
  (( i += 1 ))
done


#add a new line
echo ""
echo "Using while loop with file"
LINE=1
while read -r CURRENT_LINE
	do
		echo "$LINE: $CURRENT_LINE"
    ((LINE++))
done < "sample_file.txt"


#add a new line
echo ""
echo "Using a command inside a variable using backticks"
var=`df -h | grep tmpfs`
echo $var


#add a new line
echo ""
echo "Using for loop with arguments"
for x in $@
do
    echo "Entered arg is $x"
done


echo ""
echo "Using cron jobs"
echo ""
echo "Cron job example"
echo "* * * * * sh /path/to/script.sh"
echo ""
echo "Here, * represent represents minute(s) hour(s) day(s) month(s) weekday(s), respectively."
echo "Below are some examples of scheduling cron jobs."
echo "SCHEDULE	SCHEDULED VALUE"
echo "5 0 * 8 *	At 00:05 in August."
echo "5 4 * * 6	At 04:05 on Sunday."
echo "0 22 * * 1-5	At 22:00 on every day-of-week from Monday through Friday."
echo ""
echo "crontab -l lists the already scheduled scripts for a particular user."


echo ""
echo "Using find command"
find . -type f -name "*.sh"
