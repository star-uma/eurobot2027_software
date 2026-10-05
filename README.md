# Eurobot 2027 - Meta-repositorio de Software

Este repositorio contiene el script de instalación automática para el ecosistema completo de ROS 2 del robot.

## Instalación rápida

Abre tu terminal y ejecuta estos tres comandos:

```bash
# 1. Clona este repositorio en tu ordenador (puede ser en cualquier carpeta temporal)
git clone https://github.com/star-uma/eurobot2027_software.git

# 2. Entra en la carpeta
cd eurobot2027_software

# 3. Ejecuta el instalador automático
vcs import . < robot.repos
```
## Repositorios
* [eurobot2027_software_vision](https://github.com/star-uma/eurobot2027_software_vision.git) - Paquetes de visión artificial.
* [eurobot2027_software_control](https://github.com/star-uma/eurobot2027_software_control.git) - Nodos de control y navegación.
* [eurobot2027_software_simulacion](https://github.com/star-uma/eurobot2027_software_simulacion.git) - Entornos virtuales y modelo URDF en Gazebo.
* [eurobot2027_software_firmware_esp32](https://github.com/star-uma/eurobot2027_software_firmware_esp32.git) - Código de bajo nivel para microcontroladores.
