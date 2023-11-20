FROM intersystemsdc/iris-community

#COPY /iris/script.txt /irisapp/script.txt
#COPY /iris/initdb.sh /irisapp/initdb.sh

SHELL["/irisrun/repo/initdb.sh"]