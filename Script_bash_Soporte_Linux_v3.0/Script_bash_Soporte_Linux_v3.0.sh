#!/bin/bash

# =========================================
# CONFIGURACIONES INICIALES
# =========================================

# Variables globales
SCRIPT_NAME="Script para Soporte Linux"
VERSION="3.0"
DEVELOPER="Smith Lozano"
LOG_PATH="/tmp/soporte_linux_$(date +%Y%m%d_%H%M%S).log"
PASSWORD_CORRECTA="soporte"
CURRENT_USER=$(whoami)
HOSTNAME=$(hostname)

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# =========================================
# FUNCIONES BÁSICAS
# =========================================

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_PATH"
}

success() {
    echo -e "${GREEN}[✓]${NC} $1"
    log "SUCCESS: $1"
}

error() {
    echo -e "${RED}[✗]${NC} $1"
    log "ERROR: $1"
}

warning() {
    echo -e "${YELLOW}[!]${NC} $1"
    log "WARNING: $1"
}

info() {
    echo -e "${BLUE}[i]${NC} $1"
    log "INFO: $1"
}

pause() {
    echo -e "${YELLOW}Presiona Enter para continuar...${NC}"
    read -r
}

# =========================================
# FUNCIONES DE SEGURIDAD PARA PAQUETES
# =========================================

# Lista de paquetes CRÍTICOS que NUNCA deben eliminarse
paquetes_protegidos() {
    cat << 'EOF'
cinnamon*
linuxmint*
mint*
nemo*
xapp*
firefox*
thunderbird*
libreoffice*
ubuntu-system-service
systemd*
gnome*
gtk*
gdm*
sddm*
lightdm*
network-manager*
bluez*
cups*
alsa*
pulseaudio*
pipewire*
xorg*
wayland*
mesa*
nvidia*
amd*
intel*
bash*
coreutils*
apt*
dpkg*
sudo*
grep*
sed*
findutils*
tar*
gzip*
bzip2*
wget*
curl*
firefox*
chromium*
opera*
vlc*
gimp*
inkscape*
thunderbird*
libreoffice*
evolution*
nautilus*
gedit*
vim*
nano*
EOF
}

# Función SEGURA para limpieza de paquetes
limpieza_paquetes_segura() {
    echo -e "${YELLOW}■ EJECUTANDO LIMPIEZA SEGURA DE PAQUETES...${NC}"

    # Solo hacer autoremove normal, NUNCA --purge automático
    echo "1. Eliminando paquetes innecesarios (seguro)..."
    sudo apt autoremove -y

    # Limpieza de cache sin afectar paquetes
    echo "2. Limpiando cache de paquetes..."
    sudo apt autoclean
    sudo apt clean

    success "Limpieza segura completada"
}

# Verificar si un paquete es crítico antes de eliminarlo
es_paquete_critico() {
    local paquete=$1
    local protegidos=$(paquetes_protegidos)

    # Verificar contra patrones protegidos
    while IFS= read -r patron; do
        if [[ -n "$patron" ]] && [[ "$paquete" == $patron ]]; then
            return 0  # Es crítico
        fi
    done <<< "$protegidos"

    return 1  # No es crítico
}

# =========================================
# SISTEMA DE AUTENTICACIÓN
# =========================================

autenticacion() {
    clear
    echo -e "${CYAN}"

# ARTE ASCII
    echo "╔══════════════════════════════════════════════╗"
    echo "║    ███████╗███╗   ███╗██╗████████╗██╗  ██╗   ║"
    echo "║    ██╔════╝████╗ ████║██║╚══██╔══╝██║  ██║   ║"
    echo "║    ███████╗██╔████╔██║██║   ██║   ███████║   ║"
    echo "║    ╚════██║██║╚██╔╝██║██║   ██║   ██╔══██║   ║"
    echo "║    ███████║██║ ╚═╝ ██║██║   ██║   ██║  ██║   ║"
    echo "║    ╚══════╝╚═╝     ╚═╝╚═╝   ╚═╝   ╚═╝  ╚═╝   ║"
    echo "╠══════════════════════════════════════════════╣"
    echo "║           S O P O R T E   L I N U X          ║"
    echo "║              = SMITH LOZANO =                ║"
    echo "║                   v 3.0                      ║"
    echo "╠══════════════════════════════════════════════╣"
    echo "║       * SCRIPT DE SOPORTE TÉCNICO *          ║"
    echo "║                                              ║"
    echo "║     • DIAGNÓSTICO AVANZADO DE SISTEMAS       ║"
    echo "║     • REPARACIÓN Y MANTENIMIENTO             ║"
    echo "║     • OPTIMIZACIÓN DE RENDIMIENTO            ║"
    echo "║                                              ║"
    echo "║     * COMPATIBLE CON DISTRIBUCIONES *        ║"
    echo "║        Debian • Ubuntu • Derivados           ║"
    echo "║         GNU/Linux Basadas en APT             ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""

    echo "╔══════════════════════════════════════════════╗"
    echo "║            ┌───────────────────┐             ║"
    echo "║            │ █████████████████ │             ║"
    echo "║            │ █               █ │             ║"
    echo "║            │ █ AUTENTICACIÓN █ │             ║"
    echo "║            │ █   REQUERIDA   █ │             ║"
    echo "║            │ █               █ │             ║"
    echo "║            │ █████████████████ │             ║"
    echo "║            └───────────────────┘             ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    local intentos=3
    while [[ $intentos -gt 0 ]]; do
        echo -n "Ingrese la contraseña: "
        read -s contrasena
        echo

        if [[ "$contrasena" == "$PASSWORD_CORRECTA" ]]; then
            success "Autenticación exitosa"
            log "Autenticación exitosa"
            return 0
        else
            intentos=$((intentos - 1))
            error "Contraseña incorrecta. Intentos restantes: $intentos"
            log "Intento fallido de autenticación"
        fi
    done

    error "Demasiados intentos fallidos. Saliendo..."
    exit 1
}

# =========================================
# INFORMACIÓN DEL SISTEMA - SECCIÓN PRINCIPAL
# =========================================

menu_informacion_sistema() {
    while true; do
        clear
        echo -e "${CYAN}"
        echo "==================================================="
        echo "           INFORMACIÓN DEL SISTEMA"
        echo "==================================================="
        echo -e "${NC}"
        
        echo "1)  Información básica del sistema"
        echo "2)  Información detallada del procesador"
        echo "3)  Información de memoria RAM"
        echo "4)  Información de almacenamiento"
        echo "5)  Información de hardware completo"
        echo "6)  Logs de inicios de sesión"
        echo "7)  Información de la distribución"
        echo "8)  Resumen completo del sistema"
        echo
        echo "0)  VOLVER AL MENÚ PRINCIPAL"
        echo
        
        read -p "Seleccione una opción [0-8]: " opcion
        
        case $opcion in
            1) info_basica_sistema ;;
            2) info_procesador_detallada ;;
            3) info_memoria_ram ;;
            4) info_almacenamiento ;;
            5) info_hardware_completo ;;
            6) logs_inicios_sesion ;;
            7) info_distribucion ;;
            8) resumen_completo_sistema ;;
            0) return ;;
            *) 
                error "Opción no válida: $opcion"
                pause 
                ;;
        esac
    done
}

# =========================================
# FUNCIONES DE INFORMACIÓN DEL SISTEMA
# =========================================

info_basica_sistema() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "           INFORMACIÓN BÁSICA DEL SISTEMA"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ INFORMACIÓN GENERAL:${NC}"
    echo "Hostname: $(hostname)"
    echo "Usuario actual: $(whoami)"
    echo "Shell: $SHELL"
    echo "ID del usuario: $(id -u)"
    echo "Grupos: $(id -Gn)"
    
    echo -e "\n${YELLOW}■ TIEMPO DE ACTIVIDAD:${NC}"
    echo "Encendido desde: $(uptime -s 2>/dev/null || echo 'N/A')"
    echo "Tiempo activo: $(uptime -p 2>/dev/null || echo 'N/A')"
    echo "Fecha/hora actual: $(date)"
    
    echo -e "\n${YELLOW}■ CARGA DEL SISTEMA:${NC}"
    echo "Carga promedio: $(cat /proc/loadavg 2>/dev/null || echo 'N/A')"
    echo "Procesos activos: $(ps -e --no-headers | wc -l)"
    
    echo -e "\n${YELLOW}■ ARQUITECTURA:${NC}"
    echo "Arquitectura: $(uname -m)"
    echo "Kernel: $(uname -r)"
    echo "Sistema: $(uname -s)"
    
    pause
}

info_procesador_detallada() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "        INFORMACIÓN DETALLADA DEL PROCESADOR"
    echo "==================================================="
    echo -e "${NC}"
    
    if [[ -f /proc/cpuinfo ]]; then
        echo -e "${YELLOW}■ INFORMACIÓN DEL CPU:${NC}"
        local model_name=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | sed 's/^ *//')
        local physical_cores=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
        local cores_per_cpu=$(grep "cpu cores" /proc/cpuinfo | head -1 | cut -d: -f2 | sed 's/^ *//')
        local total_cores=$((physical_cores * cores_per_cpu))
        local logical_cores=$(nproc)
        
        # Calcular hilos por núcleo de forma segura
        local threads_per_core=0
        if [[ $total_cores -gt 0 ]]; then
            threads_per_core=$((logical_cores / total_cores))
        fi
        
        echo "Modelo: $model_name"
        echo "Núcleos físicos: $total_cores"
        echo "Núcleos lógicos: $logical_cores"
        if [[ $threads_per_core -gt 0 ]]; then
            echo "Hilos por núcleo: $threads_per_core"
        else
            echo "Hilos por núcleo: N/A"
        fi
        echo "Sockets físicos: $physical_cores"
        
        echo -e "\n${YELLOW}■ FRECUENCIAS:${NC}"
        # Método para sistemas en español/inglés
        local min_freq=$(lscpu 2>/dev/null | grep -i "mhz mín\|min mhz" | cut -d: -f2 | sed 's/^ *//' | head -1 | cut -d, -f1)
        local max_freq=$(lscpu 2>/dev/null | grep -i "mhz máx\|max mhz" | cut -d: -f2 | sed 's/^ *//' | head -1 | cut -d, -f1)
        local current_freq=$(grep "cpu MHz" /proc/cpuinfo | head -1 | cut -d: -f2 | sed 's/^ *//' | cut -d. -f1)
        
        # Usar sysfs como respaldo (que sí funciona en tu sistema)
        if [[ -z "$min_freq" ]] && [[ -d /sys/devices/system/cpu/cpu0/cpufreq ]]; then
            min_freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq 2>/dev/null)
            min_freq=$((min_freq / 1000))
            max_freq=$(cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq 2>/dev/null)
            max_freq=$((max_freq / 1000))
        fi
        
        echo "Frecuencia actual: ${current_freq} MHz"
        echo "Frecuencia mínima: ${min_freq} MHz"
        echo "Frecuencia máxima: ${max_freq} MHz"
        
        echo -e "\n${YELLOW}■ CACHÉ:${NC}"
        # Obtener caché usando getconf (que sí funciona en tu sistema)
        local l1d=$(getconf LEVEL1_DCACHE_SIZE 2>/dev/null)
        local l1i=$(getconf LEVEL1_ICACHE_SIZE 2>/dev/null)
        local l2=$(getconf LEVEL2_CACHE_SIZE 2>/dev/null)
        local l3=$(getconf LEVEL3_CACHE_SIZE 2>/dev/null)
        
        # Convertir y formatear
        if [[ -n "$l1d" ]] && [[ $l1d -gt 0 ]]; then
            l1d=$((l1d / 1024))" KB"
        else
            l1d="N/A"
        fi
        
        if [[ -n "$l1i" ]] && [[ $l1i -gt 0 ]]; then
            l1i=$((l1i / 1024))" KB"
        else
            l1i="N/A"
        fi
        
        if [[ -n "$l2" ]] && [[ $l2 -gt 0 ]]; then
            if [[ $l2 -ge 1048576 ]]; then
                l2=$((l2 / 1024 / 1024))" MB"
            else
                l2=$((l2 / 1024))" KB"
            fi
        else
            l2="N/A"
        fi
        
        if [[ -n "$l3" ]] && [[ $l3 -gt 0 ]]; then
            if [[ $l3 -ge 1048576 ]]; then
                l3=$((l3 / 1024 / 1024))" MB"
            else
                l3=$((l3 / 1024))" KB"
            fi
        else
            l3="N/A"
        fi
        
        echo "Caché L1d: $l1d"
        echo "Caché L1i: $l1i"
        echo "Caché L2: $l2"
        echo "Caché L3: $l3"
        
    else
        error "No se pudo obtener información del procesador"
    fi
    
    echo -e "\n${YELLOW}■ ARQUITECTURA E INSTRUCCIONES:${NC}"
    # Información de arquitectura
    local architecture=$(lscpu 2>/dev/null | grep -i "architecture" | cut -d: -f2 | sed 's/^ *//')
    local virtualization=$(lscpu 2>/dev/null | grep -i "virtualization" | cut -d: -f2 | sed 's/^ *//')
    
    echo "Arquitectura: ${architecture:-N/A}"
    echo "Virtualización: ${virtualization:-N/A}"
    
    # Mostrar algunas flags importantes
    echo -e "\n${YELLOW}■ EXTENSIONES IMPORTANTES:${NC}"
    if [[ -f /proc/cpuinfo ]]; then
        local flags=$(grep "flags" /proc/cpuinfo | head -1 | cut -d: -f2)
        important_flags=("avx" "avx2" "sse" "sse2" "aes" "vmx" "svm" "ht" "hypervisor")
        for flag in "${important_flags[@]}"; do
            if echo "$flags" | grep -qi "$flag"; then
                echo -e "  ${GREEN}✓${NC} $flag"
            else
                echo -e "  ${RED}✗${NC} $flag"
            fi
        done
    fi
    
    echo -e "\n${YELLOW}■ ESTADO DE LOS NÚCLEOS:${NC}"
    # Mostrar estado de frecuencia de cada núcleo
    if [[ -d /sys/devices/system/cpu ]]; then
        echo "Núcleos online: $(cat /sys/devices/system/cpu/online 2>/dev/null || echo 'N/A')"
        echo "Núcleos posibles: $(cat /sys/devices/system/cpu/possible 2>/dev/null || echo 'N/A')"
        
        # Mostrar frecuencia actual de cada núcleo
        echo -e "\nFrecuencias por núcleo:"
        for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
            if [[ -f "$cpu/cpufreq/scaling_cur_freq" ]]; then
                cpu_num=$(basename "$cpu" | sed 's/cpu//')
                freq=$(cat "$cpu/cpufreq/scaling_cur_freq" 2>/dev/null)
                if [[ -n "$freq" ]] && [[ $freq -gt 0 ]]; then
                    freq=$((freq / 1000))
                    gov=$(cat "$cpu/cpufreq/scaling_governor" 2>/dev/null || echo "N/A")
                    echo "  CPU$cpu_num: ${freq} MHz [${gov}]"
                fi
            fi
        done | head -8
    fi
    
    pause
}

info_memoria_ram() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "           INFORMACIÓN DE MEMORIA RAM"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ MEMORIA PRINCIPAL:${NC}"
    free -h
    
    echo -e "\n${YELLOW}■ DETALLES DE LA MEMORIA:${NC}"
    if command -v dmidecode >/dev/null 2>&1; then
        echo "=== MEMORIA FÍSICA INSTALADA ==="
        sudo dmidecode --type memory 2>/dev/null | grep -E "(Size|Type|Speed|Manufacturer|Locator)" | grep -v "No Module" | head -20
    else
        warning "Instale 'dmidecode' para ver información detallada: sudo apt install dmidecode"
        echo "Información básica desde /proc/meminfo:"
        grep -E "(MemTotal|MemFree|MemAvailable|SwapTotal|SwapFree)" /proc/meminfo
    fi
    
    echo -e "\n${YELLOW}■ USO DE MEMORIA POR PROCESO (TOP 10):${NC}"
    ps aux --sort=-%mem | head -11 | awk '{printf "%-10s %-8s %-10s\n", $11, $2, $4}' | column -t
    
    pause
}

info_almacenamiento() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "          INFORMACIÓN DE ALMACENAMIENTO"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ UNIDADES CONECTADAS:${NC}"
    lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE,MODEL
    
    echo -e "\n${YELLOW}■ ESPACIO EN DISCOS:${NC}"
    df -h | grep -v tmpfs
    
    echo -e "\n${YELLOW}■ INFORMACIÓN DETALLADA:${NC}"
    for disk in $(lsblk -d -o NAME | grep -v NAME); do
        echo "=== DISCO: /dev/$disk ==="
        local model=$(lsblk -d -o MODEL /dev/$disk 2>/dev/null | tail -1)
        local size=$(lsblk -d -o SIZE /dev/$disk 2>/dev/null | tail -1)
        local type=$(lsblk -d -o TYPE /dev/$disk 2>/dev/null | tail -1)
        local transport=$(lsblk -d -o TRAN /dev/$disk 2>/dev/null | tail -1)
        
        echo "Modelo: $model"
        echo "Tamaño: $size"
        echo "Tipo: $type"
        echo "Interfaz: $transport"
        
        # Detectar tipo de almacenamiento
        if [[ "$transport" == "nvme" ]]; then
            echo "Tecnología: NVMe SSD"
        elif [[ "$transport" == "sata" ]]; then
            # Intentar detectar si es SSD o HDD
            if [[ -f /sys/block/$disk/queue/rotational ]]; then
                local rotational=$(cat /sys/block/$disk/queue/rotational 2>/dev/null)
                if [[ "$rotational" == "0" ]]; then
                    echo "Tecnología: SSD"
                else
                    echo "Tecnología: HDD"
                fi
            fi
        fi
        echo
    done
    
    echo -e "${YELLOW}■ USO DE ESPACIO EN /home:${NC}"
    if [[ -d /home ]]; then
        sudo du -h --max-depth=1 /home 2>/dev/null | sort -hr | head -10
    else
        echo "No se encontró el directorio /home"
    fi
    
    pause
}

info_hardware_completo() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "           INFORMACIÓN COMPLETA DE HARDWARE"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ RESUMEN DEL SISTEMA:${NC}"
    if command -v lshw >/dev/null 2>&1; then
        sudo lshw -short 2>/dev/null | head -20
    else
        warning "Instale 'lshw' para información completa: sudo apt install lshw"
        echo "Información básica disponible:"
        echo "CPU: $(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | sed 's/^ *//')"
        echo "Memoria: $(free -h | grep Mem | awk '{print $2}')"
        echo "Arquitectura: $(uname -m)"
    fi
    
    echo -e "\n${YELLOW}■ TARJETAS PCI:${NC}"
    lspci 2>/dev/null | head -15
    
    echo -e "\n${YELLOW}■ DISPOSITIVOS USB:${NC}"
    lsusb 2>/dev/null | head -10
    
    echo -e "\n${YELLOW}■ SENSORES DE TEMPERATURA:${NC}"
    if command -v sensors >/dev/null 2>&1; then
        sensors 2>/dev/null | head -10
    else
        echo "Instale 'lm-sensors': sudo apt install lm-sensors"
    fi
    
    pause
}

logs_inicios_sesion() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "           LOGS DE INICIOS DE SESIÓN"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ ÚLTIMOS INICIOS DE SESIÓN:${NC}"
    echo "=== ÚLTIMOS 20 REGISTROS ==="
    last -20
    
    echo -e "\n${YELLOW}■ SESIONES ACTUALES:${NC}"
    who
    
    echo -e "\n${YELLOW}■ INTENTOS DE LOGIN RECIENTES:${NC}"
    if [[ -f /var/log/auth.log ]]; then
        echo "=== ÚLTIMOS INTENTOS DE LOGIN ==="
        sudo grep -E "(session opened|session closed|authentication failure)" /var/log/auth.log 2>/dev/null | tail -15
    elif [[ -f /var/log/secure ]]; then
        sudo grep -E "(session opened|session closed|authentication failure)" /var/log/secure 2>/dev/null | tail -15
    else
        echo "No se encontraron logs de autenticación"
    fi
    
    pause
}

info_distribucion() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "           INFORMACIÓN DE LA DISTRIBUCIÓN"
    echo "==================================================="
    echo -e "${NC}"
    
    if [[ -f /etc/os-release ]]; then
        echo -e "${YELLOW}■ INFORMACIÓN DEL SISTEMA OPERATIVO:${NC}"
        source /etc/os-release
        echo "Nombre: $NAME"
        echo "Versión: $VERSION"
        echo "ID: $ID"
        echo "ID Like: $ID_LIKE"
        echo "Versión: $VERSION_ID"
        echo "Pretty Name: $PRETTY_NAME"
        echo "Home URL: $HOME_URL"
        echo "Support URL: $SUPPORT_URL"
        echo "Bug Report URL: $BUG_REPORT_URL"
    else
        error "No se pudo obtener información de la distribución"
    fi
    
    echo -e "\n${YELLOW}■ INFORMACIÓN DE ESCRITORIO:${NC}"
    echo "Session: $DESKTOP_SESSION"
    echo "DE: $XDG_CURRENT_DESKTOP"
    echo "Shell: $SHELL"
    
    echo -e "\n${YELLOW}■ VERSIÓN DEL SISTEMA:${NC}"
    if command -v lsb_release >/dev/null 2>&1; then
        lsb_release -a 2>/dev/null
    else
        echo "Instale 'lsb-release': sudo apt install lsb-release"
    fi
    
    pause
}

resumen_completo_sistema() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "           RESUMEN COMPLETO DEL SISTEMA"
    echo "==================================================="
    echo -e "${NC}"
    
    local resumen_file="/tmp/resumen_sistema_$(date +%H%M%S).log"
    
    echo "Generando resumen completo..."
    echo "=== RESUMEN COMPLETO DEL SISTEMA ===" > "$resumen_file"
    echo "Fecha: $(date)" >> "$resumen_file"
    echo "Usuario: $(whoami)" >> "$resumen_file"
    echo "Hostname: $(hostname)" >> "$resumen_file"
    
    echo -e "\n■ INFORMACIÓN BÁSICA:" >> "$resumen_file"
    echo "Kernel: $(uname -r)" >> "$resumen_file"
    echo "Arquitectura: $(uname -m)" >> "$resumen_file"
    echo "Tiempo activo: $(uptime -p)" >> "$resumen_file"
    
    echo -e "\n■ CPU:" >> "$resumen_file"
    grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | sed 's/^ *//' >> "$resumen_file"
    echo "Núcleos: $(nproc)" >> "$resumen_file"
    
    echo -e "\n■ MEMORIA:" >> "$resumen_file"
    free -h >> "$resumen_file"
    
    echo -e "\n■ ALMACENAMIENTO:" >> "$resumen_file"
    df -h >> "$resumen_file"
    
    echo -e "\n■ DISTRIBUCIÓN:" >> "$resumen_file"
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        echo "$PRETTY_NAME" >> "$resumen_file"
    fi
    
    success "Resumen guardado en: $resumen_file"
    echo -e "\n${YELLOW}Contenido del resumen:${NC}"
    cat "$resumen_file"
    
    pause
}

# =========================================
# DIAGNÓSTICO DE RED - SECCIÓN PRINCIPAL
# =========================================

menu_diagnostico_red() {
    while true; do
        clear
        echo -e "${CYAN}"
        echo "==================================================="
        echo "              DIAGNÓSTICO DE RED"
        echo "==================================================="
        echo -e "${NC}"
        
        echo "1)  Información de interfaces de red"
        echo "2)  Test de conectividad básica"
        echo "3)  Test de velocidad de red"
        echo "4)  Análisis de puertos"
        echo "5)  Diagnóstico completo de red"
        echo "6)  Estadísticas de red"
        echo "7)  Configuración DNS"
        echo "8)  Flush DNS y reinicio de red"
        echo
        echo "0)  VOLVER AL MENÚ PRINCIPAL"
        echo
        
        read -p "Seleccione una opción [0-8]: " opcion
        
        case $opcion in
            1) info_interfaces_red ;;
            2) test_conectividad_basica ;;
            3) test_velocidad_red ;;
            4) analisis_puertos ;;
            5) diagnostico_completo_red ;;
            6) estadisticas_red ;;
            7) configuracion_dns ;;
            8) flush_dns_red ;;
            0) return ;;
            *) 
                error "Opción no válida: $opcion"
                pause 
                ;;
        esac
    done
}

# =========================================
# FUNCIONES DE DIAGNÓSTICO DE RED
# =========================================

info_interfaces_red() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "           INFORMACIÓN DE INTERFACES DE RED"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ INTERFACES DE RED DETECTADAS:${NC}"
    ip addr show
    
    echo -e "\n${YELLOW}■ TABLA DE RUTAS:${NC}"
    ip route show
    
    echo -e "\n${YELLOW}■ INFORMACIÓN DE CONEXIÓN ACTUAL:${NC}"
    # Detectar tipo de conexión (WiFi/LAN)
    local default_interface=$(ip route | grep default | awk '{print $5}' | head -1)
    if [[ -n "$default_interface" ]]; then
        echo "Interfaz por defecto: $default_interface"
        
        # Detectar si es WiFi o Ethernet
        if [[ -d "/sys/class/net/$default_interface/wireless" ]]; then
            echo "Tipo de conexión: WiFi"
            # Información de señal WiFi si está disponible
            if command -v iwconfig >/dev/null 2>&1; then
                iwconfig "$default_interface" 2>/dev/null | grep -E "(ESSID|Signal|Frequency)"
            fi
        else
            echo "Tipo de conexión: Ethernet/LAN"
        fi
        
        # Dirección IP pública
        echo -e "\n${YELLOW}■ DIRECCIÓN IP PÚBLICA:${NC}"
        local public_ip=$(curl -s ifconfig.me 2>/dev/null || curl -s icanhazip.com 2>/dev/null || echo "No se pudo obtener")
        echo "IP Pública: $public_ip"
    else
        error "No se detectó interfaz de red activa"
    fi
    
    echo -e "\n${YELLOW}■ CONEXIONES DE RED ACTIVAS:${NC}"
    ss -tun | head -20
    
    pause
}

test_conectividad_basica() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "              TEST DE CONECTIVIDAD BÁSICA"
    echo "==================================================="
    echo -e "${NC}"
    
    local test_servers=(
        "8.8.8.8 Google DNS"
        "1.1.1.1 Cloudflare DNS" 
        "208.67.222.222 OpenDNS"
        "google.com Google"
        "cloudflare.com Cloudflare"
        "github.com GitHub"
    )
    
    echo -e "${YELLOW}■ TEST DE PING A SERVIDORES:${NC}"
    local exitosos=0
    local total=0
    
    for server in "${test_servers[@]}"; do
        local ip=$(echo "$server" | awk '{print $1}')
        local nombre=$(echo "$server" | awk '{print $2}')
        total=$((total + 1))
        
        echo -n "Probando $nombre ($ip)... "
        if ping -c 2 -W 2 "$ip" >/dev/null 2>&1; then
            echo -e "${GREEN}✓ CONECTADO${NC}"
            exitosos=$((exitosos + 1))
        else
            echo -e "${RED}✗ SIN CONEXIÓN${NC}"
        fi
    done
    
    echo -e "\n${YELLOW}■ RESULTADO:${NC}"
    local porcentaje=$((exitosos * 100 / total))
    echo "Conexiones exitosas: $exitosos/$total ($porcentaje%)"
    
    # Test de resolución DNS
    echo -e "\n${YELLOW}■ TEST DE RESOLUCIÓN DNS:${NC}"
    if nslookup google.com >/dev/null 2>&1; then
        echo -e "${GREEN}✓ DNS funcionando correctamente${NC}"
    else
        echo -e "${RED}✗ Error en resolución DNS${NC}"
    fi
    
    # Test de conectividad HTTP
    echo -e "\n${YELLOW}■ TEST DE CONECTIVIDAD HTTP:${NC}"
    if curl -s --head http://www.google.com >/dev/null 2>&1; then
        echo -e "${GREEN}✓ Conexión HTTP funcionando${NC}"
    else
        echo -e "${RED}✗ Error en conexión HTTP${NC}"
    fi
    
    pause
}

test_velocidad_red() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "              TEST DE VELOCIDAD DE RED"
    echo "==================================================="
    echo -e "${NC}"
    
    # Detectar tipo de conexión primero
    local default_interface=$(ip route | grep default | awk '{print $5}' | head -1)
    if [[ -n "$default_interface" ]]; then
        if [[ -d "/sys/class/net/$default_interface/wireless" ]]; then
            echo -e "${YELLOW}■ TIPO DE CONEXIÓN: WiFi ($default_interface)${NC}"
        else
            echo -e "${YELLOW}■ TIPO DE CONEXIÓN: Ethernet/LAN ($default_interface)${NC}"
        fi
    fi
    
    echo -e "\n${YELLOW}■ INFORMACIÓN DE VELOCIDAD DE INTERFAZ:${NC}"
    if [[ -n "$default_interface" ]]; then
        # Mostrar velocidad de la interfaz
        if [[ -f "/sys/class/net/$default_interface/speed" ]]; then
            local speed=$(cat "/sys/class/net/$default_interface/speed" 2>/dev/null)
            if [[ -n "$speed" ]] && [[ $speed -gt 0 ]]; then
                echo "Velocidad negociada: ${speed} Mbps"
            fi
        fi
        
        # Mostrar estadísticas de la interfaz
        echo -e "\nEstadísticas de la interfaz:"
        cat "/sys/class/net/$default_interface/statistics/rx_bytes" 2>/dev/null | awk '{printf "Datos recibidos: %.2f MB\n", $1/1024/1024}'
        cat "/sys/class/net/$default_interface/statistics/tx_bytes" 2>/dev/null | awk '{printf "Datos enviados: %.2f MB\n", $1/1024/1024}'
    fi
    
    echo -e "\n${YELLOW}■ TEST DE VELOCIDAD CON speedtest-cli:${NC}"
    if command -v speedtest-cli >/dev/null 2>&1; then
        echo "Ejecutando test de velocidad (esto puede tomar 30-60 segundos)..."
        speedtest-cli --simple
    else
        warning "speedtest-cli no está instalado."
        echo "Para instalar: sudo apt install speedtest-cli"
        
        # Test alternativo simple con ping y descarga
        echo -e "\n${YELLOW}■ TEST ALTERNATIVO DE LATENCIA:${NC}"
        echo "Latencia a Google DNS:"
        ping -c 4 8.8.8.8 | grep "min/avg/max"
    fi
    
    # Test de velocidad de descarga simple
    echo -e "\n${YELLOW}■ TEST SIMPLE DE DESCARGA:${NC}"
    echo "Descargando archivo de prueba (10MB)..."
    local start_time=$(date +%s)
    if curl -s -o /dev/null http://speedtest.ftp.otenet.gr/files/test10Mb.db 2>/dev/null; then
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        if [[ $duration -gt 0 ]]; then
            local speed=$((10000 / duration))  # 10MB en KB/s
            echo "Velocidad aproximada: ${speed} KB/s"
        fi
    else
        echo "No se pudo realizar el test de descarga"
    fi
    
    pause
}

analisis_puertos() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "                 ANÁLISIS DE PUERTOS"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ PUERTOS ABIERTOS LOCALES:${NC}"
    echo "=== PUERTOS ESCUCHANDO (LISTENING) ==="
    if command -v ss >/dev/null 2>&1; then
        ss -tulpn | grep LISTEN
    else
        netstat -tulpn | grep LISTEN
    fi
    
    echo -e "\n${YELLOW}■ CONEXIONES ESTABLECIDAS:${NC}"
    if command -v ss >/dev/null 2>&1; then
        ss -tupn | grep ESTAB | head -20
    else
        netstat -tupn | grep ESTAB | head -20
    fi
    
    echo -e "\n${YELLOW}■ ESCANEO DE PUERTOS COMUNES:${NC}"
    local common_ports=("22:SSH" "23:Telnet" "53:DNS" "80:HTTP" "443:HTTPS" "21:FTP" "25:SMTP" "110:POP3" "143:IMAP" "993:IMAPS" "995:POP3S" "3306:MySQL" "5432:PostgreSQL" "3389:RDP" "5900:VNC")
    
    local host="localhost"
    echo "Escaneando puertos comunes en $host..."
    
    for port_info in "${common_ports[@]}"; do
        local port=$(echo "$port_info" | cut -d: -f1)
        local service=$(echo "$port_info" | cut -d: -f2)
        
        if timeout 1 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null; then
            echo -e "  Puerto $port ($service): ${GREEN}ABIERTO${NC}"
        else
            echo -e "  Puerto $port ($service): ${RED}CERRADO${NC}"
        fi
    done
    
    echo -e "\n${YELLOW}■ INFORMACIÓN DE SERVICIOS:${NC}"
    echo "Servicios activos en puertos:"
    if command -v ss >/dev/null 2>&1; then
        ss -tulpn | awk '/LISTEN/ {print $5 " - " $7}' | head -15
    else
        netstat -tulpn | awk '/LISTEN/ {print $4 " - " $7}' | head -15
    fi
    
    pause
}

diagnostico_completo_red() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "           DIAGNÓSTICO COMPLETO DE RED"
    echo "==================================================="
    echo -e "${NC}"
    
    local log_file="/tmp/diagnostico_red_completo_$(date +%H%M%S).log"
    
    echo "Ejecutando diagnóstico completo de red..."
    echo "Esto puede tomar unos momentos..."
    
    echo "=== DIAGNÓSTICO COMPLETO DE RED ===" > "$log_file"
    echo "Fecha: $(date)" >> "$log_file"
    echo "Usuario: $(whoami)" >> "$log_file"
    echo "Hostname: $(hostname)" >> "$log_file"
    
    echo -e "\n${YELLOW}■ EJECUTANDO PRUEBAS...${NC}"
    
    # 1. Información de interfaces
    echo -e "\n1. INFORMACIÓN DE INTERFACES:" >> "$log_file"
    ip addr show >> "$log_file"
    
    # 2. Tabla de rutas
    echo -e "\n2. TABLA DE RUTAS:" >> "$log_file"
    ip route show >> "$log_file"
    
    # 3. Puertos abiertos
    echo -e "\n3. PUERTOS ABIERTOS:" >> "$log_file"
    if command -v ss >/dev/null 2>&1; then
        ss -tulpn >> "$log_file"
    else
        netstat -tulpn >> "$log_file"
    fi
    
    # 4. Test de conectividad
    echo -e "\n4. TEST DE CONECTIVIDAD:" >> "$log_file"
    local test_hosts=("8.8.8.8" "google.com" "1.1.1.1")
    for host in "${test_hosts[@]}"; do
        echo "Probando $host..." >> "$log_file"
        ping -c 2 "$host" >> "$log_file" 2>&1
        echo "" >> "$log_file"
    done
    
    # 5. DNS
    echo -e "\n5. CONFIGURACIÓN DNS:" >> "$log_file"
    cat /etc/resolv.conf >> "$log_file" 2>/dev/null || echo "No se pudo leer /etc/resolv.conf" >> "$log_file"
    
    # 6. Estadísticas
    echo -e "\n6. ESTADÍSTICAS DE RED:" >> "$log_file"
    if command -v ss >/dev/null 2>&1; then
        ss -s >> "$log_file"
    else
        netstat -s >> "$log_file"
    fi
    
    success "Diagnóstico completo guardado en: $log_file"
    
    echo -e "\n${YELLOW}■ RESUMEN DEL DIAGNÓSTICO:${NC}"
    echo "Interfaces de red: $(ip addr show | grep -c "state UP") activas"
    echo "Puertos abiertos: $(ss -tulpn 2>/dev/null | grep -c LISTEN)"
    echo "Conexiones establecidas: $(ss -tun 2>/dev/null | grep -c ESTAB)"
    
    # Verificar conectividad a internet
    if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        echo -e "Conectividad a Internet: ${GREEN}✓ ACTIVA${NC}"
    else
        echo -e "Conectividad a Internet: ${RED}✗ INACTIVA${NC}"
    fi
    
    echo -e "\nPuede ver el reporte completo con: cat $log_file"
    pause
}

estadisticas_red() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "               ESTADÍSTICAS DE RED"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ ESTADÍSTICAS GENERALES:${NC}"
    if command -v ss >/dev/null 2>&1; then
        ss -s
    else
        netstat -s
    fi
    
    echo -e "\n${YELLOW}■ ESTADÍSTICAS DE INTERFACES:${NC}"
    for interface in /sys/class/net/*; do
        iface=$(basename "$interface")
        if [[ "$iface" != "lo" ]]; then
            echo "=== Interfaz: $iface ==="
            rx_bytes=$(cat "$interface/statistics/rx_bytes" 2>/dev/null || echo "0")
            tx_bytes=$(cat "$interface/statistics/tx_bytes" 2>/dev/null || echo "0")
            echo "  Recibido: $(echo "scale=2; $rx_bytes/1024/1024" | bc) MB"
            echo "  Enviado: $(echo "scale=2; $tx_bytes/1024/1024" | bc) MB"
        fi
    done
    
    echo -e "\n${YELLOW}■ CONEXIONES POR PROTOCOLO:${NC}"
    if command -v ss >/dev/null 2>&1; then
        echo "TCP: $(ss -t | wc -l) conexiones"
        echo "UDP: $(ss -u | wc -l) conexiones"
    else
        echo "TCP: $(netstat -t | wc -l) conexiones"
        echo "UDP: $(netstat -u | wc -l) conexiones"
    fi
    
    pause
}

configuracion_dns() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "               CONFIGURACIÓN DNS"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ CONFIGURACIÓN ACTUAL DNS:${NC}"
    if [[ -f /etc/resolv.conf ]]; then
        echo "Archivo /etc/resolv.conf:"
        cat /etc/resolv.conf
    else
        echo "No se encontró /etc/resolv.conf"
    fi
    
    echo -e "\n${YELLOW}■ SERVICIOS DNS ACTIVOS:${NC}"
    if systemctl is-active systemd-resolved >/dev/null 2>&1; then
        echo "systemd-resolved: ACTIVO"
        echo "Configuración:"
        systemd-resolve --status | grep "DNS Servers" | head -5
    elif systemctl is-active NetworkManager >/dev/null 2>&1; then
        echo "NetworkManager: ACTIVO"
    else
        echo "No se detectó servicio DNS activo"
    fi
    
    echo -e "\n${YELLOW}■ TEST DE RESOLUCIÓN DNS:${NC}"
    local test_domains=("google.com" "github.com" "ubuntu.com" "microsoft.com")
    for domain in "${test_domains[@]}"; do
        echo -n "Resolviendo $domain... "
        if nslookup "$domain" >/dev/null 2>&1; then
            echo -e "${GREEN}✓ OK${NC}"
        else
            echo -e "${RED}✗ ERROR${NC}"
        fi
    done
    
    echo -e "\n${YELLOW}■ DNS ALTERNATIVOS RECOMENDADOS:${NC}"
    echo "1.1.1.1 - Cloudflare"
    echo "8.8.8.8 - Google"
    echo "9.9.9.9 - Quad9"
    echo "208.67.222.222 - OpenDNS"
    
    pause
}

flush_dns_red() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "           FLUSH DNS Y REINICIO DE RED"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ LIMPIANDO CACHE DNS...${NC}"
    
    # Método 1: systemd-resolved (nuevo: resolvectl, viejo: systemd-resolve)
    if systemctl is-active systemd-resolved >/dev/null 2>&1; then
        # Intentar con resolvectl (sistemas más nuevos)
        if command -v resolvectl >/dev/null 2>&1; then
            sudo resolvectl flush-caches
            if [[ $? -eq 0 ]]; then
                echo -e "systemd-resolved (resolvectl): ${GREEN}Cache limpiado${NC}"
            fi
        # Intentar con systemd-resolve (sistemas más viejos)
        elif command -v systemd-resolve >/dev/null 2>&1; then
            sudo systemd-resolve --flush-caches
            if [[ $? -eq 0 ]]; then
                echo -e "systemd-resolved (systemd-resolve): ${GREEN}Cache limpiado${NC}"
            fi
        else
            echo -e "systemd-resolved: ${YELLOW}No se encontró comando flush${NC}"
        fi
    fi
    
    # Método 2: nscd
    if systemctl is-active nscd >/dev/null 2>&1; then
        sudo systemctl restart nscd
        echo -e "nscd: ${GREEN}Reiniciado${NC}"
    fi
    
    # Método 3: Limpiar cache local
    sudo rm -f /etc/resolv.conf 2>/dev/null
    sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf 2>/dev/null
    
    echo -e "\n${YELLOW}■ REINICIANDO SERVICIOS DE RED...${NC}"
    
    # Reiniciar servicios de red
    if sudo systemctl restart NetworkManager 2>/dev/null; then
        echo -e "NetworkManager: ${GREEN}Reiniciado${NC}"
    elif sudo systemctl restart networking 2>/dev/null; then
        echo -e "Servicio networking: ${GREEN}Reiniciado${NC}"
    elif sudo systemctl restart systemd-networkd 2>/dev/null; then
        echo -e "systemd-networkd: ${GREEN}Reiniciado${NC}"
    else
        echo -e "Servicios de red: ${YELLOW}No se pudieron reiniciar automáticamente${NC}"
    fi
    
    echo -e "\n${YELLOW}■ ESPERANDO ESTABILIZACIÓN DE RED...${NC}"
    echo "Esperando 10 segundos para que la red se restablezca..."
    
    # Contador regresivo con puntos progresivos
    for i in {1..10}; do
        echo -n "."
        sleep 1
    done
    echo ""  # Nueva línea después del contador
    
    echo -e "\n${YELLOW}■ VERIFICANDO CONEXIÓN...${NC}"
    
    # Verificación más robusta
    local conexion_ok=0
    local test_servers=("8.8.8.8" "1.1.1.1" "google.com")
    
    for server in "${test_servers[@]}"; do
        if ping -c 1 -W 3 "$server" >/dev/null 2>&1; then
            conexion_ok=1
            break
        fi
    done
    
    if [[ $conexion_ok -eq 1 ]]; then
        echo -e "Conectividad: ${GREEN}✓ RESTAURADA${NC}"
        
        # Verificación adicional de DNS
        if nslookup google.com >/dev/null 2>&1; then
            echo -e "Resolución DNS: ${GREEN}✓ FUNCIONANDO${NC}"
        else
            echo -e "Resolución DNS: ${YELLOW}⚠ CON PROBLEMAS${NC}"
        fi
    else
        echo -e "Conectividad: ${RED}✗ PROBLEMAS PERSISTENTES${NC}"
        echo -e "${YELLOW}Sugerencia: Espere unos minutos o reinicie el equipo${NC}"
    fi
    
    success "Operaciones de red completadas"
    pause
}

# =========================================
# DIAGNÓSTICO DE ALMACENAMIENTO - SECCIÓN PRINCIPAL
# =========================================

menu_diagnostico_almacenamiento() {
    while true; do
        clear
        echo -e "${CYAN}"
        echo "==================================================="
        echo "          DIAGNÓSTICO DE ALMACENAMIENTO"
        echo "==================================================="
        echo -e "${NC}"
        
        echo "1)  Información de unidades de almacenamiento"
        echo "2)  Test de velocidad de lectura/escritura"
        echo "3)  Estado SMART de discos"
        echo "4)  Análisis de espacio en disco"
        echo "5)  Diagnóstico completo de almacenamiento"
        echo "6)  Información de particiones"
        echo "7)  Estado de filesystems"
        echo "8)  Benchmark de IO"
        echo
        echo "0)  VOLVER AL MENÚ PRINCIPAL"
        echo
        
        read -p "Seleccione una opción [0-8]: " opcion
        
        case $opcion in
            1) info_unidades_almacenamiento ;;
            2) test_velocidad_lectura_escritura ;;
            3) estado_smart_discos ;;
            4) analisis_espacio_disco ;;
            5) diagnostico_completo_almacenamiento ;;
            6) info_particiones ;;
            7) estado_filesystems ;;
            8) benchmark_io ;;
            0) return ;;
            *) 
                error "Opción no válida: $opcion"
                pause 
                ;;
        esac
    done
}

# =========================================
# FUNCIONES DE DIAGNÓSTICO DE ALMACENAMIENTO
# =========================================

info_unidades_almacenamiento() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "       INFORMACIÓN DE UNIDADES DE ALMACENAMIENTO"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ UNIDADES DETECTADAS:${NC}"
    lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE,MODEL,TRAN
    
    echo -e "\n${YELLOW}■ DETALLES POR UNIDAD:${NC}"
    for disk in $(lsblk -d -o NAME | grep -v NAME); do
        echo "=== DISCO: /dev/$disk ==="
        
        # Información básica
        local model=$(lsblk -d -o MODEL /dev/$disk 2>/dev/null | tail -1 | sed 's/^ *//')
        local size=$(lsblk -d -o SIZE /dev/$disk 2>/dev/null | tail -1)
        local type=$(lsblk -d -o TYPE /dev/$disk 2>/dev/null | tail -1)
        local transport=$(lsblk -d -o TRAN /dev/$disk 2>/dev/null | tail -1)
        local vendor=$(cat /sys/block/$disk/device/vendor 2>/dev/null | sed 's/^ *//' || echo "Desconocido")
        
        echo "Modelo: $model"
        echo "Fabricante: $vendor"
        echo "Tamaño: $size"
        echo "Tipo: $type"
        echo "Interfaz: $transport"
        
        # Detectar tipo de almacenamiento
        if [[ "$transport" == "nvme" ]]; then
            echo "Tecnología: ${GREEN}NVMe SSD${NC}"
        elif [[ "$transport" == "sata" || "$transport" == "ata" ]]; then
            # Detectar si es SSD o HDD
            if [[ -f /sys/block/$disk/queue/rotational ]]; then
                local rotational=$(cat /sys/block/$disk/queue/rotational 2>/dev/null)
                if [[ "$rotational" == "0" ]]; then
                    echo "Tecnología: ${GREEN}SSD${NC}"
                else
                    echo "Tecnología: ${YELLOW}HDD${NC}"
                fi
            else
                echo "Tecnología: Desconocida"
            fi
        elif [[ "$transport" == "usb" ]]; then
            echo "Tecnología: ${BLUE}USB${NC}"
        fi
        
        # Información de particiones para este disco
        echo "Particiones:"
        lsblk -o NAME,SIZE,MOUNTPOINT,FSTYPE /dev/$disk | grep -v "NAME" | while read line; do
            echo "  $line"
        done
        
        echo ""
    done
    
    echo -e "${YELLOW}■ ESPACIO EN DISCOS MONTADOS:${NC}"
    df -h | grep -v tmpfs
    
    pause
}

test_velocidad_lectura_escritura() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "       TEST DE VELOCIDAD LECTURA/ESCRITURA"
    echo "==================================================="
    echo -e "${NC}"
    
    # Seleccionar disco para test
    echo -e "${YELLOW}■ DISCOS DISPONIBLES PARA TEST:${NC}"
    lsblk -d -o NAME,SIZE,MODEL,TRAN | grep -v "NAME"
    
    echo ""
    read -p "Ingrese el disco a probar (ej: sda, nvme0n1): " disco_test
    
    if [[ -z "$disco_test" ]] || [[ ! -b "/dev/$disco_test" ]]; then
        error "Disco /dev/$disco_test no válido o no existe"
        pause
        return
    fi
    
    # Detectar tipo de almacenamiento
    local tipo_almacenamiento="Desconocido"
    local transport=$(lsblk -d -o TRAN /dev/$disco_test 2>/dev/null | tail -1)
    
    if [[ "$transport" == "nvme" ]]; then
        tipo_almacenamiento="NVMe SSD"
    elif [[ "$transport" == "sata" || "$transport" == "ata" ]]; then
        if [[ -f /sys/block/$disco_test/queue/rotational ]]; then
            local rotational=$(cat /sys/block/$disco_test/queue/rotational 2>/dev/null)
            if [[ "$rotational" == "0" ]]; then
                tipo_almacenamiento="SSD"
            else
                tipo_almacenamiento="HDD"
            fi
        fi
    fi
    
    echo -e "\n${YELLOW}■ INFORMACIÓN DEL DISCO:${NC}"
    echo "Disco: /dev/$disco_test"
    echo "Tipo: $tipo_almacenamiento"
    echo "Modelo: $(lsblk -d -o MODEL /dev/$disco_test 2>/dev/null | tail -1)"
    
    echo -e "\n${YELLOW}■ TEST DE VELOCIDAD DE LECTURA (hdparm):${NC}"
    if command -v hdparm >/dev/null 2>&1; then
        echo "Ejecutando test de lectura... (puede tomar 1-2 minutos)"
        sudo hdparm -Tt /dev/$disco_test
    else
        warning "hdparm no está instalado."
        echo "Para instalar: sudo apt install hdparm"
    fi
    
    echo -e "\n${YELLOW}■ TEST DE VELOCIDAD CON DD (escritura):${NC}"
    echo "Este test creará un archivo temporal de 1GB"
    read -p "¿Continuar? [s/N]: " confirmar_dd
    
    if [[ $confirmar_dd =~ ^[Ss]$ ]]; then
        local test_file="/tmp/test_velocidad_$disco_test.dat"
        echo "Ejecutando test de escritura..."
        
        # Test de escritura
        local start_time=$(date +%s)
        dd if=/dev/zero of="$test_file" bs=1M count=1024 oflag=direct 2>&1 | tail -1
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        
        if [[ $duration -gt 0 ]]; then
            local speed_mb=$((1024 / duration))
            echo -e "Velocidad de escritura: ${GREEN}${speed_mb} MB/s${NC}"
        fi
        
        # Test de lectura
        echo -e "\nEjecutando test de lectura..."
        local start_time=$(date +%s)
        dd if="$test_file" of=/dev/null bs=1M 2>&1 | tail -1
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        
        if [[ $duration -gt 0 ]]; then
            local speed_mb=$((1024 / duration))
            echo -e "Velocidad de lectura: ${GREEN}${speed_mb} MB/s${NC}"
        fi
        
        # Limpiar
        rm -f "$test_file"
        echo "Archivo temporal eliminado"
    else
        echo "Test de escritura cancelado"
    fi
    
    echo -e "\n${YELLOW}■ RESULTADOS ESPERADOS POR TIPO:${NC}"
    echo "HDD: 80-160 MB/s"
    echo "SSD SATA: 200-550 MB/s" 
    echo "NVMe SSD: 1500-7000 MB/s"
    
    pause
}

estado_smart_discos() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "             ESTADO SMART DE DISCOS"
    echo "==================================================="
    echo -e "${NC}"
    
    if ! command -v smartctl >/dev/null 2>&1; then
        warning "smartmontools no está instalado."
        echo "Para instalar: sudo apt install smartmontools"
        echo -e "\n¿Desea instalarlo ahora? [s/N]: "
        read -p "" instalar_smart
        if [[ $instalar_smart =~ ^[Ss]$ ]]; then
            sudo apt update && sudo apt install -y smartmontools
        else
            pause
            return
        fi
    fi
    
    echo -e "${YELLOW}■ DISCOS CON SMART DISPONIBLE:${NC}"
    
    local discos_con_smart=0
    
    for disk in $(lsblk -d -o NAME | grep -v NAME); do
        if [[ -b "/dev/$disk" ]]; then
            echo -n "Verificando /dev/$disk... "
            if sudo smartctl -i /dev/$disk 2>/dev/null | grep -q "SMART support is: Available"; then
                echo -e "${GREEN}SMART DISPONIBLE${NC}"
                discos_con_smart=$((discos_con_smart + 1))
                
                # Información básica SMART
                echo "=== INFORMACIÓN SMART /dev/$disk ==="
                sudo smartctl -i /dev/$disk 2>/dev/null | grep -E "(Model Family|Device Model|Serial Number|User Capacity|Sector Size)" | head -10
                
                # Salud del disco
                echo -n "Salud del disco: "
                if sudo smartctl -H /dev/$disk 2>/dev/null | grep -q "PASSED"; then
                    echo -e "${GREEN}✓ OK${NC}"
                else
                    echo -e "${RED}✗ PROBLEMAS${NC}"
                fi
                
                # Atributos importantes
                echo "Atributos clave:"
                sudo smartctl -A /dev/$disk 2>/dev/null | grep -E "(Reallocated_Sector|Power_On_Hours|Temperature|Uncorrectable_Errors)" | head -5
                echo ""
            else
                echo -e "${YELLOW}SMAR NO SOPORTADO${NC}"
            fi
        fi
    done
    
    if [[ $discos_con_smart -eq 0 ]]; then
        echo "No se encontraron discos con soporte SMART"
    fi
    
    echo -e "\n${YELLOW}■ INTERPRETACIÓN DE ATRIBUTOS SMART:${NC}"
    echo "Reallocated_Sector_Ct: Sectores reasignados (0 es ideal)"
    echo "Power_On_Hours: Horas de uso del disco"
    echo "Temperature_Celsius: Temperatura actual"
    echo "Uncorrectable_Errors: Errores no corregibles (0 es ideal)"
    
    pause
}

analisis_espacio_disco() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "             ANÁLISIS DE ESPACIO EN DISCO"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ ESPACIO GENERAL:${NC}"
    df -h
    
    echo -e "\n${YELLOW}■ ESPACIO POR SISTEMA DE ARCHIVOS:${NC}"
    for mountpoint in $(df -h | awk 'NR>1 {print $6}'); do
        if [[ "$mountpoint" != "/dev" ]] && [[ "$mountpoint" != "/run" ]] && [[ "$mountpoint" != "/sys" ]]; then
            echo "=== $mountpoint ==="
            # Encontrar las carpetas más grandes
            sudo du -h --max-depth=1 "$mountpoint" 2>/dev/null | sort -hr | head -10
            echo ""
        fi
    done
    
    echo -e "${YELLOW}■ CARPETAS MÁS GRANDES EN /:${NC}"
    sudo du -h --max-depth=1 / 2>/dev/null | sort -hr | head -15 | while read line; do
        echo "  $line"
    done
    
    echo -e "\n${YELLOW}■ ARCHIVOS MÁS GRANDES EN /home:${NC}"
    if [[ -d /home ]]; then
        find /home -type f -exec du -h {} + 2>/dev/null | sort -hr | head -10 | while read line; do
            echo "  $line"
        done
    fi
    
    echo -e "\n${YELLOW}■ INODOS DISPONIBLES:${NC}"
    df -i | grep -v tmpfs
    
    pause
}

diagnostico_completo_almacenamiento() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "       DIAGNÓSTICO COMPLETO DE ALMACENAMIENTO"
    echo "==================================================="
    echo -e "${NC}"
    
    local log_file="/tmp/diagnostico_almacenamiento_$(date +%H%M%S).log"
    
    echo "Ejecutando diagnóstico completo de almacenamiento..."
    echo "Esto puede tomar unos momentos..."
    
    echo "=== DIAGNÓSTICO COMPLETO DE ALMACENAMIENTO ===" > "$log_file"
    echo "Fecha: $(date)" >> "$log_file"
    echo "Usuario: $(whoami)" >> "$log_file"
    echo "Hostname: $(hostname)" >> "$log_file"
    
    echo -e "\n${YELLOW}■ EJECUTANDO PRUEBAS...${NC}"
    
    # 1. Información de discos
    echo -e "\n1. INFORMACIÓN DE DISCOS:" >> "$log_file"
    lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE,MODEL,TRAN >> "$log_file"
    
    # 2. Espacio en disco
    echo -e "\n2. ESPACIO EN DISCO:" >> "$log_file"
    df -h >> "$log_file"
    
    # 3. Información SMART (si está disponible)
    echo -e "\n3. INFORMACIÓN SMART:" >> "$log_file"
    if command -v smartctl >/dev/null 2>&1; then
        for disk in $(lsblk -d -o NAME | grep -v NAME); do
            echo "=== /dev/$disk ===" >> "$log_file"
            sudo smartctl -i /dev/$disk 2>/dev/null | head -20 >> "$log_file"
            echo "" >> "$log_file"
        done
    else
        echo "smartctl no disponible" >> "$log_file"
    fi
    
    # 4. Filesystems montados
    echo -e "\n4. FILESYSTEMS MONTADOS:" >> "$log_file"
    mount | grep -E "(ext4|xfs|btrfs|ntfs|vfat)" >> "$log_file"
    
    # 5. Uso de inodos
    echo -e "\n5. USO DE INODOS:" >> "$log_file"
    df -i >> "$log_file"
    
    success "Diagnóstico completo guardado en: $log_file"
    
    echo -e "\n${YELLOW}■ RESUMEN DEL DIAGNÓSTICO:${NC}"
    echo "Discos detectados: $(lsblk -d | grep -c disk)"
    echo "Particiones: $(lsblk | grep -c part)"
    echo "Espacio total: $(df -h --total | grep total | awk '{print $2}')"
    echo "Espacio usado: $(df -h --total | grep total | awk '{print $3}')"
    echo "Espacio libre: $(df -h --total | grep total | awk '{print $4}')"
    
    echo -e "\nPuede ver el reporte completo con: cat $log_file"
    pause
}

info_particiones() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "            INFORMACIÓN DE PARTICIONES"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ TABLA DE PARTICIONES:${NC}"
    sudo fdisk -l 2>/dev/null | grep -E "(Disk /dev|/dev/.*)" | head -20
    
    echo -e "\n${YELLOW}■ DETALLES DE PARTICIONES:${NC}"
    for disk in $(lsblk -d -o NAME | grep -v NAME); do
        echo "=== DISCO /dev/$disk ==="
        lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,LABEL,UUID /dev/$disk
        echo ""
    done
    
    echo -e "${YELLOW}■ INFORMACIÓN CON parted:${NC}"
    if command -v parted >/dev/null 2>&1; then
        for disk in $(lsblk -d -o NAME | grep -v NAME); do
            echo "--- /dev/$disk ---"
            sudo parted /dev/$disk print 2>/dev/null | grep -E "(Sector size|Partition Table|Number)" | head -10
        done
    else
        echo "parted no está instalado"
    fi
    
    pause
}

estado_filesystems() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "             ESTADO DE FILESYSTEMS"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ FILESYSTEMS MONTADOS:${NC}"
    mount | grep -E "(ext4|xfs|btrfs|ntfs|vfat)" | sort
    
    echo -e "\n${YELLOW}■ INFORMACIÓN DE FILESYSTEMS:${NC}"
    for fs in $(df -T | awk 'NR>1 {print $2}' | sort | uniq); do
        echo "=== $fs ==="
        df -T | grep "$fs" | wc -l | awk '{print "Sistemas montados: " $1}'
        case $fs in
            "ext4")
                echo "Características: Journaling, extensos, estable"
                ;;
            "xfs")
                echo "Características: Alto rendimiento, escalabilidad"
                ;;
            "btrfs")
                echo "Características: Copy-on-write, snapshots, compresión"
                ;;
            "ntfs")
                echo "Características: Windows, grandes archivos"
                ;;
            "vfat")
                echo "Características: Compatibilidad, dispositivos USB"
                ;;
        esac
        echo ""
    done
    
    echo -e "${YELLOW}■ VERIFICACIÓN DE INTEGRIDAD:${NC}"
    echo "Para verificar filesystems, ejecute manualmente:"
    echo "  sudo fsck -n /dev/sdX1  # Solo verificación"
    echo "  sudo fsck -y /dev/sdX1  # Verificación y reparación"
    echo ""
    echo "NOTA: Los filesystems deben estar desmontados para fsck"
    
    pause
}

benchmark_io() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "                 BENCHMARK DE IO"
    echo "==================================================="
    echo -e "${NC}"
    
    if ! command -v ioping >/dev/null 2>&1; then
        warning "ioping no está instalado."
        echo "Para instalar: sudo apt install ioping"
        echo -e "\n¿Desea instalarlo ahora? [s/N]: "
        read -p "" instalar_ioping
        if [[ $instalar_ioping =~ ^[Ss]$ ]]; then
            sudo apt update && sudo apt install -y ioping
        else
            echo "Continuando con tests básicos..."
        fi
    fi
    
    echo -e "${YELLOW}■ TEST DE LATENCIA DE E/S:${NC}"
    
    # Test de latencia con ioping si está disponible
    if command -v ioping >/dev/null 2>&1; then
        echo "Ejecutando test de latencia..."
        sudo ioping -c 10 /
    else
        echo "Usando test alternativo con dd..."
        # Test simple de latencia
        local test_file="/tmp/io_test.dat"
        echo "Creando archivo de test..."
        dd if=/dev/zero of="$test_file" bs=512 count=1000 oflag=direct 2>/dev/null
        
        echo "Test de escritura pequeña:"
        dd if=/dev/zero of="$test_file" bs=512 count=1000 oflag=direct 2>&1 | grep "copied"
        
        echo "Test de lectura pequeña:"
        dd if="$test_file" of=/dev/null bs=512 2>&1 | grep "copied"
        
        rm -f "$test_file"
    fi
    
    echo -e "\n${YELLOW}■ TEST DE RENDIMIENTO ALEATORIO:${NC}"
    if command -v fio >/dev/null 2>&1; then
        echo "Ejecutando test con fio..."
        fio --name=randread --ioengine=libaio --iodepth=32 --rw=randread --bs=4k --direct=1 --size=64M --numjobs=4 --runtime=10 --group_reporting
    else
        echo "fio no está instalado. Para tests avanzados:"
        echo "sudo apt install fio"
    fi
    
    echo -e "\n${YELLOW}■ INTERPRETACIÓN DE RESULTADOS:${NC}"
    echo "Latencia < 1ms: Excelente (SSD/NVMe)"
    echo "Latencia 1-10ms: Bueno (SSD/HDD rápido)"
    echo "Latencia > 10ms: Regular (HDD lento)"
    echo "IOPS altos: Buen rendimiento para cargas de trabajo"
    
    pause
}

# =========================================
# GESTIÓN DE USUARIOS - SECCIÓN PRINCIPAL
# =========================================

menu_gestion_usuarios() {
    while true; do
        clear
        echo -e "${CYAN}"
        echo "==================================================="
        echo "              GESTIÓN DE USUARIOS"
        echo "==================================================="
        echo -e "${NC}"
        
        echo "1)  Listar usuarios del sistema"
        echo "2)  Información detallada de usuarios"
        echo "3)  Crear nuevo usuario"
        echo "4)  Eliminar usuario"
        echo "5)  Modificar contraseña de usuario"
        echo "6)  Ver grupos del sistema"
        echo "7)  Ver sesiones activas"
        echo "8)  Auditoría de seguridad de usuarios"
        echo
        echo "0)  VOLVER AL MENÚ PRINCIPAL"
        echo
        
        read -p "Seleccione una opción [0-8]: " opcion
        
        case $opcion in
            1) listar_usuarios_sistema ;;
            2) info_detallada_usuarios ;;
            3) crear_nuevo_usuario ;;
            4) eliminar_usuario ;;
            5) modificar_password_usuario ;;
            6) ver_grupos_sistema ;;
            7) ver_sesiones_activas ;;
            8) auditoria_seguridad_usuarios ;;
            0) return ;;
            *) 
                error "Opción no válida: $opcion"
                pause 
                ;;
        esac
    done
}

# =========================================
# FUNCIONES DE GESTIÓN DE USUARIOS
# =========================================

listar_usuarios_sistema() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "            LISTAR USUARIOS DEL SISTEMA"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ USUARIOS DEL SISTEMA:${NC}"
    echo "=== USUARIOS CON CUENTA DE LOGIN ==="
    # Usuarios con shell válida (excluyendo system users)
    awk -F: '$3 >= 1000 && $3 <= 60000 && $7 != "/usr/sbin/nologin" && $7 != "/bin/false" {print $1 " (UID: " $3 ")"}' /etc/passwd
    
    echo -e "\n${YELLOW}■ USUARIOS DEL SISTEMA (SERVICIOS):${NC}"
    # Usuarios de sistema (UID < 1000)
    awk -F: '$3 < 1000 {print $1 " (UID: " $3 ")"}' /etc/passwd | head -15
    
    echo -e "\n${YELLOW}■ INFORMACIÓN DE USUARIOS CONECTADOS:${NC}"
    echo "Usuarios actualmente logueados:"
    who
    
    echo -e "\n${YELLOW}■ TOTALES:${NC}"
    local total_usuarios=$(awk -F: '$3 >= 1000 && $3 <= 60000' /etc/passwd | wc -l)
    local total_sistema=$(awk -F: '$3 < 1000' /etc/passwd | wc -l)
    echo "Usuarios normales: $total_usuarios"
    echo "Usuarios de sistema: $total_sistema"
    
    pause
}

info_detallada_usuarios() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "        INFORMACIÓN DETALLADA DE USUARIOS"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ SELECCIONAR USUARIO PARA VER DETALLES:${NC}"
    
    # Mostrar usuarios disponibles
    local usuarios=($(awk -F: '$3 >= 1000 && $3 <= 60000 && $7 != "/usr/sbin/nologin" {print $1}' /etc/passwd))
    
    if [[ ${#usuarios[@]} -eq 0 ]]; then
        error "No se encontraron usuarios normales en el sistema"
        pause
        return
    fi
    
    echo "Usuarios disponibles:"
    for i in "${!usuarios[@]}"; do
        echo "$((i+1))) ${usuarios[$i]}"
    done
    
    echo ""
    read -p "Seleccione un usuario (número) o Enter para todos: " seleccion
    
    if [[ -z "$seleccion" ]]; then
        # Mostrar información de todos los usuarios
        for usuario in "${usuarios[@]}"; do
            mostrar_info_usuario "$usuario"
        done
    else
        # Mostrar información del usuario seleccionado
        if [[ $seleccion -ge 1 ]] && [[ $seleccion -le ${#usuarios[@]} ]]; then
            local usuario_seleccionado="${usuarios[$((seleccion-1))]}"
            mostrar_info_usuario "$usuario_seleccionado"
        else
            error "Selección inválida"
        fi
    fi
    
    pause
}

mostrar_info_usuario() {
    local usuario=$1
    
    echo -e "\n${YELLOW}=== INFORMACIÓN DE USUARIO: $usuario ===${NC}"
    
    # Información básica
    local user_info=$(getent passwd "$usuario")
    if [[ -n "$user_info" ]]; then
        IFS=':' read -r -a user_data <<< "$user_info"
        echo "Usuario: ${user_data[0]}"
        echo "UID: ${user_data[2]}"
        echo "GID: ${user_data[3]}"
        echo "Directorio home: ${user_data[5]}"
        echo "Shell: ${user_data[6]}"
        
        # Información de grupos
        echo -e "\nGrupos:"
        groups "$usuario" 2>/dev/null || echo "No se pudieron obtener los grupos"
        
        # Información de password
        local passwd_info=$(getent shadow "$usuario" 2>/dev/null)
        if [[ -n "$passwd_info" ]]; then
            IFS=':' read -r -a passwd_data <<< "$passwd_info"
            echo -e "\nInformación de password:"
            echo "Último cambio: ${passwd_data[2]}"
            echo "Días hasta cambio: ${passwd_data[3]:-0}"
            echo "Días de aviso: ${passwd_data[4]:-0}"
            echo "Días de expiración: ${passwd_data[5]:-0}"
        fi
        
        # Información de login
        echo -e "\nÚltimos logins:"
        last -5 "$usuario" 2>/dev/null | head -5
        
        # Espacio en home
        if [[ -d "${user_data[5]}" ]]; then
            echo -e "\nEspacio en home:"
            du -sh "${user_data[5]}" 2>/dev/null || echo "No se pudo calcular"
        fi
    else
        echo "Usuario no encontrado: $usuario"
    fi
}

crear_nuevo_usuario() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "               CREAR NUEVO USUARIO"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ INFORMACIÓN PARA CREAR USUARIO:${NC}"
    
    read -p "Nombre de usuario: " nuevo_usuario
    
    if [[ -z "$nuevo_usuario" ]]; then
        error "El nombre de usuario no puede estar vacío"
        pause
        return
    fi
    
    # Verificar si el usuario ya existe
    if id "$nuevo_usuario" &>/dev/null; then
        error "El usuario '$nuevo_usuario' ya existe"
        pause
        return
    fi
    
    read -p "Directorio home (por defecto /home/$nuevo_usuario): " home_dir
    home_dir=${home_dir:-"/home/$nuevo_usuario"}
    
    read -p "Shell (por defecto /bin/bash): " user_shell
    user_shell=${user_shell:-"/bin/bash"}
    
    echo -e "\n${YELLOW}■ CONFIRMACIÓN:${NC}"
    echo "Usuario: $nuevo_usuario"
    echo "Directorio home: $home_dir"
    echo "Shell: $user_shell"
    echo ""
    
    read -p "¿Crear el usuario? [s/N]: " confirmar
    
    if [[ $confirmar =~ ^[Ss]$ ]]; then
        echo "Creando usuario..."
        
        # Crear usuario
        if sudo useradd -m -d "$home_dir" -s "$user_shell" "$nuevo_usuario"; then
            success "Usuario '$nuevo_usuario' creado exitosamente"
            
            # Establecer contraseña
            echo -e "\n${YELLOW}■ ESTABLECER CONTRASEÑA:${NC}"
            sudo passwd "$nuevo_usuario"
            
            echo -e "\n${YELLOW}■ USUARIO CREADO CON ÉXITO:${NC}"
            echo "Para ver información del usuario, use la opción 2 del menú"
        else
            error "Error al crear el usuario '$nuevo_usuario'"
        fi
    else
        echo "Creación de usuario cancelada"
    fi
    
    pause
}

eliminar_usuario() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "               ELIMINAR USUARIO"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ USUARIOS DISPONIBLES:${NC}"
    
    local usuarios=($(awk -F: '$3 >= 1000 && $3 <= 60000 && $7 != "/usr/sbin/nologin" {print $1}' /etc/passwd))
    
    if [[ ${#usuarios[@]} -eq 0 ]]; then
        error "No se encontraron usuarios para eliminar"
        pause
        return
    fi
    
    for i in "${!usuarios[@]}"; do
        echo "$((i+1))) ${usuarios[$i]}"
    done
    
    echo ""
    read -p "Seleccione el usuario a eliminar (número): " seleccion
    
    if [[ $seleccion -ge 1 ]] && [[ $seleccion -le ${#usuarios[@]} ]]; then
        local usuario_eliminar="${usuarios[$((seleccion-1))]}"
        
        echo -e "\n${YELLOW}■ USUARIO SELECCIONADO: $usuario_eliminar${NC}"
        
        # Mostrar información del usuario
        mostrar_info_usuario "$usuario_eliminar"
        
        echo -e "\n${RED}■ ADVERTENCIA: ESTA ACCIÓN NO SE PUEDE DESHACER${NC}"
        echo "Opciones de eliminación:"
        echo "1) Eliminar solo el usuario"
        echo "2) Eliminar usuario y directorio home"
        echo "3) Eliminar usuario, home y archivos de mail"
        
        read -p "Seleccione opción de eliminación [1-3]: " opcion_eliminar
        
        case $opcion_eliminar in
            1)
                echo "Eliminando solo el usuario..."
                if sudo userdel "$usuario_eliminar"; then
                    success "Usuario '$usuario_eliminar' eliminado (home preservado)"
                else
                    error "Error al eliminar el usuario"
                fi
                ;;
            2)
                echo "Eliminando usuario y directorio home..."
                if sudo userdel -r "$usuario_eliminar"; then
                    success "Usuario '$usuario_eliminar' y directorio home eliminados"
                else
                    error "Error al eliminar el usuario y home"
                fi
                ;;
            3)
                echo "Eliminando usuario, home y archivos de mail..."
                if sudo userdel -r -f "$usuario_eliminar"; then
                    success "Usuario '$usuario_eliminar' eliminado completamente"
                else
                    error "Error al eliminar el usuario completamente"
                fi
                ;;
            *)
                error "Opción de eliminación inválida"
                ;;
        esac
    else
        error "Selección inválida"
    fi
    
    pause
}

modificar_password_usuario() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "          MODIFICAR CONTRASEÑA DE USUARIO"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ USUARIOS DISPONIBLES:${NC}"
    
    local usuarios=($(awk -F: '$3 >= 1000 && $3 <= 60000 && $7 != "/usr/sbin/nologin" {print $1}' /etc/passwd))
    
    if [[ ${#usuarios[@]} -eq 0 ]]; then
        error "No se encontraron usuarios"
        pause
        return
    fi
    
    for i in "${!usuarios[@]}"; do
        echo "$((i+1))) ${usuarios[$i]}"
    done
    
    echo ""
    read -p "Seleccione el usuario para cambiar contraseña (número): " seleccion
    
    if [[ $seleccion -ge 1 ]] && [[ $seleccion -le ${#usuarios[@]} ]]; then
        local usuario_password="${usuarios[$((seleccion-1))]}"
        
        echo -e "\n${YELLOW}■ CAMBIANDO CONTRASEÑA PARA: $usuario_password${NC}"
        
        # Cambiar contraseña
        sudo passwd "$usuario_password"
        
        if [[ $? -eq 0 ]]; then
            success "Contraseña modificada exitosamente para '$usuario_password'"
        else
            error "Error al modificar la contraseña"
        fi
    else
        error "Selección inválida"
    fi
    
    pause
}

ver_grupos_sistema() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "              VER GRUPOS DEL SISTEMA"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ GRUPOS DEL SISTEMA:${NC}"
    echo "=== GRUPOS PRINCIPALES ==="
    getent group | awk -F: '$3 >= 1000 && $3 <= 60000' | head -20
    
    echo -e "\n${YELLOW}■ GRUPOS DE SISTEMA:${NC}"
    getent group | awk -F: '$3 < 1000' | head -15
    
    echo -e "\n${YELLOW}■ GRUPOS CON MÁS USUARIOS:${NC}"
    getent group | awk -F: '{print $1 ":" $4}' | awk -F: '{print $1 " - " NF-1 " usuarios"}' | sort -t- -k2 -nr | head -10
    
    echo -e "\n${YELLOW}■ INFORMACIÓN DE GRUPOS ESPECIALES:${NC}"
    grupos_especiales=("sudo" "adm" "wheel" "docker" "libvirt")
    for grupo in "${grupos_especiales[@]}"; do
        if getent group "$grupo" &>/dev/null; then
            echo "=== Grupo $grupo ==="
            getent group "$grupo"
        fi
    done
    
    pause
}

ver_sesiones_activas() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "              VER SESIONES ACTIVAS"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ SESIONES ACTUALES:${NC}"
    echo "=== USUARIOS CONECTADOS ==="
    who -u
    
    echo -e "\n${YELLOW}■ ÚLTIMOS INICIOS DE SESIÓN:${NC}"
    last -10
    
    echo -e "\n${YELLOW}■ PROCESOS DE USUARIOS:${NC}"
    echo "=== TOP 10 PROCESOS POR USUARIO ==="
    ps -eo user,pid,%cpu,%mem,comm --sort=-%cpu | head -15
    
    echo -e "\n${YELLOW}■ USUARIOS CON SESIONES ABIERTAS:${NC}"
    for user in $(who | awk '{print $1}' | sort -u); do
        echo "=== Usuario: $user ==="
        echo "Terminales: $(who | grep "^$user" | wc -l)"
        echo "Procesos: $(ps -u "$user" | wc -l)"
        echo ""
    done
    
    pause
}

auditoria_seguridad_usuarios() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "         AUDITORÍA DE SEGURIDAD DE USUARIOS"
    echo "==================================================="
    echo -e "${NC}"
    
    local log_file="/tmp/auditoria_usuarios_$(date +%H%M%S).log"
    
    echo "Ejecutando auditoría de seguridad de usuarios..."
    
    echo "=== AUDITORÍA DE SEGURIDAD DE USUARIOS ===" > "$log_file"
    echo "Fecha: $(date)" >> "$log_file"
    echo "Auditor: $(whoami)" >> "$log_file"
    
    echo -e "\n${YELLOW}■ EJECUTANDO VERIFICACIONES...${NC}"
    
    # 1. Usuarios sin password
    echo -e "\n1. USUARIOS SIN PASSWORD:" >> "$log_file"
    sudo awk -F: '($2 == "" || $2 == "!") {print $1}' /etc/shadow >> "$log_file" 2>/dev/null
    
    # 2. Usuarios con UID 0 (potenciales riesgos)
    echo -e "\n2. USUARIOS CON UID 0:" >> "$log_file"
    awk -F: '$3 == 0 {print $1}' /etc/passwd >> "$log_file"
    
    # 3. Usuarios con shell peligrosas
    echo -e "\n3. USUARIOS CON SHELLS PELIGROSAS:" >> "$log_file"
    awk -F: '$7 == "/bin/sh" || $7 == "/bin/dash" || $7 == "/bin/tcsh" {print $1 " - " $7}' /etc/passwd >> "$log_file"
    
    # 4. Usuarios en grupo sudo
    echo -e "\n4. USUARIOS EN GRUPO SUDO:" >> "$log_file"
    getent group sudo | awk -F: '{print $4}' >> "$log_file"
    
    # 5. Usuarios con home no estándar
    echo -e "\n5. USUARIOS CON HOME NO ESTÁNDAR:" >> "$log_file"
    awk -F: '($6 !~ /^\/home\//) && ($3 >= 1000) {print $1 " - " $6}' /etc/passwd >> "$log_file"
    
    # 6. Últimos logins fallidos
    echo -e "\n6. ÚLTIMOS LOGINS FALLIDOS:" >> "$log_file"
    sudo lastb -10 2>/dev/null >> "$log_file" || echo "No se pudieron obtener logins fallidos" >> "$log_file"
    
    success "Auditoría completada y guardada en: $log_file"
    
    echo -e "\n${YELLOW}■ RESUMEN DE AUDITORÍA:${NC}"
    echo "Usuarios sin password: $(sudo awk -F: '($2 == "" || $2 == "!") {print $1}' /etc/shadow 2>/dev/null | wc -l)"
    echo "Usuarios con UID 0: $(awk -F: '$3 == 0 {print $1}' /etc/passwd | wc -l)"
    echo "Usuarios en grupo sudo: $(getent group sudo | awk -F: '{print $4}' | tr ',' '\n' | wc -l)"
    
    echo -e "\n${YELLOW}■ RECOMENDACIONES DE SEGURIDAD:${NC}"
    echo "• Todos los usuarios deben tener contraseña"
    echo "• Solo usuarios necesarios en grupo sudo"
    echo "• Shell por defecto debería ser /bin/bash"
    echo "• Directorios home deben estar en /home/"
    
    echo -e "\nPuede ver el reporte completo con: cat $log_file"
    pause
}

# =========================================
# MANTENIMIENTO - SECCIÓN PRINCIPAL
# =========================================

menu_mantenimiento() {
    while true; do
        clear
        echo -e "${CYAN}"
        echo "==================================================="
        echo "                 MANTENIMIENTO"
        echo "==================================================="
        echo -e "${NC}"
        
        echo "1)  Limpieza del sistema"
        echo "2)  Actualización del sistema"
        echo "3)  Reparación de paquetes"
        echo "4)  Liberación de memoria"
        echo "5)  Optimización de discos"
        echo "6)  Limpieza de logs"
        echo "7)  Verificación de integridad"
        echo "8)  Mantenimiento completo automático"
        echo
        echo "0)  VOLVER AL MENÚ PRINCIPAL"
        echo
        
        read -p "Seleccione una opción [0-8]: " opcion
        
        case $opcion in
            1) limpieza_sistema ;;
            2) actualizacion_sistema ;;
            3) reparacion_paquetes ;;
            4) liberacion_memoria ;;
            5) optimizacion_discos ;;
            6) limpieza_logs ;;
            7) verificacion_integridad ;;
            8) mantenimiento_completo_automatico ;;
            0) return ;;
            *) 
                error "Opción no válida: $opcion"
                pause 
                ;;
        esac
    done
}

# =========================================
# FUNCIONES DE MANTENIMIENTO
# =========================================

limpieza_sistema() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "               LIMPIEZA DEL SISTEMA"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ INICIANDO LIMPIEZA DEL SISTEMA...${NC}"
    
    # 1. Limpiar cache de APT
    echo -e "\n${YELLOW}1. LIMPIANDO CACHE DE APT...${NC}"
    sudo apt clean
    sudo apt autoclean
    success "Cache de APT limpiado"
    
    # 2. Remover paquetes innecesarios
    echo -e "\n${YELLOW}2. ELIMINANDO PAQUETES INNECESARIOS...${NC}"
    sudo apt autoremove -y
    sudo apt autopurge -y
    success "Paquetes innecesarios eliminados"
    
    # 3. Limpiar archivos temporales
    echo -e "\n${YELLOW}3. LIMPIANDO ARCHIVOS TEMPORALES...${NC}"
    sudo rm -rf /tmp/* 2>/dev/null
    sudo rm -rf /var/tmp/* 2>/dev/null
    rm -rf ~/.cache/* 2>/dev/null
    rm -rf ~/.local/share/Trash/* 2>/dev/null
    success "Archivos temporales eliminados"
    
    # 4. Limpiar thumbnails
    echo -e "\n${YELLOW}4. LIMPIANDO THUMBNAILS...${NC}"
    rm -rf ~/.cache/thumbnails/* 2>/dev/null
    success "Thumbnails eliminados"
    
    # 5. Limpiar logs antiguos
    echo -e "\n${YELLOW}5. LIMPIANDO LOGS ANTIGUOS...${NC}"
    sudo find /var/log -name "*.log" -type f -mtime +30 -exec truncate -s 0 {} \; 2>/dev/null
    sudo find /var/log -name "*.gz" -type f -mtime +30 -delete 2>/dev/null
    sudo journalctl --vacuum-time=7d 2>/dev/null
    success "Logs antiguos limpiados"
    
    # 6. LIMPIEZA SEGURA DE PAQUETES (VERSIÓN CORREGIDA)
echo -e "\n${YELLOW}6. LIMPIEZA SEGURA DE PAQUETES...${NC}"

# SOLO limpieza básica - NUNCA --purge automático
echo "Ejecutando limpieza básica de paquetes..."
sudo apt autoremove -y
sudo apt autoclean

# Información sobre paquetes huérfanos (solo visual - NO elimina)
if command -v deborphan >/dev/null 2>&1; then
    local orphan_info=$(deborphan 2>/dev/null)
    if [[ -n "$orphan_info" ]]; then
        echo -e "\n${YELLOW}■ INFORMACIÓN: Paquetes potencialmente huérfanos${NC}"
        echo "$orphan_info"
        echo -e "\n${CYAN}NOTA: Esta es solo información. Para eliminación manual segura, verifique cada paquete.${NC}"
    else
        echo "No se encontraron paquetes huérfanos"
    fi
else
    echo "Para ver paquetes huérfanos (solo informativo): sudo apt install deborphan"
fi

success "Limpieza segura completada"
    pause
}

actualizacion_sistema() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "            ACTUALIZACIÓN DEL SISTEMA"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ INICIANDO ACTUALIZACIÓN DEL SISTEMA...${NC}"
    
    # 1. Actualizar lista de paquetes
    echo -e "\n${YELLOW}1. ACTUALIZANDO LISTA DE PAQUETES...${NC}"
    sudo apt update
    success "Lista de paquetes actualizada"
    
    # 2. Mostrar actualizaciones disponibles
    echo -e "\n${YELLOW}2. ACTUALIZACIONES DISPONIBLES:${NC}"
    apt list --upgradable 2>/dev/null | head -20
    
    local updates_count=$(apt list --upgradable 2>/dev/null | wc -l)
    updates_count=$((updates_count - 1))
    
    if [[ $updates_count -gt 0 ]]; then
        echo -e "\nHay $updates_count actualizaciones disponibles"
        read -p "¿Continuar con la actualización? [s/N]: " confirmar_actualizacion
        
        if [[ $confirmar_actualizacion =~ ^[Ss]$ ]]; then
            # 3. Actualizar paquetes
            echo -e "\n${YELLOW}3. ACTUALIZANDO PAQUETES...${NC}"
            sudo apt upgrade -y
            success "Paquetes actualizados"
            
            # 4. Actualización de distribución (si está disponible)
            echo -e "\n${YELLOW}4. VERIFICANDO ACTUALIZACIONES DE DISTRIBUCIÓN...${NC}"
            if sudo apt dist-upgrade -y --dry-run | grep -q "upgraded"; then
                read -p "¿Actualizar distribución? [s/N]: " confirmar_dist_upgrade
                if [[ $confirmar_dist_upgrade =~ ^[Ss]$ ]]; then
                    sudo apt dist-upgrade -y
                    success "Distribución actualizada"
                fi
            else
                echo "No hay actualizaciones de distribución disponibles"
            fi
            
            # 5. Actualizar snaps (si están instalados)
            if command -v snap >/dev/null 2>&1; then
                echo -e "\n${YELLOW}5. ACTUALIZANDO SNAPS...${NC}"
                sudo snap refresh
                success "Snaps actualizados"
            fi
            
            # 6. Actualizar flatpaks (si están instalados)
            if command -v flatpak >/dev/null 2>&1; then
                echo -e "\n${YELLOW}6. ACTUALIZANDO FLATPAKS...${NC}"
                # Verificar si hay flatpaks instalados primero
                if flatpak list &>/dev/null 2>&1; then
                    # Verificar si hay actualizaciones disponibles antes de ejecutar
                    echo "Verificando actualizaciones de flatpaks..."
                    if flatpak remote-ls --updates &>/dev/null; then
                        echo "Actualizando flatpaks..."
                        flatpak update -y --noninteractive
                        success "Flatpaks actualizados"
                    else
                        echo "No hay actualizaciones de flatpaks disponibles"
                    fi
                else
                    echo "No hay flatpaks instalados"
                fi
            fi
        else
            echo "Actualización cancelada por el usuario"
        fi
    else
        echo -e "\n${GREEN}El sistema está actualizado${NC}"
    fi
    
    success "Proceso de actualización completado"
    pause
}

reparacion_paquetes() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "             REPARACIÓN DE PAQUETES"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ INICIANDO REPARACIÓN DE PAQUETES...${NC}"
    
    # 1. Reparar dependencias
    echo -e "\n${YELLOW}1. REPARANDO DEPENDENCIAS...${NC}"
    sudo dpkg --configure -a
    success "Configuración de paquetes completada"
    
    # 2. Reparar paquetes rotos
    echo -e "\n${YELLOW}2. REPARANDO PAQUETES ROTOS...${NC}"
    sudo apt install -f -y
    success "Paquetes rotos reparados"
    
    # 3. Verificar integridad de paquetes
    echo -e "\n${YELLOW}3. VERIFICANDO INTEGRIDAD DE PAQUETES...${NC}"
    if sudo dpkg -l | grep -q "^rc"; then
        echo "Paquetes residuales encontrados:"
        sudo dpkg -l | grep "^rc"
        read -p "¿Limpiar paquetes residuales? [s/N]: " limpiar_residuales
        if [[ $limpiar_residuales =~ ^[Ss]$ ]]; then
            sudo dpkg -P $(dpkg -l | grep "^rc" | awk '{print $2}')
            success "Paquetes residuales eliminados"
        fi
    else
        echo "No se encontraron paquetes residuales"
    fi
    
    # 4. Reinstalar paquetes críticos
    echo -e "\n${YELLOW}4. VERIFICANDO PAQUETES CRÍTICOS...${NC}"
    paquetes_criticos=("apt" "dpkg" "base-files" "bash" "coreutils")
    for paquete in "${paquetes_criticos[@]}"; do
        if dpkg -l | grep -q "ii  $paquete"; then
            echo "✓ $paquete está correcto"
        else
            echo "✗ $paquete necesita atención"
            sudo apt install --reinstall -y "$paquete"
        fi
    done
    
    # 5. Verificar repositorios
    echo -e "\n${YELLOW}5. VERIFICANDO REPOSITORIOS...${NC}"
    if sudo apt update 2>&1 | grep -q "Failed"; then
        echo "Problemas con repositorios detectados"
        echo "Revise /etc/apt/sources.list"
    else
        echo "Repositorios funcionando correctamente"
    fi
    
    success "Reparación de paquetes completada"
    pause
}

liberacion_memoria() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "             LIBERACIÓN DE MEMORIA"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ ESTADO ACTUAL DE MEMORIA:${NC}"
    free -h
    
    echo -e "\n${YELLOW}■ INICIANDO LIBERACIÓN DE MEMORIA...${NC}"
    
    # 1. Sincronizar sistemas de archivos
    echo -e "\n${YELLOW}1. SINCRONIZANDO SISTEMAS DE ARCHIVOS...${NC}"
    sudo sync
    success "Sistemas de archivos sincronizados"
    
    # 2. Liberar cache de página
    echo -e "\n${YELLOW}2. LIBERANDO CACHE DE PÁGINA...${NC}"
    echo 1 | sudo tee /proc/sys/vm/drop_caches > /dev/null
    success "Cache de página liberado"
    
    # 3. Liberar dentries e inodos
    echo -e "\n${YELLOW}3. LIBERANDO DENTRIES E INODOS...${NC}"
    echo 2 | sudo tee /proc/sys/vm/drop_caches > /dev/null
    success "Dentries e inodos liberados"
    
    # 4. Liberar pagecache, dentries e inodos
    echo -e "\n${YELLOW}4. LIBERACIÓN COMPLETA...${NC}"
    echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null
    success "Liberación completa realizada"
    
    # 5. Limpiar swap
    echo -e "\n${YELLOW}5. LIMPIANDO SWAP...${NC}"
    sudo swapoff -a && sudo swapon -a
    success "Swap limpiado"
    
    echo -e "\n${YELLOW}■ ESTADO FINAL DE MEMORIA:${NC}"
    free -h
    
    echo -e "\n${YELLOW}■ INFORMACIÓN ADICIONAL:${NC}"
    echo "Memoria liberada temporalmente"
    echo "El cache se reconstruirá automáticamente"
    echo "Recomendado después de actualizaciones grandes"
    
    success "Liberación de memoria completada"
    pause
}

optimizacion_discos() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "             OPTIMIZACIÓN DE DISCOS"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ INICIANDO OPTIMIZACIÓN DE DISCOS...${NC}"
    
    # 1. Optimizar sistemas de archivos ext4
    echo -e "\n${YELLOW}1. OPTIMIZANDO SISTEMAS DE ARCHIVOS EXT4...${NC}"
    for mountpoint in $(mount | grep "type ext4" | awk '{print $3}'); do
        echo "Optimizando: $mountpoint"
        sudo sync
        sudo fstrim "$mountpoint" 2>/dev/null
    done
    success "Sistemas ext4 optimizados"
    
    # 2. Optimizar sistemas de archivos SSD
    echo -e "\n${YELLOW}2. OPTIMIZANDO DISCOS SSD...${NC}"
    for disk in $(lsblk -d -o NAME,ROTA | grep "0" | awk '{print $1}'); do
        if [[ -b "/dev/$disk" ]]; then
            echo "Optimizando SSD: /dev/$disk"
            sudo fstrim / 2>/dev/null
        fi
    done
    success "SSDs optimizados"
    
    # 3. Limpiar journal de systemd
    echo -e "\n${YELLOW}3. LIMPIANDO JOURNAL...${NC}"
    sudo journalctl --vacuum-size=500M
    success "Journal limpiado"
    
    # 4. Optimizar base de datos de paquetes
    echo -e "\n${YELLOW}4. OPTIMIZANDO BASE DE DATOS DE PAQUETES...${NC}"
    if command -v apt-file >/dev/null 2>&1; then
        sudo apt-file update
    fi
    success "Base de datos optimizada"
    
    # 5. Reconstruir cache de fuentes
    echo -e "\n${YELLOW}5. RECONSTRUYENDO CACHE DE FUENTES...${NC}"
    sudo fc-cache -f -v
    success "Cache de fuentes reconstruido"
    
    # 6. Actualizar base de datos locate
    echo -e "\n${YELLOW}6. ACTUALIZANDO BASE DE DATOS LOCATE...${NC}"
    if command -v updatedb >/dev/null 2>&1; then
        sudo updatedb
        success "Base de datos locate actualizada"
    else
        echo "mlocate no instalado"
    fi
    
    echo -e "\n${YELLOW}■ RECOMENDACIONES:${NC}"
    echo "• Ejecutar trim semanalmente para SSDs"
    echo "• Monitorear espacio en /var/log/"
    echo "• Mantener sistema actualizado"
    
    success "Optimización de discos completada"
    pause
}

limpieza_logs() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "               LIMPIEZA DE LOGS SEGURA"
    echo "==================================================="
    echo -e "${NC}"

    echo -e "${YELLOW}■ ESPACIO ACTUAL EN /VAR/LOG:${NC}"
    df -h /var/log

    echo -e "\n${YELLOW}■ INICIANDO LIMPIEZA SEGURA DE LOGS...${NC}"

    # 1. Limpiar logs antiguos CON CRITERIOS DE SEGURIDAD
    echo -e "\n${YELLOW}1. LIMPIANDO LOGS ANTIGUOS (MÁS DE 30 DÍAS)...${NC}"

    # Mostrar qué se va a eliminar primero
    echo "Archivos .log que serán limpiados:"
    sudo find /var/log -name "*.log" -type f -mtime +30 -ls 2>/dev/null | head -10

    local total_logs=$(sudo find /var/log -name "*.log" -type f -mtime +30 2>/dev/null | wc -l)

    if [[ $total_logs -gt 0 ]]; then
        echo -e "\nTotal de archivos .log antiguos: $total_logs"
        read -p "¿Continuar con la limpieza? [s/N]: " confirmar_limpieza

        if [[ $confirmar_limpieza =~ ^[Ss]$ ]]; then
            sudo find /var/log -name "*.log" -type f -mtime +30 -exec truncate -s 0 {} \; 2>/dev/null
            success "Logs antiguos limpiados (truncados, no eliminados)"
        else
            echo "Limpieza de logs cancelada"
        fi
    else
        echo "No se encontraron logs antiguos para limpiar"
    fi

    # 2. Eliminar logs comprimidos antiguos (más seguros que eliminar .log)
    echo -e "\n${YELLOW}2. ELIMINANDO LOGS COMPRIMIDOS ANTIGUOS...${NC}"
    local logs_comprimidos=$(sudo find /var/log -name "*.gz" -type f -mtime +30 2>/dev/null | wc -l)

    if [[ $logs_comprimidos -gt 0 ]]; then
        echo "Archivos .gz antiguos encontrados: $logs_comprimidos"
        read -p "¿Eliminar logs comprimidos antiguos? [s/N]: " confirmar_gz

        if [[ $confirmar_gz =~ ^[Ss]$ ]]; then
            sudo find /var/log -name "*.gz" -type f -mtime +30 -delete 2>/dev/null
            success "Logs comprimidos antiguos eliminados"
        fi
    else
        echo "No se encontraron logs comprimidos antiguos"
    fi

    # 3. Limpiar journal CON LÍMITES SEGUROS
    echo -e "\n${YELLOW}3. LIMPIANDO JOURNAL (CONSERVANDO 100MB)...${NC}"
    sudo journalctl --vacuum-size=100M
    success "Journal limpiado (se conservan 100MB)"

    # 4. Limpiar logs temporales CON MÁXIMA SEGURIDAD
    echo -e "\n${YELLOW}4. LIMPIANDO LOGS TEMPORALES SEGUROS...${NC}"

    # Solo archivos .log en /tmp con más de 7 días
    echo "Buscando logs temporales antiguos en /tmp..."
    local logs_tmp=$(sudo find /tmp -maxdepth 1 -name "*.log" -type f -mtime +7 2>/dev/null | wc -l)

    if [[ $logs_tmp -gt 0 ]]; then
        echo "Archivos .log temporales antiguos encontrados: $logs_tmp"
        echo "Ejemplos:"
        sudo find /tmp -maxdepth 1 -name "*.log" -type f -mtime +7 -ls 2>/dev/null | head -5

        read -p "¿Eliminar estos logs temporales antiguos? [s/N]: " confirmar_tmp

        if [[ $confirmar_tmp =~ ^[Ss]$ ]]; then
            sudo find /tmp -maxdepth 1 -name "*.log" -type f -mtime +7 -delete 2>/dev/null
            success "Logs temporales antiguos eliminados"
        else
            echo "Limpieza de logs temporales cancelada"
        fi
    else
        echo "No se encontraron logs temporales antiguos en /tmp"
    fi

    # 5. Limpiar logs de aplicaciones de usuario (solo del usuario actual)
    echo -e "\n${YELLOW}5. LIMPIANDO LOGS DE APLICACIONES DE USUARIO...${NC}"
    if [[ -d ~/.cache ]]; then
        local user_logs=$(find ~/.cache -name "*.log" -type f -mtime +30 2>/dev/null | wc -l)

        if [[ $user_logs -gt 0 ]]; then
            echo "Logs de aplicaciones de usuario encontrados: $user_logs"
            read -p "¿Eliminar logs de aplicaciones de usuario? [s/N]: " confirmar_user

            if [[ $confirmar_user =~ ^[Ss]$ ]]; then
                find ~/.cache -name "*.log" -type f -mtime +30 -delete 2>/dev/null
                success "Logs de aplicaciones de usuario eliminados"
            fi
        else
            echo "No se encontraron logs de aplicaciones de usuario antiguos"
        fi
    fi

    # 6. Rotar logs manualmente (operación segura)
    echo -e "\n${YELLOW}6. ROTANDO LOGS...${NC}"
    if command -v logrotate >/dev/null 2>&1; then
        echo "Ejecutando rotación de logs..."
        sudo logrotate -f /etc/logrotate.conf
        success "Logs rotados correctamente"
    else
        echo "logrotate no disponible"
    fi

    echo -e "\n${YELLOW}■ ESPACIO FINAL EN /VAR/LOG:${NC}"
    df -h /var/log

    echo -e "\n${YELLOW}■ LOGS MÁS GRANDES ACTUALMENTE:${NC}"
    sudo find /var/log -type f -exec du -h {} + 2>/dev/null | sort -hr | head -10

    echo -e "\n${GREEN}■ RESUMEN DE SEGURIDAD:${NC}"
    echo "✓ Solo se eliminaron logs antiguos (>30 días)"
    echo "✓ Los logs activos fueron truncados, no eliminados"
    echo "✓ Se conservó journal de 100MB"
    echo "✓ Confirmación requerida para cada operación"
    echo "✓ No se afectaron logs del sistema en uso"

    success "Limpieza segura de logs completada"
    pause
}

verificacion_integridad() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "           VERIFICACIÓN DE INTEGRIDAD"
    echo "==================================================="
    echo -e "${NC}"
    
    echo -e "${YELLOW}■ INICIANDO VERIFICACIÓN DE INTEGRIDAD...${NC}"
    
    # 1. Verificar sistemas de archivos
    echo -e "\n${YELLOW}1. VERIFICANDO SISTEMAS DE ARCHIVOS...${NC}"
    for mountpoint in $(mount | grep -E "(ext4|xfs|btrfs)" | awk '{print $3}'); do
        echo "Verificando: $mountpoint"
        # Solo verificación, sin reparación
        sudo fsck -n $(mount | grep " $mountpoint " | awk '{print $1}') 2>/dev/null | grep -E "(clean|errors)" || echo "✓ OK"
    done
    
    # 2. Verificar paquetes instalados
    echo -e "\n${YELLOW}2. VERIFICANDO PAQUETES INSTALADOS...${NC}"
    if command -v debsums >/dev/null 2>&1; then
        echo "Verificando integridad de paquetes..."
        sudo debsums -c 2>/dev/null | head -10
        echo "... (usar 'debsums -c' para lista completa)"
    else
        echo "Instale 'debsums' para verificar paquetes: sudo apt install debsums"
    fi
    
    # 3. Verificar espacio en discos
    echo -e "\n${YELLOW}3. VERIFICANDO ESPACIO EN DISCOS...${NC}"
    df -h | grep -v tmpfs
    
    # 4. Verificar inodos
    echo -e "\n${YELLOW}4. VERIFICANDO INODOS...${NC}"
    df -i | grep -v tmpfs
    
    # 5. Verificar memoria
    echo -e "\n${YELLOW}5. VERIFICANDO MEMORIA...${NC}"
    free -h
    
    # 6. Verificar swap
    echo -e "\n${YELLOW}6. VERIFICANDO SWAP...${NC}"
    swapon --show
    
    # 7. Verificar logs de errores
    echo -e "\n${YELLOW}7. VERIFICANDO LOGS DE ERRORES...${NC}"
    sudo dmesg -T | grep -i error | tail -5
    if [[ $? -ne 0 ]]; then
        echo "No se encontraron errores recientes en dmesg"
    fi
    
    echo -e "\n${YELLOW}■ RECOMENDACIONES:${NC}"
    echo "• Ejecutar verificaciones regularmente"
    echo "• Monitorear espacio en disco"
    echo "• Revisar logs del sistema"
    
    success "Verificación de integridad completada"
    pause
}

mantenimiento_completo_automatico() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "        MANTENIMIENTO COMPLETO AUTOMÁTICO"
    echo "==================================================="
    echo -e "${NC}"
    
    local log_file="/tmp/mantenimiento_completo_$(date +%H%M%S).log"
    
    echo "Iniciando mantenimiento completo automático..."
    echo "Este proceso puede tomar varios minutos"
    echo ""
    
    echo "=== MANTENIMIENTO COMPLETO AUTOMÁTICO ===" > "$log_file"
    echo "Fecha: $(date)" >> "$log_file"
    echo "Usuario: $(whoami)" >> "$log_file"
    
    # 1. Actualización del sistema
    echo -e "\n${YELLOW}■ 1. ACTUALIZANDO SISTEMA...${NC}"
    echo "=== ACTUALIZACIÓN ===" >> "$log_file"
    sudo apt update >> "$log_file" 2>&1
    sudo apt upgrade -y >> "$log_file" 2>&1
    success "Sistema actualizado"
    
    # 2. Limpieza
    echo -e "\n${YELLOW}■ 2. LIMPIANDO SISTEMA...${NC}"
    echo "=== LIMPIEZA ===" >> "$log_file"
    sudo apt autoremove -y >> "$log_file" 2>&1
    sudo apt autoclean >> "$log_file" 2>&1
    success "Sistema limpiado"
    
    # 3. Reparación
    echo -e "\n${YELLOW}■ 3. REPARANDO PAQUETES...${NC}"
    echo "=== REPARACIÓN ===" >> "$log_file"
    sudo dpkg --configure -a >> "$log_file" 2>&1
    sudo apt install -f -y >> "$log_file" 2>&1
    success "Paquetes reparados"
    
    # 4. Liberación de memoria
    echo -e "\n${YELLOW}■ 4. LIBERANDO MEMORIA...${NC}"
    echo "=== MEMORIA ===" >> "$log_file"
    sudo sync >> "$log_file" 2>&1
    echo 3 | sudo tee /proc/sys/vm/drop_caches >> "$log_file" 2>&1
    success "Memoria liberada"
    
    # 5. Optimización de discos
    echo -e "\n${YELLOW}■ 5. OPTIMIZANDO DISCOS...${NC}"
    echo "=== OPTIMIZACIÓN ===" >> "$log_file"
    sudo fstrim / >> "$log_file" 2>&1
    sudo journalctl --vacuum-time=7d >> "$log_file" 2>&1
    success "Discos optimizados"
    
    # 6. Verificación final
    echo -e "\n${YELLOW}■ 6. VERIFICANDO SISTEMA...${NC}"
    echo "=== VERIFICACIÓN ===" >> "$log_file"
    echo "Espacio en disco:" >> "$log_file"
    df -h >> "$log_file"
    echo "" >> "$log_file"
    echo "Memoria:" >> "$log_file"
    free -h >> "$log_file"
    
    success "Mantenimiento completo finalizado"
    echo -e "\n${YELLOW}■ REPORTE GUARDADO EN: $log_file${NC}"
    
    echo -e "\n${YELLOW}■ RESUMEN FINAL:${NC}"
    echo "✓ Sistema actualizado"
    echo "✓ Paquetes limpiados" 
    echo "✓ Memoria liberada"
    echo "✓ Discos optimizados"
    echo "✓ Verificación completada"
    
    echo -e "\nPuede ver el reporte completo con: cat $log_file"
    pause
}

# =========================================
# HERRAMIENTAS DE MONITOREO - SECCIÓN PRINCIPAL
# =========================================

menu_herramientas_monitoreo() {
    while true; do
        clear
        echo -e "${CYAN}"
        echo "==================================================="
        echo "           HERRAMIENTAS DE MONITOREO"
        echo "==================================================="
        echo -e "${NC}"

        echo "1)  Instalar herramientas de monitoreo"
        echo "2)  HTOP - Monitor de procesos avanzado"
        echo "3)  BTOP - Monitor moderno (si está disponible)"
        echo "4)  NEOFETCH - Información del sistema"
        echo "5)  Monitor del sistema en tiempo real"
        echo "6)  Monitor de red en tiempo real"
        echo "7)  Monitor de discos en tiempo real"
        echo "8)  Panel de control completo"
        echo
        echo "0)  VOLVER AL MENÚ PRINCIPAL"
        echo

        read -p "Seleccione una opción [0-8]: " opcion

        case $opcion in
            1) instalar_herramientas_monitoreo ;;
            2) ejecutar_htop ;;
            3) ejecutar_btop ;;
            4) ejecutar_neofetch ;;
            5) monitor_sistema_tiempo_real ;;
            6) monitor_red_tiempo_real ;;
            7) monitor_discos_tiempo_real ;;
            8) panel_control_completo ;;
            0) return ;;
            *)
                error "Opción no válida: $opcion"
                pause
                ;;
        esac
    done
}

# =========================================
# FUNCIONES DE HERRAMIENTAS DE MONITOREO
# =========================================

instalar_herramientas_monitoreo() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "      INSTALACIÓN DE HERRAMIENTAS DE MONITOREO"
    echo "==================================================="
    echo -e "${NC}"

    echo -e "${YELLOW}■ INICIANDO INSTALACIÓN DE HERRAMIENTAS...${NC}"

    # Lista de herramientas recomendadas (ACTUALIZADA)
    local herramientas=(
        "htop"
        "iotop"
        "nethogs"
        "iftop"
        "dstat"
        "ncdu"
        "neofetch"
        "lm-sensors"
        "smartmontools"
        "inxi"
    )

    echo -e "\n${YELLOW}■ HERRAMIENTAS RECOMENDADAS:${NC}"
    for herramienta in "${herramientas[@]}"; do
        echo "  • $herramienta"
    done

    echo -e "\n${YELLOW}■ INSTALANDO HERRAMIENTAS BÁSICAS...${NC}"

    # Herramientas básicas (instalar automáticamente si no están) - ACTUALIZADA
    local herramientas_basicas=("htop" "neofetch" "dstat" "ncdu" "iotop" "nethogs" "iftop" "inxi")

    for herramienta in "${herramientas_basicas[@]}"; do
        if ! command -v "$herramienta" &> /dev/null && ! dpkg -l | grep -q "^ii  $herramienta "; then
            echo "Instalando $herramienta..."
            sudo apt install -y "$herramienta" > /dev/null 2>&1
            if command -v "$herramienta" &> /dev/null || dpkg -l | grep -q "^ii  $herramienta "; then
                echo -e "  ${GREEN}✓ $herramienta instalado${NC}"
            else
                echo -e "  ${RED}✗ Error instalando $herramienta${NC}"
            fi
        else
            echo -e "  ${GREEN}✓ $herramienta ya está instalado${NC}"
        fi
    done

    # BTOP - INSTALACIÓN AUTOMÁTICA
    echo -e "\n${YELLOW}■ INSTALANDO BTOP...${NC}"
    if ! command -v btop &> /dev/null; then
        echo "Btop no está en repositorios estándar. Instalando desde GitHub..."
        echo "Descargando última versión de Btop..."
        wget -q "https://github.com/aristocratos/btop/releases/latest/download/btop-x86_64-linux-musl.tbz" -O /tmp/btop.tbz
        if [[ $? -eq 0 ]]; then
            echo "Descomprimiendo..."
            tar -xf /tmp/btop.tbz -C /tmp/
            echo "Instalando..."
            sudo make -C /tmp/btop install > /dev/null 2>&1
            rm -rf /tmp/btop /tmp/btop.tbz
            if command -v btop &> /dev/null; then
                echo -e "  ${GREEN}✓ Btop instalado correctamente${NC}"
            else
                echo -e "  ${RED}✗ Error instalando Btop${NC}"
            fi
        else
            echo -e "  ${RED}✗ Error descargando Btop${NC}"
            echo "  Puede intentar manualmente desde: https://github.com/aristocratos/btop"
        fi
    else
        echo -e "  ${GREEN}✓ Btop ya está instalado${NC}"
    fi

    # HERRAMIENTAS ADICIONALES - INSTALACIÓN AUTOMÁTICA
    echo -e "\n${YELLOW}■ INSTALANDO HERRAMIENTAS ADICIONALES...${NC}"
    local herramientas_adicionales=("lm-sensors" "smartmontools")

    for herramienta in "${herramientas_adicionales[@]}"; do
        if ! command -v "$herramienta" &> /dev/null && ! dpkg -l | grep -q "^ii  $herramienta "; then
            echo "Instalando $herramienta..."
            sudo apt install -y "$herramienta" > /dev/null 2>&1
            if command -v "$herramienta" &> /dev/null || dpkg -l | grep -q "^ii  $herramienta "; then
                echo -e "  ${GREEN}✓ $herramienta instalado${NC}"
            else
                echo -e "  ${YELLOW}⚠ $herramienta no se pudo instalar${NC}"
            fi
        else
            echo -e "  ${GREEN}✓ $herramienta ya está instalado${NC}"
        fi
    done

    # Configurar sensores si está instalado
    if command -v sensors &> /dev/null || dpkg -l | grep -q "^ii  lm-sensors "; then
        echo -e "\n${YELLOW}■ CONFIGURANDO SENSORES...${NC}"
        read -p "¿Ejecutar detección de sensores? (recomendado) [s/N]: " config_sensores
        if [[ $config_sensores =~ ^[Ss]$ ]]; then
            sudo sensors-detect --auto
            echo -e "  ${GREEN}✓ Sensores configurados${NC}"
        fi
    fi

    # Verificar estado final - ACTUALIZADA
    echo -e "\n${YELLOW}■ ESTADO DE LAS HERRAMIENTAS:${NC}"
    local herramientas_verificar=("htop" "neofetch" "btop" "iotop" "nethogs" "iftop" "dstat" "ncdu" "inxi")

    for herramienta in "${herramientas_verificar[@]}"; do
        if command -v "$herramienta" &> /dev/null || dpkg -l | grep -q "^ii  $herramienta "; then
            echo -e "  ${GREEN}✓ $herramienta disponible${NC}"
        else
            echo -e "  ${YELLOW}⚠ $herramienta no disponible${NC}"
        fi
    done

    # Verificar sensores por separado
    if command -v sensors &> /dev/null || dpkg -l | grep -q "^ii  lm-sensors "; then
        echo -e "  ${GREEN}✓ lm-sensors instalado${NC}"
    else
        echo -e "  ${YELLOW}⚠ lm-sensors no disponible${NC}"
    fi

    echo -e "\n${YELLOW}■ CONFIGURACIÓN COMPLETADA:${NC}"
    echo "  Puede acceder a las herramientas desde el menú de monitoreo:"
    echo "  • HTOP: Monitor de procesos avanzado"
    echo "  • BTOP: Monitor moderno"
    echo "  • NEOFETCH: Información del sistema"
    echo "  • IOTOP: Monitor de E/S de discos"
    echo "  • NETHOGS: Monitor de tráfico de red por proceso"
    echo "  • IFTOP: Monitor de tráfico por conexión"
    echo "  • INXI: Información detallada del sistema"

    success "Proceso de instalación completado"
    pause
}

ejecutar_htop() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "               HTOP - MONITOR DE PROCESOS"
    echo "==================================================="
    echo -e "${NC}"

    if command -v htop &> /dev/null; then
        echo -e "${YELLOW}■ INICIANDO HTOP...${NC}"
        echo "Controles útiles:"
        echo "  F1 - Ayuda"
        echo "  F2 - Configuración"
        echo "  F3 - Buscar"
        echo "  F4 - Filtrar"
        echo "  F9 - Matar proceso"
        echo "  F10 - Salir"
        echo ""
        echo "Presione Enter para continuar o Ctrl+C para cancelar..."
        read -r

        htop
    else
        error "HTOP no está instalado"
        read -p "¿Instalar HTOP ahora? [s/N]: " instalar
        if [[ $instalar =~ ^[Ss]$ ]]; then
            sudo apt install -y htop
            if command -v htop &> /dev/null; then
                htop
            fi
        fi
    fi
}

ejecutar_btop() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "               BTOP - MONITOR MODERNO"
    echo "==================================================="
    echo -e "${NC}"

    if command -v btop &> /dev/null; then
        echo -e "${YELLOW}■ INICIANDO BTOP...${NC}"
        echo "Btop es un monitor moderno con mejoras visuales"
        echo ""
        echo "Presione Enter para continuar o Ctrl+C para cancelar..."
        read -r

        btop
    else
        error "BTOP no está instalado"
        echo "Btop no está en los repositorios estándar de Ubuntu/Debian"
        echo ""
        echo "Para instalar Btop, ejecute la opción 1 del menú de monitoreo"
        echo "o instálelo manualmente con:"
        echo ""
        echo "wget https://github.com/aristocratos/btop/releases/latest/download/btop-x86_64-linux-musl.tbz"
        echo "tar -xf btop-x86_64-linux-musl.tbz"
        echo "cd btop && sudo make install"
        pause
    fi
}

ejecutar_neofetch() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "               NEOFETCH - INFO SISTEMA"
    echo "==================================================="
    echo -e "${NC}"

    if command -v neofetch &> /dev/null; then
        neofetch
        echo ""
        echo -e "${YELLOW}■ INFORMACIÓN ADICIONAL:${NC}"
        echo "Neofetch muestra información detallada del sistema"
        echo "Incluye: Logo, sistema, kernel, uptime, paquetes, shell, etc."

        echo -e "\n${YELLOW}■ ALTERNATIVAS RÁPIDAS:${NC}"
        echo "También puedes usar:"
        echo "  • fastfetch - Alternativa más rápida (no incluida)"
        echo "  • inxi -F - Información técnica detallada (ya instalado)"
        echo ""
        echo -e "${CYAN}■ PARA INSTALAR FASTFETCH MANUALMENTE:${NC}"
        echo "git clone https://github.com/fastfetch-cli/fastfetch.git"
        echo "cd fastfetch && mkdir build && cd build"
        echo "cmake .. && make -j$(nproc) && sudo make install"
    else
        error "NEOFETCH no está instalado"
        read -p "¿Instalar Neofetch ahora? [s/N]: " instalar
        if [[ $instalar =~ ^[Ss]$ ]]; then
            sudo apt install -y neofetch
            if command -v neofetch &> /dev/null; then
                neofetch
            fi
        fi
    fi
    pause
}

monitor_sistema_tiempo_real() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "          MONITOR DEL SISTEMA - TIEMPO REAL"
    echo "==================================================="
    echo -e "${NC}"

    echo -e "${YELLOW}■ MONITOREO EN TIEMPO REAL DEL SISTEMA${NC}"
    echo "Mostrando métricas cada 2 segundos..."
    echo "Presione Ctrl+C para detener"
    echo ""

    local iteraciones=0
    local max_iteraciones=30  # 1 minuto aprox

    while [[ $iteraciones -lt $max_iteraciones ]]; do
        clear
        echo -e "${CYAN}=== MONITOR DEL SISTEMA - Iteración $((iteraciones + 1))/${max_iteraciones} ===${NC}"
        echo ""

        # Fecha y hora
        echo -e "${YELLOW}■ FECHA/HORA:${NC} $(date)"
        echo ""

        # Uso de CPU
        echo -e "${YELLOW}■ USO DE CPU:${NC}"
        top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print "  CPU Libre: " 100-$1 "%"}'
        echo "  Carga promedio: $(cat /proc/loadavg | awk '{print $1", "$2", "$3}')"
        echo ""

        # Memoria
        echo -e "${YELLOW}■ MEMORIA RAM:${NC}"
        free -h | awk '
            NR==1 {print "  " $0}
            NR==2 {print "  Memoria: " $3 " usados de " $2 " (" $4 " libres)"}
            NR==3 {print "  Swap: " $3 " usados de " $2 " (" $4 " libres)"}
        '
        echo ""

        # Discos
        echo -e "${YELLOW}■ USO DE DISCOS:${NC}"
        df -h | grep -E "^/dev/" | awk '{print "  " $1 ": " $5 " usado (" $4 " libre) - Montado en " $6}' | head -5
        echo ""

        # Procesos
        echo -e "${YELLOW}■ TOP 5 PROCESOS (CPU):${NC}"
        ps aux --sort=-%cpu | head -6 | awk '{printf "  %-10s %-6s %-5s %s\n", $11, $2, $3"%", $1}'
        echo ""

        # Temperatura (si está disponible)
        if command -v sensors &> /dev/null; then
            echo -e "${YELLOW}■ TEMPERATURAS:${NC}"
            sensors | grep -E "(Core|Package|temp)" | head -3 | while read line; do
                echo "  $line"
            done
        fi

        echo -e "${CYAN}=================================================${NC}"
        echo "Actualizando en 2 segundos... (Ctrl+C para salir)"

        iteraciones=$((iteraciones + 1))
        sleep 2
    done

    echo ""
    echo "Monitoreo automático finalizado"
    pause
}

monitor_red_tiempo_real() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "          MONITOR DE RED - TIEMPO REAL"
    echo "==================================================="
    echo -e "${NC}"

    # Verificar si las herramientas están instaladas
    local nethogs_instalado=$(command -v nethogs &> /dev/null && echo "si" || echo "no")
    local iftop_instalado=$(command -v iftop &> /dev/null && echo "si" || echo "no")

    echo -e "${YELLOW}■ SELECCIONE TIPO DE MONITOREO:${NC}"
    echo "1) Nethogs - Tráfico por proceso (requiere sudo)"
    if [[ "$nethogs_instalado" == "no" ]]; then
        echo "   ${RED}✗ NO INSTALADO${NC}"
    else
        echo "   ${GREEN}✓ DISPONIBLE${NC}"
    fi

    echo "2) iftop - Tráfico por conexión (requiere sudo)"
    if [[ "$iftop_instalado" == "no" ]]; then
        echo "   ${RED}✗ NO INSTALADO${NC}"
    else
        echo "   ${GREEN}✓ DISPONIBLE${NC}"
    fi

    echo "3) Monitor básico de interfaces"
    echo "   ${GREEN}✓ SIEMPRE DISPONIBLE${NC}"
    echo ""

    read -p "Seleccione opción [1-3]: " opcion_red

    case $opcion_red in
        1)
            if [[ "$nethogs_instalado" == "si" ]]; then
                echo -e "\n${YELLOW}■ INICIANDO NETHOGS...${NC}"
                echo "Mostrando tráfico de red por proceso"
                echo "Presione Ctrl+C para salir"
                sudo nethogs
            else
                error "Nethogs no está instalado"
                echo "Ejecute la opción 1 del menú para instalar todas las herramientas"
            fi
            ;;
        2)
            if [[ "$iftop_instalado" == "si" ]]; then
                echo -e "\n${YELLOW}■ INICIANDO IFTOP...${NC}"
                echo "Mostrando tráfico de red por conexión"
                echo "Presione Ctrl+C para salir"
                # Buscar interfaz activa
                local interfaz=$(ip route | grep default | awk '{print $5}' | head -1)
                if [[ -n "$interfaz" ]]; then
                    sudo iftop -i "$interfaz"
                else
                    sudo iftop
                fi
            else
                error "iftop no está instalado"
                echo "Ejecute la opción 1 del menú para instalar todas las herramientas"
            fi
            ;;
        3)
            echo -e "\n${YELLOW}■ MONITOR BÁSICO DE INTERFACES${NC}"
            echo "Actualizando cada 3 segundos... (Ctrl+C para salir)"
            echo ""

            local iteraciones=0
            while [[ $iteraciones -lt 20 ]]; do
                clear
                echo -e "${CYAN}=== MONITOR DE RED - Iteración $((iteraciones + 1))/20 ===${NC}"
                echo ""

                # Interfaces
                echo -e "${YELLOW}■ INTERFACES DE RED:${NC}"
                ip addr show | grep -E "^[0-9]+:|inet " | grep -v "127.0.0.1" | while read line; do
                    if [[ $line =~ ^[0-9]+: ]]; then
                        echo ""
                        echo "  $line"
                    else
                        echo "  $line"
                    fi
                done
                echo ""

                # Estadísticas
                echo -e "${YELLOW}■ ESTADÍSTICAS:${NC}"
                cat /proc/net/dev | awk '
                    NR>2 {
                        interface = $1;
                        gsub(/:/, "", interface);
                        if(interface != "lo") {
                            printf "  %-10s: RX: %6.2f MB | TX: %6.2f MB\n",
                                interface, $2/1024/1024, $10/1024/1024;
                        }
                    }
                '
                echo ""
                echo -e "${CYAN}=================================================${NC}"
                echo "Actualizando en 3 segundos... (Ctrl+C para salir)"

                iteraciones=$((iteraciones + 1))
                sleep 3
            done
            ;;
        *)
            error "Opción no válida"
            ;;
    esac

    pause
}

monitor_discos_tiempo_real() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "          MONITOR DE DISCOS - TIEMPO REAL"
    echo "==================================================="
    echo -e "${NC}"

    if ! command -v iotop &> /dev/null; then
        error "Iotop no está instalado"
        read -p "¿Instalar iotop para monitoreo de E/S? [s/N]: " instalar
        if [[ $instalar =~ ^[Ss]$ ]]; then
            sudo apt install -y iotop
        else
            echo "Continuando con monitor básico..."
        fi
    fi

    echo -e "${YELLOW}■ SELECCIONE TIPO DE MONITOREO:${NC}"
    echo "1) Iotop - E/S por proceso (requiere sudo)"
    echo "2) Monitor básico de discos"
    echo ""
    read -p "Seleccione opción [1-2]: " opcion_disco

    case $opcion_disco in
        1)
            if command -v iotop &> /dev/null; then
                echo -e "\n${YELLOW}■ INICIANDO IOTOP...${NC}"
                echo "Mostrando actividad de E/S por proceso"
                echo "Presione Ctrl+C para salir"
                sudo iotop
            else
                error "Iotop no está disponible"
            fi
            ;;
        2)
            echo -e "\n${YELLOW}■ MONITOR BÁSICO DE DISCOS${NC}"
            echo "Actualizando cada 3 segundos... (Ctrl+C para salir)"
            echo ""

            local iteraciones=0
            while [[ $iteraciones -lt 15 ]]; do
                clear
                echo -e "${CYAN}=== MONITOR DE DISCOS - Iteración $((iteraciones + 1))/15 ===${NC}"
                echo ""

                # Uso de discos
                echo -e "${YELLOW}■ USO DE DISCOS:${NC}"
                df -h | grep -E "^/dev/" | awk '{print "  " $1 ": " $5 " usado - " $4 " libres - " $6}' | head -6
                echo ""

                # I/O Stats
                echo -e "${YELLOW}■ ESTADÍSTICAS DE E/S:${NC}"
                if [[ -f /proc/diskstats ]]; then
                    echo "  Disco    Lecturas/s  Escrituras/s"
                    grep -E "(sda|sdb|nvme)" /proc/diskstats | head -3 | while read line; do
                        local disk=$(echo $line | awk '{print $3}')
                        local reads=$(echo $line | awk '{print $4}')
                        local writes=$(echo $line | awk '{print $8}')
                        echo "  $disk     $reads         $writes"
                    done
                fi
                echo ""

                # Procesos con E/S
                echo -e "${YELLOW}■ TOP 5 PROCESOS CON E/S:${NC}"
                ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -6 | while read line; do
                    echo "  $line"
                done

                echo ""
                echo -e "${CYAN}=================================================${NC}"
                echo "Actualizando en 3 segundos... (Ctrl+C para salir)"

                iteraciones=$((iteraciones + 1))
                sleep 3
            done
            ;;
        *)
            error "Opción no válida"
            ;;
    esac

    pause
}

panel_control_completo() {
    clear
    echo -e "${CYAN}"
    echo "==================================================="
    echo "             PANEL DE CONTROL COMPLETO"
    echo "==================================================="
    echo -e "${NC}"

    echo -e "${YELLOW}■ INICIANDO PANEL DE CONTROL UNIFICADO...${NC}"
    echo "Mostrando todas las métricas del sistema"
    echo "Actualizando cada 5 segundos... (Ctrl+C para salir)"
    echo ""

    local iteraciones=0
    local max_iteraciones=12  # 1 minuto

    while [[ $iteraciones -lt $max_iteraciones ]]; do
        clear
        echo -e "${CYAN}=== PANEL DE CONTROL - Iteración $((iteraciones + 1))/${max_iteraciones} ===${NC}"
        echo -e "Sistema: $(hostname) | Usuario: $(whoami) | Fecha: $(date)"
        echo ""

        # Sección 1: Sistema
        echo -e "${YELLOW}■ [1] SISTEMA${NC}"
        echo "  Uptime: $(uptime -p)"
        echo "  Carga: $(cat /proc/loadavg | awk '{print $1", "$2", "$3}')"
        echo "  Procesos: $(ps -e | wc -l) activos"
        echo ""

        # Sección 2: CPU
        echo -e "${YELLOW}■ [2] CPU${NC}"
        local cpu_info=$(top -bn1 | grep "Cpu(s)" | awk '{print "  Libre: " 100-$8 "% | Usuario: " $2 "% | Sistema: " $4 "%"}')
        echo "$cpu_info"
        echo "  Núcleos: $(nproc) | Arquitectura: $(uname -m)"
        echo ""

        # Sección 3: Memoria
        echo -e "${YELLOW}■ [3] MEMORIA${NC}"
        free -h | awk '
            NR==2 {print "  RAM: " $3 " / " $2 " (" $4 " libre)"}
            NR==3 {print "  Swap: " $3 " / " $2 " (" $4 " libre)"}
        '
        echo ""

        # Sección 4: Discos
        echo -e "${YELLOW}■ [4] ALMACENAMIENTO${NC}"
        df -h | grep -E "^/dev/" | head -3 | awk '{print "  " $1 ": " $5 " usado (" $4 " libre)"}'
        echo ""

        # Sección 5: Red
        echo -e "${YELLOW}■ [5] RED${NC}"
        local default_iface=$(ip route | grep default | awk '{print $5}' | head -1)
        if [[ -n "$default_iface" ]]; then
            echo "  Interfaz: $default_iface"
            local ip_addr=$(ip addr show $default_iface | grep "inet " | awk '{print $2}')
            echo "  IP: $ip_addr"
        fi
        echo "  Conexiones: $(ss -tun | wc -l) activas"
        echo ""

        # Sección 6: Temperatura
        echo -e "${YELLOW}■ [6] TEMPERATURA${NC}"
        if command -v sensors &> /dev/null; then
            sensors | grep -E "(Core|Package|temp)" | head -2 | while read line; do
                echo "  $line"
            done
        else
            echo "  Instale 'lm-sensors' para ver temperaturas"
        fi
        echo ""

        # Sección 7: Servicios
        echo -e "${YELLOW}■ [7] SERVICIOS PRINCIPALES${NC}"
        local servicios=("NetworkManager" "ssh" "cups" "apache2" "nginx" "mysql")
        for servicio in "${servicios[@]}"; do
            if systemctl is-active "$servicio" &>/dev/null; then
                echo -e "  ${GREEN}✓ $servicio${NC}"
            fi
        done
        echo ""

        echo -e "${CYAN}=================================================${NC}"
        echo -e "${YELLOW}LEGEND:${NC} ${GREEN}✓ Normal${NC} | ${RED}✗ Problema${NC} | ${YELLOW}⚠ Advertencia${NC}"
        echo "Actualizando en 5 segundos... (Ctrl+C para salir)"

        iteraciones=$((iteraciones + 1))
        sleep 5
    done

    echo ""
    echo "Panel de control finalizado"
    pause
}

# =========================================
# FUNCIONES PRINCIPALES - MENU PRINCIPAL
# =========================================

menu_principal() {
    while true; do
        clear
        echo -e "${CYAN}"
        echo "==================================================="
        echo "   SCRIPT PARA SOPORTE LINUX v3.0 - SMITH LOZANO   "
        echo "==================================================="
        echo -e "${NC}"
        
        echo "1)  🔍 INFORMACIÓN DEL SISTEMA"
        echo "2)  🌐 DIAGNÓSTICO DE RED"
        echo "3)  💾 DIAGNÓSTICO DE ALMACENAMIENTO" 
        echo "4)  👥 GESTIÓN DE USUARIOS"
        echo "5)  🛠️  MANTENIMIENTO"
        echo "6)  📊 HERRAMIENTAS DE MONITOREO"
        echo
        echo "0)  SALIR"
        echo
        
        read -p "Seleccione una opción [0-6]: " opcion
        
        case $opcion in
            1) menu_informacion_sistema ;;
            2) menu_diagnostico_red ;;
            3) menu_diagnostico_almacenamiento ;;
            4) menu_gestion_usuarios ;;
            5) menu_mantenimiento ;;
            6) menu_herramientas_monitoreo ;;
            0) 

            echo "╔══════════════════════════════════════════════╗"
            echo "║    ███████╗███╗   ███╗██╗████████╗██╗  ██╗   ║"
            echo "║    ██╔════╝████╗ ████║██║╚══██╔══╝██║  ██║   ║"
            echo "║    ███████╗██╔████╔██║██║   ██║   ███████║   ║"
            echo "║    ╚════██║██║╚██╔╝██║██║   ██║   ██╔══██║   ║"
            echo "║    ███████║██║ ╚═╝ ██║██║   ██║   ██║  ██║   ║"
            echo "║    ╚══════╝╚═╝     ╚═╝╚═╝   ╚═╝   ╚═╝  ╚═╝   ║"
            echo "╠══════════════════════════════════════════════╣"
            echo "║           S O P O R T E   L I N U X          ║"
            echo "║              = SMITH LOZANO =                ║"
            echo "║                   v 3.0                      ║"
            echo "╠══════════════════════════════════════════════╣"
            echo ""
                exit 0 
                ;;
            *) 
                error "Opción no válida"
                pause 
                ;;
        esac
    done
}

# =========================================
# INICIALIZACIÓN
# =========================================

main() {
    # Autenticación
    autenticacion
    
    # Menú principal
    menu_principal
}

# Ejecutar
main "$@"
