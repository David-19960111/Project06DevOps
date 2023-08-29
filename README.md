# Balanceador de Carga con Instancias EC2 - Guía de Configuración

Esta guía te proporcionará los pasos necesarios para configurar un balanceador de carga que distribuye la carga entre dos instancias EC2 utilizando Localstack para el desarrollo local. El balanceador de carga asegurará la alta disponibilidad y la distribución equitativa de las solicitudes a través de las instancias EC2.

## Objetivo

El objetivo principal de este ejercicio es crear un balanceador de carga utilizando Localstack como herramienta para el desarrollo local. Esto se logrará al cumplir los siguientes requisitos:

- Crear una VPC con dos subredes privadas y dos subredes públicas.
- Configurar dos instancias EC2 en diferentes zonas de disponibilidad.
- Cada instancia EC2 debe tener un servidor web instalado que muestre el nombre de la instancia y la región.
- Agregar las instancias EC2 a un grupo de destinos (target group).
- Crear un balanceador de carga (ALB) y asociarlo con el grupo de destinos.

## Requisitos

Antes de comenzar, asegúrate de tener instalados los siguientes recursos y herramientas:

- [Localstack](https://github.com/localstack/localstack): Herramienta para simular servicios de AWS en entornos locales.
- Módulos de AWS: Asegúrate de contar con los módulos necesarios para crear recursos de AWS en Localstack.
  - AWS VPC Module
  - AWS ALB Module
  - AWS EC2 Instance Module

## Pasos a Seguir

### 1. Crear la VPC y Subredes

Utiliza los módulos de AWS para crear una VPC con dos subredes privadas y dos subredes públicas. Asegúrate de configurar las subredes en diferentes zonas de disponibilidad para lograr alta disponibilidad.

### 2. Configurar las Instancias EC2

Crea dos instancias EC2 en las subredes previamente creadas. Asegúrate de que cada instancia tenga un servidor web instalado que pueda mostrar información sobre la instancia y la región en la que se encuentra.

### 3. Crear un Grupo de Destinos (Target Group)

Crea un grupo de destinos (target group) y agrega las dos instancias EC2 recién creadas a este grupo. Esto permitirá que el balanceador de carga dirija las solicitudes a estas instancias.

### 4. Configurar el Balanceador de Carga (ALB)

Utiliza el módulo de AWS ALB para crear un balanceador de carga. Asocia el grupo de destinos creado en el paso anterior con el balanceador de carga para que pueda distribuir las solicitudes entrantes.

### 5. Ejecutar en Localstack

Asegúrate de que Localstack esté configurado y en funcionamiento. Luego, ejecuta los scripts de configuración y despliegue utilizando los módulos de AWS para crear y configurar los recursos en Localstack.

## Recursos Adicionales

- [Localstack Documentation](https://github.com/localstack/localstack#overview): Documentación oficial de Localstack para obtener información detallada sobre su configuración y uso.
- AWS Documentation: Referencias y guías oficiales de AWS para comprender mejor los conceptos y recursos involucrados.

¡Con estos pasos, habrás configurado un balanceador de carga que distribuye la carga entre dos instancias EC2 utilizando Localstack para el desarrollo local! Asegúrate de consultar la documentación y los recursos adicionales si necesitas más detalles o información específica sobre cada paso.