#!/usr/bin/env bash

# By @m4lal0

# Regular Colors
Black='\033[0;30m'      # Black
Red='\033[0;31m'        # Red
Green='\033[0;32m'      # Green
Yellow='\033[0;33m'     # Yellow
Blue='\033[0;34m'       # Blue
Purple='\033[0;35m'     # Purple
Cyan='\033[0;36m'       # Cyan
White='\033[0;97m'      # White
Blink='\033[5m'         # Blink
Color_Off='\033[0m'     # Text Reset

# Light
LRed='\033[0;91m'       # Ligth Red
LGreen='\033[0;92m'     # Ligth Green
LYellow='\033[0;93m'    # Ligth Yellow
LBlue='\033[0;94m'      # Ligth Blue
LPurple='\033[0;95m'    # Light Purple
LCyan='\033[0;96m'      # Ligth Cyan
LWhite='\033[0;90m'     # Ligth White

# Dark
DGray='\033[2;37m'      # Dark Gray
DRed='\033[2;91m'       # Dark Red
DGreen='\033[2;92m'     # Dark Green
DYellow='\033[2;93m'    # Dark Yellow
DBlue='\033[2;94m'      # Dark Blue
DPurple='\033[2;95m'    # Dark Purple
DCyan='\033[2;96m'      # Dark Cyan
DWhite='\033[2;90m'     # Dark White

# Bold
BBlack='\033[1;30m'     # Bold Black
BRed='\033[1;31m'       # Bold Red
BGreen='\033[1;32m'     # Bold Green
BYellow='\033[1;33m'    # Bold Yellow
BBlue='\033[1;34m'      # Bold Blue
BPurple='\033[1;35m'    # Bold Purple
BCyan='\033[1;36m'      # Bold Cyan
BWhite='\033[1;37m'     # Bold White

# Italics
IBlack='\033[3;30m'     # Italic Black
IGray='\033[3;90m'      # Italic Gray
IRed='\033[3;31m'       # Italic Red
IGreen='\033[3;32m'     # Italic Green
IYellow='\033[3;33m'    # Italic Yellow
IBlue='\033[3;34m'      # Italic Blue
IPurple='\033[3;35m'    # Italic Purple
ICyan='\033[3;36m'      # Italic Cyan
IWhite='\033[3;37m'     # Italic White

# Underline
UBlack='\033[4;30m'     # Underline Black
URed='\033[4;31m'       # Underline Red
UGreen='\033[4;32m'     # Underline Green
UYellow='\033[4;33m'    # Underline Yellow
UBlue='\033[4;34m'      # Underline Blue
UPurple='\033[4;35m'    # Underline Purple
UCyan='\033[4;36m'      # Underline Cyan
UWhite='\033[4;37m'     # Underline White

# Background
On_Black='\033[40m'     # Background Black
On_Red='\033[41m'       # Background Red
On_Green='\033[42m'     # Background Green
On_Yellow='\033[43m'    # Background Yellow
On_Blue='\033[44m'      # Background Blue
On_Purple='\033[45m'    # Background Purple
On_Cyan='\033[46m'      # Background Cyan
On_White='\033[47m'     # Background White

trap ctrl_c INT
VERSION=1.0.1
declare -i COUNTER=0
declare -i VULNERABLES=0
readonly BY='By @m4lal0'

function ctrl_c(){
    echo -e "\n\n${Cyan}[${BYellow}!${Cyan}] ${BRed}Saliendo de la aplicación...${Color_Off}"
    tput cnorm
    exit 1
}

function helpPanel(){
    echo -e "${BGray}Script Bash para comprobar si un dominio o una lista de dominios pueden ser suplantados en base a los registros DMARC.${Color_Off}"
    echo -e "\n${BGray}USO: \n\t ${BGreen}./checkDMARC ${LBlue}[${BRed}opción ${LGray}<argumento>${LBlue}]${Color_Off}"
    echo -e "\n${BGray}OPCIONES:${Color_Off}"
    echo -e "\t${LBlue}[${BRed}-d ${LGray}<DOMAIN> ${BRed}, --domain ${LGray}<DOMAIN>${LBlue}] \t${BPurple}Proporcionar un único dominio.${Color_Off}"
    echo -e "\t${LBlue}[${BRed}-f ${LGray}<FILE> ${BRed}, --file ${LGray}<FILE>${LBlue}] \t\t${BPurple}Proporcionar un archivo con listado de dominios.${Color_Off}"
    echo -e "\t${LBlue}[${BRed}-u , --update${LBlue}] \t\t\t${BPurple}Actualizar la herramienta.${ColorOff}"
    echo -e "\t${LBlue}[${BRed}-h , --help${LBlue}] \t\t\t\t${BPurple}Mostrar este panel de ayuda.${Color_Off}"
    echo -e "\n${BGray}EJEMPLOS:${Color_Off}"
    echo -e "\t${BGreen}./checkDMARC${Color_Off}${BRed} -d google.com ${Color_Off}${IGray}- Comprueba si el dominio de Google cuenta con registros DMARC.${Color_Off}"
    echo -e "\t${BGreen}./checkDMARC${Color_Off}${BRed} -f domain_list.txt ${Color_Off}${IGray}- Leer un archivo con listado de dominios para verificar registros DMARC.${Color_Off}\n"
}

function banner(){
    clear
    echo -e "\t${BGray}   _____ _               _   ${BPurple} _____  __  __          _____   ____ ${Color_Off}"
    echo -e "\t${BGray}  / ____| |             | |  ${BPurple}|  __ \|  \/  |   /\   |  __ \ / ___|${Color_Off}"
    echo -e "\t${BGray} | |    | |__   ___  ___| | _${BPurple}| |  | | \  / |  /  \  | |__) | |    ${Color_Off}"
    echo -e "\t${BGray} | |    | '_ \ / _ \/ __| |/ ${BPurple}/ |  | | |\/| | / /\ \ |  _  /| |    ${Color_Off}"
    echo -e "\t${BGray} | |____| | | |  __/ (__|   <${BPurple}| |__| | |  | |/ ____ \| | \ \| |___ ${Color_Off}"
    echo -e "\t${BGray}  \_____|_| |_|\___|\___|_|\_${BPurple}\_____/|_|  |_/_/    \_\_|  \_\\_____|${Color_Off}"
	sleep 0.15 && echo -e "\t\t\t\t\t\t${ICyan}    .:.:. $BY .:.:.${Color_Off}\n\n"
	tput civis
}

function checkUpdate(){
    GIT=$(curl --silent https://github.com/m4lal0/checkDMARC/blob/main/checkDMARC.sh | grep 'VERSION=' | cut -d">" -f2 | cut -d"<" -f1 | cut -d"=" -f 2)
    if [[ "$GIT" == "$VERSION" || -z $GIT ]]; then
        echo -e "${BGreen}[✔]${Color_Off} ${BGreen}La versión actual es la más reciente.${Color_Off}\n"
        tput cnorm; exit 0
    else
        echo -e "${Yellow}[*]${Color_Off} ${IWhite}Actualización disponible${Color_Off}"
        echo -e "${Yellow}[*]${Color_Off} ${IWhite}Actualización de la versión${Color_Off} ${BWhite}$VERSION${Color_Off} ${IWhite}a la${Color_Off} ${BWhite}$GIT${Color_Off}"
        update="1"
    fi
}

function installUpdate(){
    echo -en "${Yellow}[*]${Color_Off} ${IWhite}Instalando actualización...${Color_Off}"
    git clone https://github.com/m4lal0/checkDMARC &>/dev/null
    chmod +x checkDMARC/checkDMARC.sh &>/dev/null
    mv checkDMARC/checkDMARC.sh ./checkDMARC &>/dev/null
    if [ "$(echo $?)" == "0" ]; then
        if [ -f /usr/local/bin/checkDMARC ]; then
            mv checkDMARC /usr/local/bin
        fi
        echo -e "${BGreen}[ OK ]${Color_Off}"
    else
        echo -e "${BRed}[ FAIL ]${Color_Off}"
        tput cnorm && exit 1
    fi
    echo -en "${Yellow}[*]${Color_Off} ${IWhite}Limpiando...${Color_Off}"
    wait
    rm -rf checkDMARC images README.md &>/dev/null
    if [ "$(echo $?)" == "0" ]; then
        echo -e "${BGreen}[ OK ]${Color_Off}"
    else
        echo -e "${BRed}[ FAIL ]${Color_Off}"
        tput cnorm && exit 1
    fi
    echo -e "\n${BGreen}[✔]${Color_Off} ${IGreen}Versión actualizada a${Color_Off} ${BWhite}$GIT${Color_Off}\n"
    tput cnorm && exit 0
}

function update(){
    banner
    echo -e "\n${BBlue}[+]${Color_Off} ${BWhite}checkDMARC Versión: $VERSION${Color_Off}"
    echo -e "${BBlue}[+]${Color_Off} ${BWhite}Verificando actualización de checkDMARC${Color_Off}"
    checkUpdate
    echo -e "\t${BWhite}$VERSION ${IWhite}Versión Instalada${Color_Off}"
    echo -e "\t${BWhite}$GIT ${IWhite}Versión en Git${Color_Off}\n"
    if [ "$update" != "1" ]; then
        tput cnorm && exit 0;
    else
        echo -e "${BBlue}[+]${Color_Off} ${BWhite}Necesita actualizar!${Color_Off}"
        tput cnorm
        echo -en "${BPurple}[?]${Color_Off} ${BCyan}Quiere actualizar? (${BGreen}Y${BCyan}/${BRed}n${BCyan}):${Color_Off} " && read CONDITION
        tput civis
        case "$CONDITION" in
            n|N) echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BRed}No se actualizo, se queda en la versión ${BWhite}$VERSION${Color_Off}\n" && tput cnorm && exit 0;;
            *) installUpdate;;
        esac
    fi
}

function checkDomain(){
	OUTPUT=$(nslookup -type=txt _dmarc."$DOMAIN" | grep text | cut -d " " -f3-100 | tail -n1)
    echo ""
	case "$OUTPUT" in
		*p=reject*)
            echo -e " ${LBlue}[*]${Color_Off}${BWhite} Registro DMARC encontrado:${Color_Off}"
            echo -e " ${LBlue}[*]${Color_Off}${IWhite} $OUTPUT${Color_Off}"
            echo -e " ${LBlue}[*]${Color_Off}${BWhite} Política DMARC establecida como${Color_Off}${ICyan} reject.${Color_Off}"
			echo -e " ${LRed}[-]${Color_Off}${IRed} No es posible la suplantación de identidad para${Color_Off}${BWhite} $DOMAIN ${Color_Off}" ;;
		*p=quarantine*)
            echo -e " ${LBlue}[*]${Color_Off}${BWhite} Registro DMARC encontrado:${Color_Off}"
            echo -e " ${LBlue}[*]${Color_Off}${IWhite} $OUTPUT${Color_Off}"
            echo -e " ${LBlue}[*]${Color_Off}${BWhite} Política DMARC establecida como${Color_Off}${ICyan} quarantine.${Color_Off}"
            echo -e " ${LGreen}[+]${Color_Off}${IGreen} Posible suplantación de identididad para${Color_Off}${BWhite} $DOMAIN ${Color_Off}${IGreen} (email podria ser enviado como spam)${Color_Off}" ;;
		*p=none*)
            echo -e " ${LBlue}[*]${Color_Off}${BWhite} Registro DMARC encontrado:${Color_Off}"
            echo -e " ${LBlue}[*]${Color_Off}${IWhite} $OUTPUT${Color_Off}"
            echo -e " ${LBlue}[*]${Color_Off}${BWhite} Política DMARC establecida como${Color_Off}${ICyan} none.${Color_Off}"
            echo -e " ${LGreen}[+]${Color_Off}${IGreen} Posible suplantación de identididad para${Color_Off}${BWhite} $DOMAIN ${Color_Off}" ;;
		*)
            echo -e " ${LBlue}[*]${Color_Off}${BWhite} No hay registro DMARC de la organización.${Color_Off}"
            echo -e " ${LGreen}[+]${Color_Off}${IGreen} Posible suplantación de identididad para${Color_Off}${BWhite} $DOMAIN ${Color_Off}" ;;
	esac
}

function checkFile(){
        echo ""
		while IFS= read -r LINE
		do
			COUNTER=$((COUNTER=COUNTER+1))
			OUTPUT=$(nslookup -type=txt _dmarc."$LINE" | grep text | cut -d " " -f3-100 | tail -n1)
            case "$OUTPUT" in
                *p=reject*)
                    echo -e " ${LBlue}[*]${Color_Off}${BWhite} Registro DMARC encontrado:${Color_Off}"
                    echo -e " ${LBlue}[*]${Color_Off}${IWhite} $OUTPUT${Color_Off}"
                    echo -e " ${LBlue}[*]${Color_Off}${BWhite} Política DMARC establecida como${Color_Off}${ICyan} reject.${Color_Off}"
                    echo -e " ${LRed}[-]${Color_Off}${IRed} No es posible la suplantación de identidad para${Color_Off}${BWhite} $LINE ${Color_Off}\n" ;;
                *p=quarantine*)
                    echo -e " ${LBlue}[*]${Color_Off}${BWhite} Registro DMARC encontrado:${Color_Off}"
                    echo -e " ${LBlue}[*]${Color_Off}${IWhite} $OUTPUT${Color_Off}"
                    echo -e " ${LBlue}[*]${Color_Off}${BWhite} Política DMARC establecida como${Color_Off}${ICyan} quarantine.${Color_Off}"
                    echo -e " ${LGreen}[+]${Color_Off}${IGreen} Posible suplantación de identididad para${Color_Off}${BWhite} $LINE ${Color_Off}${IGreen} (email podria ser enviado como spam)${Color_Off}\n" ;;
                *p=none*)
                    VULNERABLES+=1
                    echo -e " ${LBlue}[*]${Color_Off}${BWhite} Registro DMARC encontrado:${Color_Off}"
                    echo -e " ${LBlue}[*]${Color_Off}${IWhite} $OUTPUT${Color_Off}"
                    echo -e " ${LBlue}[*]${Color_Off}${BWhite} Política DMARC establecida como${Color_Off}${ICyan} none.${Color_Off}"
                    echo -e " ${LGreen}[+]${Color_Off}${IGreen} Posible suplantación de identididad para${Color_Off}${BWhite} $LINE ${Color_Off}\n" ;;
                *)
                    VULNERABLES+=1
                    echo -e " ${LBlue}[*]${Color_Off}${BWhite} No hay registro DMARC de la organización.${Color_Off}"
                    echo -e " ${LGreen}[+]${Color_Off}${IGreen} Posible suplantación de identididad para${Color_Off}${BWhite} $LINE ${Color_Off}\n" ;;
            esac
		done < $FILE
		echo -e "\n $VULNERABLES de $COUNTER dominios son ${BRed}vulnerables ${Color_Off}"
}

## Opciones
arg=""
for arg; do
	delim=""
	case $arg in
		--domain)	args="${args}-d";;
        --file)	    args="${args}-f";;
        --update)	args="${args}-u";;
		--help)		args="${args}-h";;
		*) [[ "${arg:0:1}" == "-" ]] || delim="\""
        args="${args}${delim}${arg}${delim} ";;
	esac
done

eval set -- $args

declare -i parameter_counter=0; while getopts ":d:f:uh" arg; do
    case $arg in
        d) DOMAIN=$OPTARG && let parameter_counter+=1 ;;
        f) FILE=$OPTARG && let parameter_counter+=1 ;;
        u) update ;;
        h) helpPanel;;
        *) helpPanel;;
    esac
done

if [ $parameter_counter -eq 0 ]; then
    banner
    helpPanel
    tput cnorm
else
    if [ "$(echo $DOMAIN)" ]; then
        checkDomain
        tput cnorm
    else
        checkFile
        tput cnorm
    fi
fi