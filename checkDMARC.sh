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

# Configuración de trap para manejar Ctrl+C
trap ctrl_c INT

# Variables globales
VERSION=1.0.2           # Versión del script
declare -i COUNTER=0    # Contador de dominios procesados
declare -i VULNERABLES=0 # Contador de dominios vulnerables
readonly BY='By @m4lal0' # Autor del script
declare -a RESULTS      # Arreglo para almacenar resultados

function ctrl_c(){
    # Manejar la interrupción del script con Ctrl+C
    echo -e "\n\n${Cyan}[${BYellow}!${Cyan}] ${BRed}Saliendo de la aplicación...${Color_Off}"
    tput cnorm
    exit 1
}

function helpPanel(){
    # Mostrar el panel de ayuda con opciones y ejemplos de uso
    echo -e "${BWhite}Comprobar si un dominio o una lista de dominios pueden ser suplantados en base a los registros DMARC.${Color_Off}"
    echo -e "\n${BWhite}USO: ${BGreen}checkDMARC ${LBlue}[${Color_Off}${BRed}-h${Color_Off}${LBlue}]${Color_Off} ${BRed}-d DOMAIN${Color_Off} ${LBlue}[${Color_Off}${BRed}-f FILE${Color_Off}${LBlue}]${Color_Off} ${LBlue}[${Color_Off}${BRed}-o${Color_Off}${LBlue}]${Color_Off} ${LBlue}[${Color_Off}${BRed}-v${Color_Off}${LBlue}]${Color_Off} ${LBlue}[${Color_Off}${BRed}-u${Color_Off}${LBlue}]${Color_Off}"

    echo -e "\n${BWhite}OPCIONES:${Color_Off}\n"
    echo -e "  ${BRed}-d DOMAIN, --domain DOMAIN${Color_Off}    ${IWhite}Nombre del dominio${Color_Off}"
    echo -e "  ${BRed}-f FILE, --file FILE${Color_Off}          ${IWhite}Lee archivo con listado de dominios${Color_Off}"
    echo -e "  ${BRed}-o, --output${Color_Off}                  ${IWhite}Formato de salida (txt ó json)${Color_Off}"
    echo -e "  ${BRed}-v, --version${Color_Off}                 ${IWhite}Mostrar la versión instalada${Color_Off}"
    echo -e "  ${BRed}-u, --update${Color_Off}                  ${IWhite}Actualizar la aplicación${Color_Off}"
    echo -e "  ${BRed}-h, --help${Color_Off}                    ${IWhite}Mostrar este panel de ayuda${Color_Off}\n"

    echo -e "${BBlue}[${BWhite}Ejemplos de uso${BBlue}]${Color_Off}\n"
    echo -e "${BGreen}Comprobar si un dominio cuenta con registro DMARC:${Color_Off}"
    echo -e "   checkDMARC -d google.com\n"
    echo -e "${BGreen}Lee los dominios del archivo "domains.txt" y guarda los resultados en formato 'json':${Color_Off}"
    echo -e "   checkDMARC -f domains.txt -o json\n"
}

function banner(){
    # Mostrar el banner estilizado de la herramienta
    # clear
    echo -e "\n\t${BGray}   _____ _               _   ${BPurple} _____  __  __          _____   ____ ${Color_Off}"
    echo -e "\t${BGray}  / ____| |             | |  ${BPurple}|  __ \|  \/  |   /\   |  __ \ / ___|${Color_Off}"
    echo -e "\t${BGray} | |    | |__   ___  ___| | _${BPurple}| |  | | \  / |  /  \  | |__) | |    ${Color_Off}"
    echo -e "\t${BGray} | |    | '_ \ / _ \/ __| |/ ${BPurple}/ |  | | |\/| | / /\ \ |  _  /| |    ${Color_Off}"
    echo -e "\t${BGray} | |____| | | |  __/ (__|   <${BPurple}| |__| | |  | |/ ____ \| | \ \| |___ ${Color_Off}"
    echo -e "\t${BGray}  \_____|_| |_|\___|\___|_|\_${BPurple}\_____/|_|  |_/_/    \_\_|  \_\\_____|${Color_Off}"
	sleep 0.15 && echo -e "\t\t\t\t\t\t${ICyan}    .:.:. $BY .:.:.${Color_Off}\n\n"
	tput civis
}

function printVersion(){
    # Mostrar la versión actual de la herramienta con el banner
    banner
    echo -e "\n${LBlue}[${BBlue}*${LBlue}]${BWhite} CheckDMARC - Comprueba si un dominio o una lista de dominios pueden ser suplantados.${Color_Off}"
    echo -e "\n${White}Versión instalada: ${BWhite}$VERSION${Color_Off}\n"
    tput cnorm; exit 1
}

function checkUpdate(){
    # Obtener la versión de GitHub
    GIT_VERSION=$(curl --silent https://raw.githubusercontent.com/m4lal0/checkDMARC/refs/heads/main/checkDMARC.sh | grep 'VERSION=' | head -n 1 | cut -d"=" -f 2)
    
    # Verificar si se obtuvo la versión de GitHub
    if [[ -z "$GIT_VERSION" ]]; then
        echo -e "\n${LBlue}[${BRed}✘${LBlue}]${Color_Off} ${On_Red}${BWhite}Error:${Color_Off} ${BRed}No se pudo obtener la versión de GitHub. Verifica tu conexión.${Color_Off}\n"
        tput cnorm; exit 1
    fi
    
    # Comparar versiones usando sort -V
    if [[ "$(printf '%s\n%s' "$VERSION" "$GIT_VERSION" | sort -V | head -n 1)" == "$GIT_VERSION" ]]; then
        echo -e "${BGreen}[✔]${Color_Off} ${BGreen}La versión actual ($VERSION) es la más reciente.${Color_Off}\n"
        tput cnorm; exit 0
    else
        echo -e "${Yellow}[*]${Color_Off} ${IWhite}Actualización disponible${Color_Off}"
        echo -e "${Yellow}[*]${Color_Off} ${IWhite}Actualización de la versión${Color_Off} ${BWhite}$VERSION${Color_Off} ${IWhite}a la${Color_Off} ${BWhite}$GIT_VERSION${Color_Off}"
        update="1"
    fi
}

function installUpdate(){
    # Descargar e instalar la actualización desde GitHub
    echo -en "${Yellow}[*]${Color_Off} ${IWhite}Instalando actualización...${Color_Off}"
    # Descargar a un archivo temporal
    wget -q https://raw.githubusercontent.com/m4lal0/checkDMARC/refs/heads/main/checkDMARC.sh -O /tmp/checkDMARC.sh
    if [ $? -eq 0 ]; then
        chmod +x /tmp/checkDMARC.sh
        mv /tmp/checkDMARC.sh /usr/local/bin/checkDMARC
        if [ $? -eq 0 ]; then
            echo -e "${BGreen}[ OK ]${Color_Off}"
            echo -e "\n${BGreen}[✔]${Color_Off} ${IGreen}Versión actualizada a${Color_Off} ${BWhite}$GIT_VERSION${Color_Off}\n"
            tput cnorm; exit 0
        else
            echo -e "${BRed}[ FAIL ]${Color_Off}"
            echo -e "${BRed}Error al mover el archivo. Verifica permisos.${Color_Off}"
            tput cnorm; exit 1
        fi
    else
        echo -e "${BRed}[ FAIL ]${Color_Off}"
        echo -e "${BRed}Error al descargar la actualización.${Color_Off}"
        tput cnorm; exit 1
    fi
}

function update(){
    # Gestionar el proceso de actualización de la herramienta
    banner
    echo -e "${BBlue}[+]${Color_Off} ${BWhite}CheckDMARC Versión $VERSION${Color_Off}"
    echo -e "${BBlue}[+]${Color_Off} ${BWhite}Verificando actualización de CheckDMARC${Color_Off}"
    checkUpdate
    echo -e "\t${BWhite}$VERSION ${IWhite}Versión Instalada${Color_Off}"
    echo -e "\t${BWhite}$GIT_VERSION ${IWhite}Versión en Git${Color_Off}\n"
    if [ "$update" != "1" ]; then
        tput cnorm; exit 0
    else
        echo -e "${BBlue}[+]${Color_Off} ${BWhite}Necesita actualizar!${Color_Off}"
        tput cnorm
        echo -en "${BPurple}[?]${Color_Off} ${BCyan}¿Quiere actualizar? (${BGreen}Y${BCyan}/${BRed}n${BCyan}):${Color_Off} "
        read CONDITION
        tput civis
        case "$CONDITION" in
            n|N)
                echo -e "\n${LBlue}[${BYellow}!${LBlue}] ${BRed}No se actualizó, se queda en la versión ${BWhite}$VERSION${Color_Off}\n"
                tput cnorm; exit 0
                ;;
            *)
                installUpdate
                ;;
        esac
    fi
}

function validateDomain() {
    # Valida si el dominio tiene un formato correcto
    local domain=$1
    if [[ $domain =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        if nslookup "$domain" &> /dev/null; then
            return 0  # Dominio válido
        else
            return 1  # Dominio inválido
        fi
    fi
}

function validateOutput(){
    # Convertir el formato a minúsculas para validación
    OUTPUT_FORMAT=$(echo "$OUTPUT_FORMAT" | tr '[:upper:]' '[:lower:]')
    # Validar que el formato de salida sea uno de los permitidos: txt ó json
    if [ -n "$OUTPUT_FORMAT" ]; then
        case $OUTPUT_FORMAT in
            txt|json) ;;
            *) echo -e "\n${LBlue}[${BRed}✘${LBlue}]${Color_Off} ${On_Red}${BWhite}Error:${Color_Off} ${BRed}$OUTPUT_FORMAT no es un formato de salida válido. Use 'txt' o 'json'.${Color_Off}"; tput cnorm; exit 1;;
        esac
    fi
}

function checkDMARC() {
    local domain=$1
    local update_counters=${2:-false}
    if ! validateDomain "$domain"; then
        echo -e " ${LBlue}[*]${Color_Off}${BWhite} Dominio:${Color_Off} ${BBlue}$domain${Color_Off}"
        echo -e " ${Red}[-]${Color_Off}${Red} No existe el dominio.${Color_Off}\n"
        if [ -n "$OUTPUT_FORMAT" ]; then
            if [ "$OUTPUT_FORMAT" == "json" ]; then
                RESULTS+=("{\"domain\": \"$domain\", \"policy\": \"no existe Dominio\", \"vulnerable\": \"n/a\"}")
            else
                RESULTS+=("Dominio: $domain\nPolítica DMARC: no existe Dominio\nVulnerable: n/a\n")
            fi
        fi
        return
    fi
    OUTPUT=$(nslookup -type=txt _dmarc."$domain" | grep text | cut -d " " -f3-100 | tail -n1)
    local policy=""
    local vulnerable=""
    case "$OUTPUT" in
        *p=reject*)
            policy="reject"
            vulnerable="no"
            echo -e " ${LBlue}[*]${Color_Off}${BWhite} Dominio:${Color_Off} ${BBlue}$domain${Color_Off}"
            echo -e " ${LBlue}[*]${Color_Off}${BWhite} Registro DMARC encontrado:${Color_Off}"
            echo -e " ${LBlue}[*]${Color_Off}${IWhite} $OUTPUT${Color_Off}"
            echo -e " ${LBlue}[*]${Color_Off}${BWhite} Política DMARC establecida como${Color_Off}${ICyan} $policy.${Color_Off}"
            echo -e " ${LRed}[-]${Color_Off}${IRed} No es posible la suplantación de identidad para${Color_Off}${BWhite} $domain ${Color_Off}\n"
            ;;
        *p=quarantine*)
            policy="quarantine"
            vulnerable="posible (spam)"
            if [ "$update_counters" = true ]; then
                VULNERABLES=$((VULNERABLES + 1))
            fi
            echo -e " ${LBlue}[*]${Color_Off}${BWhite} Dominio:${Color_Off} ${BBlue}$domain${Color_Off}"
            echo -e " ${LBlue}[*]${Color_Off}${BWhite} Registro DMARC encontrado:${Color_Off}"
            echo -e " ${LBlue}[*]${Color_Off}${IWhite} $OUTPUT${Color_Off}"
            echo -e " ${LBlue}[*]${Color_Off}${BWhite} Política DMARC establecida como${Color_Off}${ICyan} $policy.${Color_Off}"
            echo -e " ${LGreen}[+]${Color_Off}${IGreen} Posible suplantación de identidad para${Color_Off}${BWhite} $domain ${Color_Off}${IGreen} (email podría ser enviado como spam)${Color_Off}\n"
            ;;
        *p=none*)
            policy="none"
            vulnerable="sí"
            if [ "$update_counters" = true ]; then
                VULNERABLES=$((VULNERABLES + 1))
            fi
            echo -e " ${LBlue}[*]${Color_Off}${BWhite} Dominio:${Color_Off} ${BBlue}$domain${Color_Off}"
            echo -e " ${LBlue}[*]${Color_Off}${BWhite} Registro DMARC encontrado:${Color_Off}"
            echo -e " ${LBlue}[*]${Color_Off}${IWhite} $OUTPUT${Color_Off}"
            echo -e " ${LBlue}[*]${Color_Off}${BWhite} Política DMARC establecida como${Color_Off}${ICyan} $policy.${Color_Off}"
            echo -e " ${LGreen}[+]${Color_Off}${IGreen} Posible suplantación de identidad para${Color_Off}${BWhite} $domain ${Color_Off}\n"
            ;;
        *)
            policy="ninguna"
            vulnerable="sí"
            if [ "$update_counters" = true ]; then
                VULNERABLES=$((VULNERABLES + 1))
            fi
            echo -e " ${LBlue}[*]${Color_Off}${BWhite} Dominio:${Color_Off} ${BBlue}$domain${Color_Off}"
            echo -e " ${LBlue}[*]${Color_Off}${BWhite} No hay registro DMARC de la organización.${Color_Off}"
            echo -e " ${LGreen}[+]${Color_Off}${IGreen} Posible suplantación de identidad para${Color_Off}${BWhite} $domain ${Color_Off}\n"
            ;;
    esac
    if [ -n "$OUTPUT_FORMAT" ]; then
        if [ "$OUTPUT_FORMAT" == "json" ]; then
            RESULTS+=("{\"domain\": \"$domain\", \"policy\": \"$policy\", \"vulnerable\": \"$vulnerable\"}")
        else
            RESULTS+=("Dominio: $domain\nPolítica DMARC: $policy\nVulnerable: $vulnerable\n")
        fi
    fi
}

function checkDomain(){
    checkDMARC "$DOMAIN"
}

function checkFile(){
    if [ -n "$FILE" ]; then
        if [ ! -f "$FILE" ]; then
            echo -e "\n${LBlue}[${BRed}✘${LBlue}]${Color_Off} ${On_Red}${BWhite}Error:${Color_Off} ${BRed}El archivo $FILE no existe.${Color_Off}"
            tput cnorm
            exit 1
        fi
        if [ ! -r "$FILE" ]; then
            echo -e "\n${LBlue}[${BRed}✘${LBlue}]${Color_Off} ${On_Red}${BWhite}Error:${Color_Off} ${BRed}El archivo $FILE no es legible.${Color_Off}"
            tput cnorm
            exit 1
        fi
    fi
    echo ""
    while IFS= read -r LINE; do
        COUNTER=$((COUNTER + 1))
        checkDMARC "$LINE" true
    done < "$FILE"
    echo -e "\n $VULNERABLES de $COUNTER dominios son ${BRed}vulnerables ${Color_Off}"
}

## Opciones
arg=""
for arg; do
    delim=""
    case $arg in
        --domain)   args="${args}-d";;
        --file)     args="${args}-f";;
        --output)   args="${args}-o";;
        --version)  args="${args}-v";;
        --update)   args="${args}-u";;
        --help)     args="${args}-h";;
        *) [[ "${arg:0:1}" == "-" ]] || delim="\""
        args="${args}${delim}${arg}${delim} ";;
    esac
done

eval set -- $args

declare -i parameter_counter=0
while getopts ":d:f:o:uvh" arg; do
    case $arg in
        d) DOMAIN=$OPTARG && let parameter_counter+=1 ;;
        f) FILE=$OPTARG && let parameter_counter+=1 ;;
        o) OUTPUT_FORMAT=$OPTARG ;;
        v) printVersion ;;
        u) update ;;
        h) helpPanel ;;
        *) helpPanel ;;
    esac
done

# Validación de parámetros
if [ -n "$OUTPUT_FORMAT" ] && [ $parameter_counter -eq 0 ]; then
    banner
    echo -e "\n${LBlue}[${BRed}✘${LBlue}]${Color_Off} ${On_Red}${BWhite}Error:${Color_Off} ${BRed}Debe usar el parámetro -d o -f junto con -o.${Color_Off}"
    tput cnorm
    exit 1
fi

# Lógica principal del script
if [ $parameter_counter -eq 0 ] || [ $parameter_counter -ge 2 ]; then
    banner
    helpPanel
    tput cnorm
else
    banner
    validateOutput
    # Definir el nombre del archivo de salida según el formato
    if [ -n "$OUTPUT_FORMAT" ]; then
        OUTPUT_FILE="results.$OUTPUT_FORMAT"
    fi
    if [ -n "$DOMAIN" ]; then
        checkDomain
    elif [ -n "$FILE" ]; then
        checkFile
    fi
    # Guardar los resultados en el archivo según el formato
    if [ -n "$OUTPUT_FILE" ] && [ ${#RESULTS[@]} -gt 0 ]; then
        if [ "$OUTPUT_FORMAT" == "json" ]; then
            echo "[" > "$OUTPUT_FILE"
            for i in "${!RESULTS[@]}"; do
                if [ $i -ne 0 ]; then
                    echo "," >> "$OUTPUT_FILE"
                fi
                echo -n "${RESULTS[$i]}" >> "$OUTPUT_FILE"
            done
            echo -e "\n]" >> "$OUTPUT_FILE"
        else
            for line in "${RESULTS[@]}"; do
                echo -e "$line" >> "$OUTPUT_FILE"
            done
        fi
        echo -e "\n${LGreen}[✔]${Color_Off} ${IWhite}Resultados guardados en${Color_Off} ${BWhite}$OUTPUT_FILE${Color_Off}"
    fi
    tput cnorm  # Restaurar cursor
fi