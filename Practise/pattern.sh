#!/bin/sh
#input="/appl/ibm/mdm/MDM/BatchProcessor/temp/test.txt"
counter=0
l1="<ComponentType>"
l2="</ComponentType>"
line1=""
line2=""
line3=""
index=0
flag=0
temp=0
error=()
#for i in "${error[@]}";
#do echo $i;
#done
while IFS= read -r line

do
  #echo "$line"
  if [[ ( $line == *$l1* ) && ( $line == *$l2* ) ]]
  then
      line3=$(echo $line | sed '/^$/d')
      #echo $line3
      line1=${line3:15} 
      line2=${line1::-16}
      # echo $line2
      if [[ index -eq 0 ]]
      then
         # echo "1"
         #echo $line2
         error[$index]=$line2
         
         #echo ${error[$index]}
         index=$((index+1))
      elif [[ index -gt 0 ]]
      then
        flag=0
        #echo "2"
        for (( i=0; i<$index; i++ ))
         do
            #echo "3"
            if [[ ${error[$i]}  == $line2 ]]
            then
              flag=1
            fi
         done
        if [[ $flag -eq 0 ]]
        then
           error[$index]=$line2
           #echo ${error[$index]}
           index=$((index+1))
        fi
      fi
      #ounter=$((counter+1))
  fi

done < $1
echo "Errors in given file"
for (( j=0; j<$index; j++ ))
 do
   echo ${error[$j]}
 done

 
temp1=0
count=()
flag_arr=()
flag1=0
record_c=0
line4=""
line5=""
line6=""

 for (( k=0; k<$index; k++ ))
 do
   count[$k]=0
   flag_arr[$k]=0
 done
while IFS1= read -r line
do
  if [[ ( $line == *requestID* ) && ( $flag1 -eq 0 ) ]]
  then
      record_c=$((record_c+1))
      flag1=1
      
  elif [[ ( $line == *$l1* ) && ( $line == *$l2* ) && ( $flag1 -eq 1 ) ]]
  then
      line4=$(echo $line | sed '/^$/d')
      line5=${line4:15}
      line6=${line5::-16}
      #echo $line6
      for (( i=0; i<$index; i++ ))
      do
        if [[ ( ${error[$i]} == $line6 ) && ( ${flag_arr[$i]} -eq 0 ) ]]
        then  
              temp1=${count[$i]}
              temp1=$((temp1+1))
              count[$i]=$temp1
              # echo ${count[$i]}
              flag_arr[$i]=1
        fi
      done
  elif [[ ( $line == *requestID*) && ( $flag1 -eq 1 ) ]]
  then
     flag1=0
     for (( k=0; k<$index; k++ ))
     do
      flag_arr[k]=0
    done

  fi
  
done < $1

echo "Error type and its count"
for (( i=0; i<$index; i++ ))
 do
   echo ${error[$i]} "-->" ${count[$i]} 
   #echo ${count[$i]}
 done

































