#!/bin/bash
clear
Cerebro=0
Pasos=0
Danos=0
game=t
ruta="/home/$USER/zombiedice.sav"
#Creamos la ruta para guardar los archivos
touch $ruta
comprobar=$(cat $ruta | wc -l)
#Vemos si el archivo tiene contenido
if [ $comprobar -eq 4 ]; then
	#Si tiene le preguntamos al jugador si quiere cargar la partida, sino se crea una nueva
	read -p "¿Deseas cargar la partida? " deseo
	if [ $deseo = "si" -o $deseo = "Si" -o $deseo = "SI" -o $deseo = "sI" ]; then
		nombre=$(cat $ruta | head -n1 | tail -n1)
		Cerebro=$(cat $ruta | head -n2 | tail -n1)
		Pasos=$(cat $ruta | head -n3 | tail -n1)
		Danos=$(cat $ruta | head -n4 | tail -n1)
	fi
	if [ $deseo = "No" -o $deseo = "NO" -o $deseo = "no" -o $deseo = "nO" ]; then
		rm $ruta
                echo -e "\e[5m\e[35mEmpezamos partida nueva\e[0m"
                echo ""
                read -p "Dime tu nombre de jugador--> " nombre
	fi
else
		rm $ruta
		echo -e "\e[5m\e[35mEmpezamos partida nueva\e[0m"
		echo ""
		read -p "Dime tu nombre de jugador--> " nombre
fi
#Creamos una variable que, si hay más de 13 cerebros, 3 disparos o dice el usuario que no quiere continuar, para el bucle
parar=0
while [ $parar -ne 1 ]; do
		#Hacemos las tiradas de 3 dados
		for reps in $(seq 1 3); do
			#Calculamos las probabilidades de cada dado y de las caras de estos.
			let dado=($RANDOM%10)+1
			let dado2=($RANDOM%6)+1
			if [ $dado -le 5 ]; then
				#Si es menor de 5 es el dado verde
				if [ $dado2 -ge 1 -o $dado2 -le 3 ]; then
					#Si es entre 1 y 3 se consigue un cerebro
					echo -e "\e[32mHas encontrado un cerebro\e[39m"
					let Cerebro=Cerebro+1
				elif [ $dado2 -eq 4 -o $dado2 -eq 5 ]; then
					#Si es entre 4 y 5 la víctima escapa
					echo -e "\e[32mLa víctima ha escapado\e[39m"
					let Pasos=Pasos+1
				elif [ $dado2 -eq 6 ]; then
					#Si es 6 se apunta un disparo
					echo -e "\e[32mTe han disparado\e[39m"
					let Danos=Danos+1
				fi
			elif [ $dado -ge 9 ]; then
				#Si es mayor o igual que 9 es el rojo
				if [ $dado2 -eq 1 ]; then
					#Si es 1 se consigue un cerebro
					echo -e "\e[31mHas encontrado un Cerebro\e[39m"
					let Cerebro=Cerebro+1
				elif [ $dado2 -eq 2 -o $dado2 -eq 3 ]; then
					#Si es entre 2 y 3 la víctima escapa
					echo -e "\e[31mLa víctima ha escapado\e[39m"
					let Pasos=Pasos+1
				elif [ $dado2 -ge 4 -o $dado2 -le 6 ]; then
					#Si es entre 4 y 6 se apunta un disparo
					echo -e "\e[31mTe han disparado\e[39m"
					let Danos=Danos+1
				fi
			elif [ $dado -ge 6 -o $dado -le 8 ]; then
				#Si está entre el 6 y 8 es el amarillo
				if [ $dado2 -eq 1 -o $dado2 -eq 2 ]; then
					#Si es entre 1 y 2 se consigue un cerebro
					echo -e "\e[93mHas encontrado un cerebro\e[0m"
					let Cerebro=Cerebro+1
				elif [ $dado2 -eq 3 -o $dado2 -eq 4 ]; then
					#Si es entre 3 y 4 la víctima escapa
					echo -e "\e[93mLa víctima ha escapado\e[0m"
					let Pasos=Pasos+1
				elif [ $dado2 -eq 5 -o $dado2 -eq 6 ]; then
					#Si es entre 5 y 6 se apunta un disparo
					echo -e "\e[93mTe han disparado\e[0m"
					let Danos=Danos+1
				fi
			fi
		done
		read -p "¿Quieres seguir jugando [Si/No]? " game
		#Si no quiere seguir continuando para el bucle, guarda los avances y muestra los puntos obtenidos hasta ahora
	if [ $Danos -ge 3 ]; then
		parar=1
	fi
	if [ $Cerebro -ge 13 ]; then
		parar=1
	fi
	if [ $game = "No" -o $game = "NO" -o $game = "no" -o $game = "nO" ]; then
		parar=1
	fi
	#Volcamos los puntos obtenidos al fichero
	echo "$nombre">$ruta
	echo "$Cerebro">>$ruta
	echo "$Pasos">>$ruta
	echo "$Danos">>$ruta
	#Si es mayor de 3 los disparos y mayor de 13 los cerebros se borra el fichero para crear una partida nueva
	if [ $Danos -ge 3 -o $Cerebro -ge 13 ]; then
		rm $ruta
	fi
done
#Cuando salga del bucle se le muestra el menú
clear
echo "##########################################"
echo "Jugador --> $nombre Tus puntos han sido:  "
echo "##########################################"
echo "Te has comido a --> $Cerebro humanos      "
echo "##########################################"
echo "Se te han espado--> $Pasos humanos        "
echo "##########################################"
echo "Te han disparado $Danos veces             "
echo "##########################################"

exit 0
