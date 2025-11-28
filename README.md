README - Script para Soporte Linux v3.0

INFORMACIÓN GENERAL
- Nombre: Script para Soporte Linux v3.0
- Desarrollador: Smith Lozano
- Versión: 3.0
- Tipo: Script de soporte técnico integral para sistemas Linux
- Archivo de Log: /tmp/soporte_linux_YYYYMMDD_HHMMSS.log

SISTEMA DE AUTENTICACIÓN
Contraseña de Acceso
- Contraseña: soporte
- Intentos permitidos: 3
- Acceso: Requiere autenticación para usar el script

Características de Seguridad
- Validación de credenciales
- Logging de intentos de acceso
- Salida automática tras múltiples fallos

CARACTERÍSTICAS PRINCIPALES
Sistemas Compatibles
- Distribuciones: Debian, Ubuntu y derivados
- Gestor de Paquetes: Sistemas basados en APT
- Arquitecturas: x86_64, ARM (compatible con la mayoría)

Protección Integrada
- Lista de paquetes críticos protegidos
- Prevención de eliminación accidental de paquetes esenciales
- Limpieza segura de sistema

MÓDULOS Y FUNCIONALIDADES DETALLADAS

1. INFORMACIÓN DEL SISTEMA
menu_informacion_sistema()
Sub-funciones:
- info_basica_sistema(): Hostname, usuario, uptime, carga del sistema
- info_procesador_detallada(): Modelo, núcleos, frecuencias, caché, arquitectura
- info_memoria_ram(): Uso de memoria, procesos, detalles físicos
- info_almacenamiento(): Discos, particiones, espacio, tipo de almacenamiento
- info_hardware_completo(): Resumen completo de hardware
- logs_inicios_sesion(): Sesiones activas, historial de logins
- info_distribucion(): Información específica de la distribución
- resumen_completo_sistema(): Reporte completo en archivo temporal

2. DIAGNÓSTICO DE RED
menu_diagnostico_red()
Sub-funciones:
- info_interfaces_red(): Configuración de interfaces, tabla de rutas
- test_conectividad_basica(): Ping a servidores clave, DNS, HTTP
- test_velocidad_red(): Velocidad de interfaz, test de descarga
- analisis_puertos(): Puertos abiertos, conexiones, servicios
- diagnostico_completo_red(): Reporte exhaustivo de red
- estadisticas_red(): Tráfico, conexiones, estadísticas
- configuracion_dns(): Configuración DNS actual, servidores
- flush_dns_red(): Limpieza de cache DNS, reinicio de servicios

3. DIAGNÓSTICO DE ALMACENAMIENTO
menu_diagnostico_almacenamiento()
Sub-funciones:
- info_unidades_almacenamiento(): Discos, particiones, tipos (SSD/HDD/NVMe)
- test_velocidad_lectura_escritura(): Benchmarks con hdparm y dd
- estado_smart_discos(): Salud de discos, atributos SMART
- analisis_espacio_disco(): Uso de espacio, archivos grandes
- diagnostico_completo_almacenamiento(): Reporte completo
- info_particiones(): Tablas de particiones, detalles
- estado_filesystems(): Sistemas de archivos montados
- benchmark_io(): Latencia, rendimiento de E/S

4. GESTIÓN DE USUARIOS
menu_gestion_usuarios()
Sub-funciones:
- listar_usuarios_sistema(): Usuarios normales y del sistema
- info_detallada_usuarios(): Información completa por usuario
- crear_nuevo_usuario(): Creación interactiva de usuarios
- eliminar_usuario(): Eliminación segura con opciones
- modificar_password_usuario(): Cambio de contraseñas
- ver_grupos_sistema(): Grupos y membresías
- ver_sesiones_activas(): Usuarios conectados, procesos
- auditoria_seguridad_usuarios(): Reporte de seguridad

5. MANTENIMIENTO
menu_mantenimiento()
Sub-funciones:
- limpieza_sistema(): Limpieza segura de cache y temporales
- actualizacion_sistema(): Actualización completa del sistema
- reparacion_paquetes(): Reparación de dependencias y paquetes
- liberacion_memoria(): Liberación de cache de memoria
- optimizacion_discos(): TRIM, limpieza, optimizaciones
- limpieza_logs(): Limpieza segura de logs antiguos
- verificacion_integridad(): Verificación de sistemas de archivos
- mantenimiento_completo_automatico(): Ejecución automática completa

6. HERRAMIENTAS DE MONITOREO
menu_herramientas_monitoreo()
Sub-funciones:
- instalar_herramientas_monitoreo(): Instalación automática de herramientas
- ejecutar_htop(): Monitor de procesos avanzado
- ejecutar_btop(): Monitor moderno (instalación automática)
- ejecutar_neofetch(): Información del sistema con estilo
- monitor_sistema_tiempo_real(): Monitorización en tiempo real
- monitor_red_tiempo_real(): Monitoreo de red en vivo
- monitor_discos_tiempo_real(): Actividad de discos en tiempo real
- panel_control_completo(): Dashboard unificado del sistema

Limpieza Segura
- No elimina paquetes esenciales automáticamente
- Confirmaciones interactivas para operaciones críticas
- Logging de todas las acciones realizadas

SISTEMA DE LOGGING
Características:
- Ubicación: /tmp/soporte_linux_YYYYMMDD_HHMMSS.log
- Registro: Todas las operaciones con timestamp
- Niveles: INFO, SUCCESS, WARNING, ERROR
- Retención: Logs temporales (se limpian en reinicio)

Funciones de Log:
- log(): Registro básico
- success(): Operaciones exitosas
- error(): Errores y fallos
- warning(): Advertencias
- info(): Información general

INTERFAZ DE USUARIO
Sistema de Colores:
- Rojo: Errores y advertencias críticas
- Verde: Operaciones exitosas
- Amarillo: Advertencias y confirmaciones
- Azul: Información general
- Cian: Títulos y encabezados
- Morado: Elementos destacados

Experiencia de Usuario:
- Menús intuitivos y navegación consistente
- Confirmaciones para operaciones destructivas
- Pausas automáticas entre operaciones
- Feedback visual claro del estado

REQUISITOS DEL SISTEMA
Privilegios:
- Usuario: Cualquier usuario con acceso sudo
- Permisos: Requiere elevación para muchas operaciones

Dependencias:
- Básicas: bash, coreutils, sudo
- Recomendadas: Instalables desde el menú de monitoreo

Espacio:
- Mínimo: 100MB para operaciones temporales
- Recomendado: 1GB para logs y archivos temporales

INSTRUCCIONES DE USO
Ejecución:
chmod +x Script_bash_Soporte_Linux_v3.0.sh
./Script_bash_Soporte_Linux_v3.0.sh

Flujo de Trabajo:
1. Autenticación con contraseña
2. Navegación por menús principales
3. Selección de funcionalidades específicas
4. Ejecución con confirmaciones cuando sea necesario
5. Revisión de resultados y logs

CONSIDERACIONES IMPORTANTES
Advertencias de Seguridad:
- La contraseña está embebida en el script
- Algunas operaciones requieren privilegios elevados
- Las operaciones de limpieza son irreversibles
- Siempre verifique las acciones antes de confirmar

Limitaciones Conocidas:
- Diseñado específicamente para sistemas basados en Debian/Ubuntu
- Algunas funciones pueden no estar disponibles en todas las distribuciones
- Requiere conexión a internet para actualizaciones y tests de red

SOPORTE Y CRÉDITOS
Desarrollador:
- Nombre: Smith Lozano
- Versión: 3.0
- Propósito: Herramienta integral de soporte técnico Linux

Características de Desarrollo:
- Código bien estructurado y comentado
- Funciones modulares y reutilizables
- Manejo robusto de errores
- Logging comprehensivo

MANTENIMIENTO Y ACTUALIZACIONES
Actualizaciones Automáticas:
- Sistema de actualización integrado
- Verificación de paquetes disponibles
- Actualización de snaps y flatpaks

Mantenimiento Programado:
- Limpieza automática de temporales
- Optimización de bases de datos
- Verificación de integridad del sistema

Este script representa una herramienta profesional y completa para la administración y soporte de sistemas Linux, diseñada con un enfoque en la seguridad, usabilidad y funcionalidad integral.
