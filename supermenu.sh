#!/bin/bash
#------------------------------------------------------
# PALETA DE COLORES
#------------------------------------------------------
#setaf para color de letras/setab: color de fondo
	red=`tput setaf 1`;
	green=`tput setaf 2`;
	blue=`tput setaf 4`;
	bg_blue=`tput setab 4`;
	reset=`tput sgr0`;
	bold=`tput setaf bold`;

#------------------------------------------------------
# TODO: Completar con su path
#------------------------------------------------------
proyectoActual="/home/emiliano/tp-sor"
#------------------------------------------------------
# DISPLAY MENU
#------------------------------------------------------
imprimir_menu () {
       imprimir_encabezado "\t  S  U  P  E  R  -  M  E  N U ";
	
    echo -e "\t\t El proyecto actual es:";
    echo -e "\t\t $proyectoActual";

    echo -e "";    
    imprimirEstado;
    echo -e "";
    echo -e "\t\t Opciones:";
    echo "";

    echo -e "\t\t\t a.  Ver estado del proyecto";
    echo -e "\t\t\t b.  Guardar cambios";
    echo -e "\t\t\t c.  Actualizar repo";
    echo -e "\t\t\t d.  Archivos del repositorio"; 
    echo -e "\t\t\t e.  Busquedas";
    echo -e "\t\t\t f.  Vaciar registro de busquedas";
    echo -e "\t\t\t g.  Abrir en terminal";        
    echo -e "\t\t\t h.  Abrir en carpeta";
    
    echo -e "\t\t\t q.  Salir";
    echo "";
    echo -e "Escriba la opción y presione ENTER";
}

#------------------------------------------------------
# FUNCTIONES AUXILIARES
#------------------------------------------------------

imprimir_encabezado () {
    clear;
    #Se le agrega formato a la fecha que muestra
    #Se agrega variable $USER para ver que usuario está ejecutando
    echo -e "`date +"%d-%m-%Y %T" `\t\t\t\t\t USERNAME:$USER";
    echo "";
    #Se agregan colores a encabezado
    echo -e "\t\t ${bg_blue} ${red} ${bold}--------------------------------------\t${reset}";
    echo -e "\t\t ${bold}${bg_blue}${red}$1\t\t${reset}";
    echo -e "\t\t ${bg_blue}${red} ${bold} --------------------------------------\t${reset}";
    echo "";
}

esperar () {
    echo "";
    echo -e "Presione enter para continuar";
    read ENTER ;
}

malaEleccion () {
    echo -e "Selección Inválida ..." ;
}

decidir () {
	echo $1;
	while true; do
		echo "desea ejecutar? (s/n)";
    		read respuesta;
    		case $respuesta in
        		[Nn]* ) break;;
       			[Ss]* ) eval $1
				break;;
        		* ) echo "Por favor tipear S/s ó N/n.";;
    		esac
	done
}

#------------------------------------------------------
# FUNCTIONES del MENU
#------------------------------------------------------
a_funcion () {
    	imprimir_encabezado "\tOpción a.  Ver estado del proyecto";
	echo "---------------------------"        
	echo "Somthing to commit?"
        decidir "cd $proyectoActual; git status";

        echo "---------------------------"        
	echo "Incoming changes (need a pull)?"
	decidir "cd $proyectoActual; git fetch origin"
	decidir "cd $proyectoActual; git log HEAD..origin/master --oneline"
}

b_funcion () {
       	imprimir_encabezado "\tOpción b.  Guardar cambios";
       	decidir "cd $proyectoActual; git add -A";
       	echo "Ingrese mensaje para el commit:";
       	read mensaje;
       	decidir "cd $proyectoActual; git commit -m \"$mensaje\"";
       	decidir "cd $proyectoActual; git push";
}

c_funcion () {
      	imprimir_encabezado "\tOpción c.  Actualizar repo";
      	decidir "cd $proyectoActual; git pull";   	 
}

d_funcion () {
	imprimir_encabezado "Opción d. Ver archivos del repositorio";
	ls -la
    echo "";
    echo "Actualizar el registro de Archivos";
	decidir "ls -la > cantidadArchivos.txt";
}

e_funcion (){
	imprimir_encabezado "\tOpción e. Busquedas";
	echo "Ingresa la palabra que quieres buscar:";
	read mensaje1;
    echo "";
	echo "Ingresa el nombre del archivo en el que quieres buscar coincidencias:";
	read mensaje2;
	grep $mensaje1 $mensaje2;
	grep $mensaje1 $mensaje2 >> busquedasTotales.txt;
    echo "";
	echo "Visualizar el registro de busquedas realizadas:";
	decidir "cat busquedasTotales.txt | sort";
}
f_funcion () {
    imprimir_encabezado "Opción f. Vaciar registro de busquedas";
    echo "Vaciar la lista de busquedas realizadas";
    decidir "cat /dev/null > busquedasTotales.txt";
}

g_funcion () {
	imprimir_encabezado "\tOpción f.  Abrir en terminal";        
	decidir "cd $proyectoActual; xterm &";
}

h_funcion () {
	imprimir_encabezado "\tOpción g.  Abrir en carpeta";        
	decidir "gnome-open $proyectoActual &";
}


#------------------------------------------------------
# TODO: Completar con el resto de ejercicios del TP, una funcion por cada item
#------------------------------------------------------

imprimirEstado () {

git fetch origin

var1=$((git log HEAD..origin/master --oneline) 2>&1);

if [[ $var1 = "" ]];
then
	echo -e "\t\t Todos los datos estan actualizados";
else
	echo -e "\t\t Es necesario realizar un pull antes de continuar";
fi

}

#------------------------------------------------------
# LOGICA PRINCIPAL
#------------------------------------------------------
while  true
do
    # 1. mostrar el menu
    imprimir_menu;
    # 2. leer la opcion del usuario
    read opcion;
    
    case $opcion in
        a|A) a_funcion;;
        b|B) b_funcion;;
        c|C) c_funcion;;
        d|D) d_funcion;;
        e|E) e_funcion;;
        f|F) f_funcion;;
        g|G) g_funcion;;
        h|H) h_funcion;;
        q|Q) break;;
        *) malaEleccion;;
    esac
    esperar;
done
