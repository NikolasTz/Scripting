#!/bin/bash


for filename
do

sum_x=0
sum_y=0
sum_x2=0
sum_xy=0

length=0

declare  -a x_array
declare  -a y_array

#read file line by line
for line in $(cat $filename)
do

    #echo $line 
    if [ -z "${line}" ]; then # empty line , skip!!!
    	continue
    fi

    length=`expr $length + 1`

    num_X=$(cut -d':' -f1 <<<"$line")
    x_array[length-1]=$num_X

    num_Y=$(cut -d':' -f2 <<<"$line")
    y_array[length-1]=$num_Y


    sum_x=$(bc -l <<< "$sum_x + $num_X")

    sum_y=$(bc -l <<< "$sum_y + $num_Y")

    sum_x2_mul=$(bc -l <<< "${num_X} * ${num_X}")
    sum_x2=$(bc -l <<< "${sum_x2}+${sum_x2_mul}")

    sum_xy_mul=$(bc -l <<< "${num_X} * ${num_Y}")
    sum_xy=$(bc -l <<< "${sum_xy}+${sum_xy_mul}")

done


# cases for length*sum_x2=sum_x*sum_x 
if [ "$(bc <<< "scale=2; $length*$sum_x2")" = "$(bc <<< "scale=2; $sum_x*$sum_x")" ]; then 
    b_1=$(bc -l <<< "scale=2; (-${num_X})/1")
    echo FILE: $filename, a=1 b=$b_1 c=0 err=0
    continue
fi


a=$(bc <<< "scale=2; (($length*$sum_xy)-($sum_x*$sum_y))/(($length*$sum_x2)-($sum_x*$sum_x))") # Here Strings

b=$(bc <<< "scale=2; ($sum_y-($a*$sum_x))/$length")


err=0
for ((j = 0; j <= length-1; j++))
do
   err=$(bc <<< "scale=2; ($err + (${y_array[j]} - ($a*${x_array[j]}+$b) ) * ( ${y_array[j]} - ($a*${x_array[j]}+$b) ))/1")
done


#check the decimal part
#For a
num_i=${a%%.*}
num_d=${a##*.}

if [ "$num_d" -eq 0 ]; then
  a=$num_i
fi

#For b
num_i=${b%%.*}
num_d=${b##*.}

if [ "$num_d" -eq 0 ]; then
  b=$num_i
fi

#For err
num_i=${err%%.*}
num_d=${err##*.}

if [ "$num_d" -eq 0 ]; then
  err=$num_i
fi


echo FILE: $filename, a=$a b=$b c=1 err=$err


unset x_array
unset x_array

done