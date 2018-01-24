#!/bin/bash -il
#export LANG=zh_CN.gbk
if [ $# == 3 ];then
echo "输入参数为:"
echo "输入参数用户名==>>>>>$1"
echo "tomcat的目录名==>>>>>$2"
echo "工程名称========>>>>>$3"
#if [! -d "/home/$1/temp/$3" ];then
#	mkdir -p /home/$1/temp/$3
#fi
#cp /home/tomcat/$3/$3.war /home/$1/temp/$3/$3.war
#if [! -f "/home/$1/temp/$3/$3.war" ];then
#	echo "war包复制失败，终止执行脚本>>>>>>>>>>>>"
#exit 1
#fi
echo "========检查war包是否上传成功"
if [ ! -f "/home/$1/temp/$3/$3.war" ];then
	echo "war 包上传到目标服务器失败，期望war包路径为：" /home/$1/temp/$3/$3.war
exit 1
fi
echo "war 包上传成功，文件路径 " /home/$1/temp/$3/$3.war
echo "======开始停止tomcat进程======"
killStr=`ps -fu $1 | grep $1\/$2\/conf | grep -v grep | awk '{print $2}'`
echo "killStr=====>" ${killStr}
kill -9 ${killStr}
echo "======停止tomcat进程完成======"

echo "======删除旧的工程====="
cd /home/$1/$2/webapps
BACKFILENAME=$3`date +%Y%m%d`.war.bak.tar
echo "备份文件名称====>>>>" $BACKFILENAME
echo "备份文件路径====>>>>" /home/$1/back/$BACKFILENAME
tar czvf $BACKFILENAME $3
if [ ! -d "/home/$1/back" ]; then
	mkdir /home/$1/back
fi
cp $BACKFILENAME /home/$1/back/$BACKFILENAME
rm -rf $3*
echo "======删除旧工程完成======"

echo "======复制新工程======"
cp /home/$1/temp/$3/$3.war /home/$1/$2/webapps/$3.war
echo "检查文件是否复制成功>>>>" 
if [ -f "/home/$1/$2/webapps/$3.war" ]; then
	echo "war包复制成功"
	#替换文件内容的脚本，根据需要来处理
	#unzip -o /home/$1/$2/webapps/$3.war -d /home/$1/$2/webapps/$3
	#sed -i "s/host=\"192.168.8.46\"/host=\"fus103\"/g" /home/$1/$2/webapps/$3/WEB-INF/classes/dubbo-provide.xml
else
	echo "war包复制失败<<<<<"
	exit 1
fi	
rm  /home/$1/temp/$3/$3.war
echo "======复制新工程完成======"

echo "======开始启动tomcat======"
cd /home/$1/$2/bin
./startup.sh

sleep 10
pid=`ps -fu $1 | grep $1\/$2\/conf | grep -v grep | awk '{print $2}'`
echo "pid>>>>>>>>>>>>>>>>>" ${pid}
if [ -n "$pid" ];then
    echo "======启动tomcat完成,pid>>>>>>>>>>" $pid
else
    echo "======启动tomcat失败!!!!!!!======="
  exit 1
fi

exit 0
else
echo "error!!!"
exit 1
fi
#根据这边的部署方式，现在暂时约定三个参数1- 用户名   2-tomcat的目录名  3-工程名称

