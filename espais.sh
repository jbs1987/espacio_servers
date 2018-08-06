#código para que la introducción del password no se visible

STTY_SAVE=`stty -g`
stty -echo 
echo
echo -n "Introduce tu password: "
read pass
stty $STTY_SAVE
echo

rm -r ~/Escritorio/resultado_espacio
mkdir ~/Escritorio/resultado_espacio
chmod 775 ~/Escritorio/resultado_espacio

#función que conecta con el servidor, obtiene el espacio y lo guarda en un csv junto con el nombre del servidor.
espai(){
    sshpass -p $pass ssh -tt jbarbs@$server 'df -h | grep home' > aux.txt
    cat aux.txt | awk {'print $5'} > aux2.txt
    var=$(cat aux2.txt)
    var=`echo $var | sed 's/.$//g'` 
    echo "$server $var" >> servers_$letra.csv 
    rm aux.txt
    rm aux2.txt
}
#bucle para obtener el resultado del espacio ocupado para todos los servidores de la letra correspondiente.
#diferenciamos si el servidor es del 1 al 9 por el 0
#todas las letras del abecedario el bucle acaba en el 122.
for i in $(seq 97 112); 
do 
    clear
    printf "\\$(printf %o $i)\n" > letraux.txt
    letra=$(cat letraux.txt)
    rm letraux.txt
    echo "comienza la letra $letra"
    for i in `seq 1 9`;
        do server="vxhc$letra-0$i"
            espai
        done
    
    for i in `seq 10 40`;
        do server="vxhc"$letra-$i
            espai
        done
    mv servers_$letra.csv ~/Escritorio/resultado_espacio
done
