#!/bin/bash -il
#export LANG=zh_CN.gbk
if [ $# == 3 ];then
echo "�������Ϊ:"
echo "��������û���==>>>>>$1"
echo "tomcat��Ŀ¼��==>>>>>$2"
echo "��������========>>>>>$3"
#if [! -d "/home/$1/temp/$3" ];then
#	mkdir -p /home/$1/temp/$3
#fi
#cp /home/tomcat/$3/$3.war /home/$1/temp/$3/$3.war
#if [! -f "/home/$1/temp/$3/$3.war" ];then
#	echo "war������ʧ�ܣ���ִֹ�нű�>>>>>>>>>>>>"
#exit 1
#fi
echo "========���war���Ƿ��ϴ��ɹ�"
if [ ! -f "/home/$1/temp/$3/$3.war" ];then
	echo "war ���ϴ���Ŀ�������ʧ�ܣ�����war��·��Ϊ��" /home/$1/temp/$3/$3.war
exit 1
fi
echo "war ���ϴ��ɹ����ļ�·�� " /home/$1/temp/$3/$3.war
echo "======��ʼֹͣtomcat����======"
killStr=`ps -fu $1 | grep $1\/$2\/conf | grep -v grep | awk '{print $2}'`
echo "killStr=====>" ${killStr}
kill -9 ${killStr}
echo "======ֹͣtomcat�������======"

echo "======ɾ���ɵĹ���====="
cd /home/$1/$2/webapps
BACKFILENAME=$3`date +%Y%m%d`.war.bak.tar
echo "�����ļ�����====>>>>" $BACKFILENAME
echo "�����ļ�·��====>>>>" /home/$1/back/$BACKFILENAME
tar czvf $BACKFILENAME $3
if [ ! -d "/home/$1/back" ]; then
	mkdir /home/$1/back
fi
cp $BACKFILENAME /home/$1/back/$BACKFILENAME
rm -rf $3*
echo "======ɾ���ɹ������======"

echo "======�����¹���======"
cp /home/$1/temp/$3/$3.war /home/$1/$2/webapps/$3.war
echo "����ļ��Ƿ��Ƴɹ�>>>>" 
if [ -f "/home/$1/$2/webapps/$3.war" ]; then
	echo "war�����Ƴɹ�"
	#�滻�ļ����ݵĽű���������Ҫ������
	#unzip -o /home/$1/$2/webapps/$3.war -d /home/$1/$2/webapps/$3
	#sed -i "s/host=\"192.168.8.46\"/host=\"fus103\"/g" /home/$1/$2/webapps/$3/WEB-INF/classes/dubbo-provide.xml
else
	echo "war������ʧ��<<<<<"
	exit 1
fi	
rm  /home/$1/temp/$3/$3.war
echo "======�����¹������======"

echo "======��ʼ����tomcat======"
cd /home/$1/$2/bin
./startup.sh

sleep 10
pid=`ps -fu $1 | grep $1\/$2\/conf | grep -v grep | awk '{print $2}'`
echo "pid>>>>>>>>>>>>>>>>>" ${pid}
if [ -n "$pid" ];then
    echo "======����tomcat���,pid>>>>>>>>>>" $pid
else
    echo "======����tomcatʧ��!!!!!!!======="
  exit 1
fi

exit 0
else
echo "error!!!"
exit 1
fi
#������ߵĲ���ʽ��������ʱԼ����������1- �û���   2-tomcat��Ŀ¼��  3-��������

