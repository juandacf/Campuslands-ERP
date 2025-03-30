CREATE DATABASE campuslands;
USE campuslands;

CREATE TABLE TipoDocumento (
    id_tipo_documento DECIMAL(4,0) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Direcciones (
    id_direccion INTEGER PRIMARY KEY AUTO_INCREMENT,
    tipo_via VARCHAR(50),
    nombre_via VARCHAR(50),
    complemento VARCHAR(50),
    numero VARCHAR(8),
    sufijo VARCHAR(10),
    vecindario VARCHAR(100),
    ciudad VARCHAR(80),
    departamento VARCHAR(80),
    pais VARCHAR(80)
);

CREATE TABLE Telefonos (
    id_telefono INTEGER PRIMARY KEY AUTO_INCREMENT,
    numero_telefono DECIMAL(12,0) NOT NULL,
    prefijo_telefonico DECIMAL(3,0) NOT NULL
);

CREATE TABLE Acudientes (
    documento_acudiente VARCHAR(12) PRIMARY KEY,
    primer_nombre VARCHAR(50),
    segundo_nombre VARCHAR(50),
    primer_apellido VARCHAR(50),
    segundo_apellido VARCHAR(50),
    id_tipo_documento DECIMAL(4,0),
    id_telefono INTEGER,
    id_direccion INTEGER,
    FOREIGN KEY (id_tipo_documento) REFERENCES TipoDocumento(id_tipo_documento),
    FOREIGN KEY (id_telefono) REFERENCES Telefonos(id_telefono),
    FOREIGN KEY (id_direccion) REFERENCES Direcciones(id_direccion)
);

CREATE TABLE Campers (
    documento_camper VARCHAR(12) PRIMARY KEY,
    primer_nombre VARCHAR(50),
    segundo_nombre VARCHAR(50),
    primer_apellido VARCHAR(50),
    segundo_apellido VARCHAR(50),
    id_tipo_documento DECIMAL(4,0),
    id_direccion INTEGER,
    documento_acudiente VARCHAR(12),
    estado_actual VARCHAR(50) NOT NULL,
    CHECK (estado_actual IN ('En proceso de ingreso', 'Inscrito', 'Aprobado', 'Cursando', 'Graduado', 'Expulsado', 'Retirado')),
    nivel_riesgo VARCHAR(50),
    FOREIGN KEY (id_tipo_documento) REFERENCES TipoDocumento(id_tipo_documento),
    FOREIGN KEY (id_direccion) REFERENCES Direcciones(id_direccion),
    FOREIGN KEY (documento_acudiente) REFERENCES Acudientes(documento_acudiente)
);


CREATE TABLE TelefonosCamper (
    id_tel_camper INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_telefono INTEGER,
    documento_camper VARCHAR(12),
    FOREIGN KEY (id_telefono) REFERENCES Telefonos(id_telefono),
    FOREIGN KEY (documento_camper) REFERENCES Campers(documento_camper)
);

CREATE TABLE Rutas (
    id_ruta DECIMAL(3,0) PRIMARY KEY,
    nombre VARCHAR(100),
    sgdb_principal VARCHAR(100),
    sgdb_secundario VARCHAR(100)
);

CREATE TABLE Modulos (
    id_modulo DECIMAL(5,0) PRIMARY KEY,
    nombre VARCHAR(80),
    horas_duracion DECIMAL(2,0)
);

CREATE TABLE ModulosRuta (
    id_mod_ruta DECIMAL(5,0) PRIMARY KEY,
    id_ruta DECIMAL(3,0),
    id_modulo DECIMAL(5,0),
    FOREIGN KEY (id_ruta) REFERENCES Rutas(id_ruta),
    FOREIGN KEY (id_modulo) REFERENCES Modulos(id_modulo)
);

CREATE TABLE Evaluaciones (
    id_evaluacion INTEGER PRIMARY KEY AUTO_INCREMENT,
    documento_camper VARCHAR(12),
    id_modulo DECIMAL(5,0),
    evaluacion_teorica DECIMAL(5,2),
    evaluacion_practica DECIMAL(5,2),
    trabajos_quizzes DECIMAL(5,2),
    nota_final DECIMAL(5,2),
    FOREIGN KEY (documento_camper) REFERENCES Campers(documento_camper),
    FOREIGN KEY (id_modulo) REFERENCES Modulos(id_modulo)
);

CREATE TABLE AreasEntrenamiento (
    id_area DECIMAL(3,0) PRIMARY KEY,
    nombre VARCHAR(80),
    capacidad_maxima DECIMAL(2,0)
    
);

CREATE TABLE Trainers (
    documento_trainer VARCHAR(12) PRIMARY KEY,
    primer_nombre VARCHAR(50),
    segundo_nombre VARCHAR(50),
    primer_apellido VARCHAR(50),
    segundo_apellido VARCHAR(50),
    id_tipo_documento DECIMAL(4,0),
    id_telefono INTEGER,
    FOREIGN KEY (id_tipo_documento) REFERENCES TipoDocumento(id_tipo_documento),
    FOREIGN KEY (id_telefono) REFERENCES Telefonos(id_telefono)
);

CREATE TABLE Grupos (
    id_grupo VARCHAR(5) PRIMARY KEY,
    documento_trainer VARCHAR(12),
    id_area DECIMAL(3,0),
    id_ruta DECIMAL(3,0),
    hora_inicio TIME,
    hora_fin TIME,
    cupos_disponibles DECIMAL(2,0) ,
    FOREIGN KEY (documento_trainer) REFERENCES Trainers(documento_trainer),
    FOREIGN KEY (id_area) REFERENCES AreasEntrenamiento(id_area),
    FOREIGN KEY (id_ruta) REFERENCES Rutas(id_ruta)
);

CREATE TABLE CampersGrupo (
    id_camp_grup INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_grupo VARCHAR(5),
    documento_camper VARCHAR(12),
    FOREIGN KEY (id_grupo) REFERENCES Grupos(id_grupo),
    FOREIGN KEY (documento_camper) REFERENCES Campers(documento_camper)
);


CREATE TABLE HistorialEstadosCampers (
    id_historial INTEGER PRIMARY KEY AUTO_INCREMENT,
    documento_camper VARCHAR(12),
    estado_anterior VARCHAR(50) NOT NULL,
    estado_nuevo VARCHAR(50) NOT NULL,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    CHECK (estado_anterior IN ('En proceso de ingreso', 'Inscrito', 'Aprobado', 'Cursando', 'Graduado', 'Expulsado', 'Retirado')),
    CHECK (estado_nuevo IN ('En proceso de ingreso', 'Inscrito', 'Aprobado', 'Cursando', 'Graduado', 'Expulsado', 'Retirado')),
    FOREIGN KEY (documento_camper) REFERENCES Campers(documento_camper)
);



CREATE TABLE Egresados (
    documento_camper VARCHAR(12) PRIMARY KEY,
    primer_nombre VARCHAR(50),
    segundo_nombre VARCHAR(50),
    primer_apellido VARCHAR(50),
    segundo_apellido VARCHAR(50),
    id_ruta DECIMAL(3,0),
    fecha_graduacion DATE,
    FOREIGN KEY (id_ruta) REFERENCES Rutas(id_ruta)
);


CREATE TABLE Asistencia (
    id_asistencia INTEGER PRIMARY KEY AUTO_INCREMENT,
    documento_camper VARCHAR(12),
    id_area DECIMAL(3,0),
    fecha DATE NOT NULL,
    hora_entrada TIME NOT NULL,
    hora_salida TIME,
    FOREIGN KEY (documento_camper) REFERENCES Campers(documento_camper),
    FOREIGN KEY (id_area) REFERENCES AreasEntrenamiento(id_area)
);


CREATE TABLE TrainersModulos (
    id_trainer_modulo INTEGER PRIMARY KEY AUTO_INCREMENT,
    documento_trainer VARCHAR(12),
    id_modulo DECIMAL(5,0),
    FOREIGN KEY (documento_trainer) REFERENCES Trainers(documento_trainer),
    FOREIGN KEY (id_modulo) REFERENCES Modulos(id_modulo)
);
