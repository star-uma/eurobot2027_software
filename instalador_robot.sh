#!/bin/bash
# Instalador automático para Eurobot 2027 (Raspberry Pi 5)
# Detiene el script si ocurre algún error crítico
set -e 
# Actualiza el sistema antes de comenzar
sudo apt update && sudo apt upgrade -y
echo "Iniciando configuración del Eurobot 2027..."

echo "1/5: Configurando repositorios de ROS 2 Jazzy..."
sudo apt update && sudo apt install locales software-properties-common curl git -y
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

sudo add-apt-repository universe -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

echo "2/5: Instalando ROS 2 Base y herramientas de compilación..."
sudo apt update
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