#!/bin/sh

deploy=`sudo kubectl get deploy -n lilei2|awk 'NR!=1{print $1}'`
#deploy="train-system"


if [ "$deploy"x == ""x ];then
echo "lilei2下没有deployment和rs"
echo "`date` : Done cleaning in stage env"
echo "------------------------------------------------------------"
else
echo "`date` : Start cleaning RS from namespace:lilei2 "
echo "namespace:lilei2下的deployment名字如下："
echo $deploy |awk -F " " '{for(i=1;i<=NF;i++)print $i}' |while read line 
do
    echo $line
    #echo $line >> rs.txt
    sudo kubectl get rs -n lilei2 |grep ^$line"-"[0-9] |awk '{print $1, $2, $3, $4}' | while read name num1 num2 num3 
    do
	if [ "$num1" == "0" -a "$num2" == "0" -a "$num3" == "0" ];then
	    echo $name,`sudo kubectl  get rs $name  -o yaml  -n lilei2|grep creationTimestamp \
	    |awk 'NR==1'|sed 's/^[ \t]*//g' |cut -d " " -f 2` >> rs.txt
	fi
    done
done

echo "------------------------------------------------------------"
echo $deploy |awk -F " " '{for(i=1;i<=NF;i++)print $i}' |while read line
do
    if [ -f rs.txt ];then
	wordcount=`cat rs.txt|grep ^$line"-"[0-9] |sort -t "," -k2r|awk 'NR>4'|wc -l`
	rsname=`cat rs.txt|grep ^$line"-"[0-9] |sort -t "," -k2r|awk 'NR>4'|cut -d "," -f 1`
	if [ $wordcount -gt 0 ];then
	    echo "删除对应deployment:$line下的多余的rs" 
	    echo "$rsname"
	    sudo kubectl delete rs $rsname -n lilei2
	else
	    echo "deployment:$line下没有多余的rs"
	fi
	echo "------------------------------------------------------------"
    else
	echo "deployment:$line下没有多余的rs"
	echo "------------------------------------------------------------"
    fi
done
if [ -f rs.txt ];then
    rm rs.txt
fi
    echo "`date` : Done cleaning in stage env"
    echo "------------------------------------------------------------"
fi
