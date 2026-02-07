![título del juego Yaya's Sideral Bocatas](https://github.com/MarioCantaloupe/YSB/blob/main/01_assets/01_sprites/05_ui/YSB_LogoWide.png?raw=true)

**Yaya's Sideral Bocatas** es una pequeña demo hecha con [Godot](https://godotengine.org/) 4.5.

Es un juego de cocina similar a Cooking Mama con físicas donde usas el ratón para dar los pedidos a tus clientes.

Su desarrollo ocurrió entre *noviembre de 2025* y *enero de 2026* por un grupo de 3 estudiates universitarios.

Casi todo el código es libremente **(CC0)** explorable y reusable, excluyendo los siguientes:


> **Nota:** No se garantiza que el código sea funcional en ninguna versión de Godot excepto la **4.5**.


Shader de [Squigglevision](https://godotshaders.com/shader/squigglevision/) por tentabrobpy

Plugin [ShaderV](https://github.com/arkology/ShaderV) de arkology


https://github.com/user-attachments/assets/4045d81f-0d2a-4e5f-9777-4bbb24d020e5

## Diseño del juego: Pedidos
Al iniciar el juego, recibirás tu primer pedido, al tomarlo empieza el juego, progresivamente irán apareciendo más pedidos mediante avance el tiempo.

De forma técnica, se creó un sistema para convertir los datos de un pedido en texto legible en cada tique.

https://github.com/user-attachments/assets/4a8faf5f-2ec1-4ea2-bec7-17920f97166f

## Diseño del juego: Cocina

### Limpiar y cortar
En la segunda pantalla está la primera mesa: Descongelado, limpiado y cortado, se explica por si mismo, habrá **tips en pantalla** que te irán guiando a través de tu primera vez.

https://github.com/user-attachments/assets/28730e93-9f2b-4508-a6d3-0590b9c0ff4b

### Freir
**Reusando el código del fregadero** que se usa para limpiar, colocar los ingredientes en la plancha hace que suban de nivel 0 de cocinado, hasta nivel 2.

https://github.com/user-attachments/assets/9b2d9c5c-cf79-4ff5-b716-b6d12f205cc0

### Batir y montar
De nuevo reusando el código del fregadero, puedes ir colocando ingredientes unos encima de otros, **¡Recuerda que el orden importa!**. En paralelo, puedes ir soltando ingredientes en la batidora y activándola para mezclarlos.

https://github.com/user-attachments/assets/6cd9c544-e28a-40cf-baa8-7f6a47a023f7

### Entregar
Una vez tengas todo en su sitio, puedes darle a la campanita para hacer la entrega, sólo selecciona el pedido al que corresponde, y fuera con ello. Tus clientes son un poco exquisitos, así que dependiendo de si el pedido es correcto o no, **la integridad de la nave aumentará o se reducirá.**

## Diseño del juego: Sidescroller
¿Pero qué pasa cuando te quedas sin ingredientes? Pues respiras hondo y sales a la compra por supuesto.

https://github.com/user-attachments/assets/57bfbb5a-2260-4e67-959a-09258d08309c

### Asteroides
A través de tu paseíto, irán apareciendo obstáculos en tu camino que tendrás que esquivar, pero no son todo obstáculos, también aparecerán **Caramelos**, consigue tres y quizás podrás hacer algo sobre los asteroides...


