#!/bin/bash
# Instalador automático para Eurobot 2027 (Raspberry Pi 5)
# Detiene el script si ocurre algún error crítico
set -e 
# Actualiza el sistema antes de comenzar
sudo apt update && sudo apt upgrade -y
echo "Iniciando configuración del Eurobot 2027..."

echo "1/5: Configurando repositorios de ROS 2 Jazzy..."

sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

sudo apt install software-properties-common
sudo add-apt-repository universe

sudo apt update && sudo apt install curl -y
export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F'"' '{print $4}')
curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb"
sudo dpkg -i /tmp/ros2-apt-source.deb

echo "2/5: Instalando ROS 2 Base y herramientas de compilación..."
sudo apt update
sudo apt upgrade

sudo apt install ros-jazzy-ros-base python3-colcon-common-extensions python3-rosdep -y

echo "3/5: Creando workspace y clonando repositorios..."
WS_DIR="$(pwd)/eurobot2027_ws"

mkdir -p $WS_DIR/src
cd $WS_DIR/src

git clone https://github.com/star-uma/eurobot2027_software_control.git
git clone https://github.com/star-uma/eurobot2027_software_vision.git

echo "4/5: Resolviendo dependencias de hardware (rosdep)..."
cd $WS_DIR
sudo rosdep init || true # El || true evita que falle si ya estaba inicializado
rosdep update
rosdep install --from-paths src --ignore-src -r -y

echo "5/5: Compilando el código del robot..."
source /opt/ros/jazzy/setup.bash
colcon build --symlink-install

echo "Configurando entorno automático..."
# Solo añade el source si no existe ya en el .bashrc
if ! grep -q "ros/jazzy/setup.bash" ~/.bashrc; then
    echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
    echo "source $WS_DIR/install/setup.bash" >> ~/.bashrc
fi

echo "¡Robot configurado con éxito! Reinicia la terminal o ejecuta 'source ~/.bashrc'."