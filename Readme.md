# SWorld app

Aplicacion de prueba que obtiene sus datos de la api themoviedb, se permite listar, buscar por titulos y acceder al detalle

#### Prerquisitos para el funcionamiento del projecto
* Crear una cuenta en la api para generar una api_key necesaria para el funcionamiento del servicio 
* Al ejecutar el pod install nos pedira a traves del plugin de cocoapods-keys la api key necesaria, la introducimos y run

# Arquitectura 
Se sigue la arquitectura MVVM y usando programacion reactiva con RxSwift y RxCocoa.
Se sigue el patron coordinator para definir el flujo de pantallas.
Para la obtencion de los datos tenemos el patron repositorio 
