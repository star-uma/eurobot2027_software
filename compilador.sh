#!/bin/bash

# Define la ruta del workspace
WS_DIR=~/eurobot2027_ws

echo "🤖 Creando workspace en $WS_DIR..."
mkdir -p $WS_DIR/src

echo "📥 Descargando repositorios..."
# Importa los repositorios desde el archivo robot.repos a la carpeta src del workspace
vcs import $WS_DIR/src < robot.repos

echo "📦 Instalando dependencias de ROS 2..."
cd $WS_DIR
rosdep update
rosdep install --from-paths src --ignore-src -r -y

echo "🔨 Compilando el workspace..."
colcon build --symlink-install

echo "✅ Instalación completada. Recuerda hacer: source $WS_DIR/install/setup.bash"
