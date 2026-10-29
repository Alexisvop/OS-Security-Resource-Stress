#!/bin/bash
# ============================================================
#  ESCUDO DE PROTECCIÓN Y CONTROL DE ACCESO
#  Sistemas Operativos - Tema 8 (Parte 4)
# ============================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}[*] Iniciando blindaje del sistema operativo...${NC}\n"

# 1. Firewall UFW 
echo -e "${YELLOW}1. Configurando Firewall (UFW)...${NC}"
sudo apt install -y ufw > /dev/null 2>&1
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp # Permite tu conexión SSH actual
sudo ufw --force enable
echo -e "${GREEN}  [✓] UFW activado: Bloqueando todo excepto SSH.${NC}\n"

# 2. SSH Seguro 
echo -e "${YELLOW}2. Asegurando servicio SSH...${NC}"
# Deshabilita el inicio de sesión para el usuario 'root' por red
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
# Limita los intentos de contraseña para evitar fuerza bruta
sudo sed -i 's/^#MaxAuthTries.*/MaxAuthTries 3/' /etc/ssh/sshd_config
sudo systemctl restart ssh
echo -e "${GREEN}  [✓] Root login deshabilitado. Intentos máximos fijados en 3.${NC}\n"

# 3. Políticas de Contraseña [cite: 110]
echo -e "${YELLOW}3. Implementando políticas de contraseña...${NC}"
# Exige que las contraseñas expiren cada 90 días
sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
# Exige una longitud mínima de 12 caracteres
sudo sed -i 's/^PASS_MIN_LEN.*/PASS_MIN_LEN    12/' /etc/login.defs
echo -e "${GREEN}  [✓] Rotación a 90 días y longitud mínima de 12 configurada.${NC}\n"

# 4. Restricción de Usuarios (Para mitigar la Bomba Fork) 
echo -e "${YELLOW}4. Aplicando restricciones de recursos (ulimit)...${NC}"
# Límite duro de 150 procesos para el usuario actual
USUARIO=$(whoami)
# Eliminar regla anterior si existe, y agregar la nueva
sudo sed -i "/^$USUARIO.*nproc/d" /etc/security/limits.conf
echo "$USUARIO hard nproc 150" | sudo tee -a /etc/security/limits.conf > /dev/null
echo -e "${GREEN}  [✓] Límite de 150 procesos máximo para el usuario '$USUARIO'.${NC}\n"

# 5. Permisos y ACLs [cite: 105, 106]
echo -e "${YELLOW}5. Configurando Listas de Control de Acceso (ACLs)...${NC}"
sudo apt install -y acl > /dev/null 2>&1
# Creamos una carpeta segura "boveda"
mkdir -p ~/boveda_segura
# Le damos permisos exclusivos solo a tu usuario
setfacl -m u:$USUARIO:rwx ~/boveda_segura
# Le quitamos todo permiso a cualquier otro usuario del sistema
setfacl -m o::--- ~/boveda_segura
echo -e "${GREEN}  [✓] Carpeta 'boveda_segura' protegida con ACLs estrictas.${NC}\n"

echo -e "${CYAN}[✓] BLINDAJE COMPLETADO. SISTEMA PROTEGIDO.${NC}"
echo -e "    * Nota: Para que el límite de procesos (ulimit) surta efecto,"
echo -e "      debes cerrar tu sesión SSH (escribiendo 'exit') y volver a entrar."