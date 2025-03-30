SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE TipoDocumento;
TRUNCATE TABLE Direcciones;
TRUNCATE TABLE Telefonos;
TRUNCATE TABLE Acudientes;
TRUNCATE TABLE Campers;
TRUNCATE TABLE TelefonosCamper;
TRUNCATE TABLE Rutas;
TRUNCATE TABLE Modulos;
TRUNCATE TABLE ModulosRuta;
TRUNCATE TABLE Evaluaciones;
TRUNCATE TABLE AreasEntrenamiento;
TRUNCATE TABLE Trainers;
TRUNCATE TABLE Grupos;
TRUNCATE TABLE CampersGrupo;
TRUNCATE TABLE HistorialEstadosCampers;
TRUNCATE TABLE Egresados;
TRUNCATE TABLE Asistencia;
TRUNCATE TABLE TrainersModulos;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO TipoDocumento (id_tipo_documento, nombre) VALUES
(1, 'Cédula de Ciudadanía'),
(2, 'Tarjeta de Identidad'),
(3, 'Pasaporte'),
(4, 'Cédula de Extranjería'),
(5, 'Registro Civil');


INSERT INTO Direcciones (tipo_via, nombre_via, complemento, numero, sufijo, vecindario, ciudad, departamento, pais) VALUES
('Calle', '106a', 'Altoviento 1', '34-58', NULL, 'Altoviento', 'Bucaramanga', 'Santander', 'Colombia'),
('Carrera', '15', 'Edificio Torre Central', '45-12', 'Sur', 'Cabecera', 'Bucaramanga', 'Santander', 'Colombia'),
('Avenida', 'Boyacá', 'Conjunto Los Almendros', '90-15', NULL, 'Engativá', 'Bogotá', 'Cundinamarca', 'Colombia'),
('Calle', '50', 'Apto 301', '120-07', NULL, 'Laureles', 'Medellín', 'Antioquia', 'Colombia'),
('Diagonal', '32', 'Casa Esquinera', '87-23', 'Este', 'El Prado', 'Barranquilla', 'Atlántico', 'Colombia'),
('Carrera', '11', 'Torre Azul', '25-50', NULL, 'Chapinero', 'Bogotá', 'Cundinamarca', 'Colombia'),
('Avenida', 'Las Américas', 'Local 5', '78-34', NULL, 'San Fernando', 'Cali', 'Valle del Cauca', 'Colombia'),
('Calle', '8', 'Barrio Los Rosales', '56-89', NULL, 'El Poblado', 'Medellín', 'Antioquia', 'Colombia'),
('Transversal', '93', 'Casa Verde', '100-12', NULL, 'Suba', 'Bogotá', 'Cundinamarca', 'Colombia'),
('Carrera', '7', 'Edificio Torres del Norte', '32-45', NULL, 'Centro', 'Pereira', 'Risaralda', 'Colombia'),
('Avenida', 'Ferrocarril', 'Bodega 10', '450-89', NULL, 'Belén', 'Medellín', 'Antioquia', 'Colombia'),
('Calle', '13', 'Local 201', '98-76', NULL, 'San Francisco', 'Cartagena', 'Bolívar', 'Colombia'),
('Carrera', '50', 'Edificio Blanco', '65-14', NULL, 'Granada', 'Cali', 'Valle del Cauca', 'Colombia'),
('Calle', '25', 'Frente al parque', '88-22', NULL, 'Villa Olímpica', 'Cúcuta', 'Norte de Santander', 'Colombia'),
('Diagonal', '75', 'Casa Amarilla', '12-56', NULL, 'Villa Carolina', 'Barranquilla', 'Atlántico', 'Colombia'),
('Calle', '19', 'Sector Universidades', '45-89', NULL, 'Ciudad Jardín', 'Pasto', 'Nariño', 'Colombia'),
('Carrera', '100', 'Torre Empresarial', '33-77', NULL, 'Ciudad Salitre', 'Bogotá', 'Cundinamarca', 'Colombia'),
('Avenida', 'Circunvalar', 'Mall Central', '200-55', NULL, 'Poblado', 'Medellín', 'Antioquia', 'Colombia'),
('Transversal', '54', 'Frente a la iglesia', '10-90', NULL, 'Santa Mónica', 'Cali', 'Valle del Cauca', 'Colombia'),
('Carrera', '21', 'Esquina Roja', '76-30', NULL, 'Campo Hermoso', 'Bucaramanga', 'Santander', 'Colombia');


INSERT INTO Telefonos (numero_telefono, prefijo_telefonico) VALUES
(3001234567, 57),
(3019876543, 57),
(3024567890, 57),
(3036789123, 57),
(3043456789, 57),
(3055678901, 57),
(3067890123, 57),
(3078901234, 57),
(3089012345, 57),
(3090123456, 57),
(3102345678, 57),
(3113456789, 57),
(3124567890, 57),
(3135678901, 57),
(3146789012, 57),
(3157890123, 57),
(3168901234, 57),
(3179012345, 57),
(3180123456, 57),
(3191234567, 57);


INSERT INTO Acudientes (documento_acudiente, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, id_tipo_documento, id_telefono, id_direccion) VALUES
('1000123456', 'Carlos', 'Alberto', 'Gómez', 'Pérez', 1, 1, 1),
('1000234567', 'María', 'Fernanda', 'López', 'Rodríguez', 1, 2, 2),
('1000345678', 'Jorge', 'Eduardo', 'Martínez', 'García', 1, 3, 3),
('1000456789', 'Ana', 'Cristina', 'Ramírez', 'Fernández', 1, 4, 4),
('1000567890', 'Luis', 'Felipe', 'Sánchez', 'Torres', 1, 5, 5),
('1000678901', 'Diana', 'Carolina', 'Castro', 'Gómez', 1, 6, 6),
('1000789012', 'Ricardo', 'Andrés', 'Hernández', 'Mendoza', 1, 7, 7),
('1000890123', 'Paola', 'Marcela', 'Ortega', 'Jiménez', 1, 8, 8),
('1000901234', 'Felipe', 'José', 'Reyes', 'Castaño', 1, 9, 9),
('1001012345', 'Natalia', 'Andrea', 'Muñoz', 'Vargas', 1, 10, 10),
('1001123456', 'Javier', 'Esteban', 'Pineda', 'Ramírez', 1, 11, 11),
('1001234567', 'Carmen', 'Sofía', 'Gutiérrez', 'Herrera', 1, 12, 12),
('1001345678', 'Sergio', 'Alejandro', 'Moreno', 'Rojas', 1, 13, 13),
('1001456789', 'Laura', 'Beatriz', 'Peña', 'Salazar', 1, 14, 14),
('1001567890', 'Hernán', 'Ricardo', 'Quintero', 'Velásquez', 1, 15, 15),
('1001678901', 'Adriana', 'Patricia', 'Chávez', 'Guerrero', 1, 16, 16),
('1001789012', 'Francisco', 'Antonio', 'Salinas', 'Montoya', 1, 17, 17),
('1001890123', 'Gloria', 'Teresa', 'Delgado', 'Álvarez', 1, 18, 18),
('1001901234', 'Oscar', 'Iván', 'Ramos', 'Medina', 1, 19, 19),
('1002012345', 'Andrea', 'Juliana', 'Bermúdez', 'Soto', 1, 20, 20);


INSERT INTO Campers (documento_camper, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, id_tipo_documento, id_direccion, documento_acudiente, estado_actual, nivel_riesgo) VALUES
('2000123456', 'Juan', 'David', 'Pérez', 'Gómez', 1, 1, '1000123456', 'Inscrito', 'Bajo'),
('2000234567', 'Sofía', 'Alejandra', 'López', 'Martínez', 1, 2, '1000234567', 'Cursando', 'Medio'),
('2000345678', 'Mateo', 'Andrés', 'Ramírez', 'Fernández', 1, 3, '1000345678', 'En proceso de ingreso', 'Alto'),
('2000456789', 'Valentina', 'Paula', 'Sánchez', 'Torres', 1, 4, '1000456789', 'Graduado', 'Bajo'),
('2000567890', 'Diego', 'Fernando', 'Castro', 'Gómez', 1, 5, '1000567890', 'Expulsado', 'Alto'),
('2000678901', 'Camila', 'Andrea', 'Hernández', 'Mendoza', 1, 6, '1000678901', 'Cursando', 'Medio'),
('2000789012', 'Sebastián', 'Julián', 'Ortega', 'Jiménez', 1, 7, '1000789012', 'Inscrito', 'Bajo'),
('2000890123', 'Mariana', 'Carolina', 'Reyes', 'Castaño', 1, 8, '1000890123', 'Retirado', 'Medio'),
('2000901234', 'Andrés', 'Felipe', 'Muñoz', 'Vargas', 1, 9, '1000901234', 'Cursando', 'Bajo'),
('2001012345', 'Daniela', 'Lucía', 'Pineda', 'Ramírez', 1, 10, '1001012345', 'Aprobado', 'Medio'),
('2001123456', 'Carlos', 'Esteban', 'Gutiérrez', 'Herrera', 1, 11, '1001123456', 'Graduado', 'Bajo'),
('2001234567', 'Fernanda', 'Patricia', 'Moreno', 'Rojas', 1, 12, '1001234567', 'Cursando', 'Alto'),
('2001345678', 'Gabriel', 'Ricardo', 'Peña', 'Salazar', 1, 13, '1001345678', 'En proceso de ingreso', 'Bajo'),
('2001456789', 'Sara', 'Isabel', 'Quintero', 'Velásquez', 1, 14, '1001456789', 'Cursando', 'Medio'),
('2001567890', 'Tomás', 'Alexander', 'Chávez', 'Guerrero', 1, 15, '1001567890', 'Inscrito', 'Bajo'),
('2001678901', 'Julieta', 'María', 'Salinas', 'Montoya', 1, 16, '1001678901', 'Expulsado', 'Alto'),
('2001789012', 'Hugo', 'Antonio', 'Delgado', 'Álvarez', 1, 17, '1001789012', 'Cursando', 'Bajo'),
('2001890123', 'Paula', 'Fernanda', 'Ramos', 'Medina', 1, 18, '1001890123', 'Aprobado', 'Medio'),
('2001901234', 'Samuel', 'Iván', 'Bermúdez', 'Soto', 1, 19, '1001901234', 'Graduado', 'Bajo'),
('2002012345', 'Elena', 'Juliana', 'Gómez', 'Ramírez', 1, 20, '1002012345', 'Retirado', 'Medio');


INSERT INTO TelefonosCamper (id_telefono, documento_camper) VALUES
(1, '2000123456'),
(2, '2000234567'),
(3, '2000345678'),
(4, '2000456789'),
(5, '2000567890'),
(6, '2000678901'),
(7, '2000789012'),
(8, '2000890123'),
(9, '2000901234'),
(10, '2001012345'),
(11, '2001123456'),
(12, '2001234567'),
(13, '2001345678'),
(14, '2001456789'),
(15, '2001567890'),
(16, '2001678901'),
(17, '2001789012'),
(18, '2001890123'),
(19, '2001901234'),
(20, '2002012345');


INSERT INTO Rutas (id_ruta, nombre, sgdb_principal, sgdb_secundario) VALUES
(1, 'Spring Boot', 'PostgreSQL', 'MySQL'),
(2, 'Django', 'MariaDB', 'SQLite'),
(3, 'Ruby on Rails', 'PostgreSQL', 'MongoDB'),
(4, 'Express.js', 'MySQL', 'MongoDB'),
(5, 'Laravel', 'PostgreSQL', 'SQLite'),
(6, 'Flask', 'MySQL', 'PostgreSQL'),
(7, 'FastAPI', 'MongoDB', 'PostgreSQL'),
(8, 'Angular', 'MariaDB', 'SQLite'),
(9, 'React', 'MySQL', 'MongoDB'),
(10, 'Vue.js', 'PostgreSQL', 'MariaDB'),
(11, 'ASP.NET Core', 'SQL Server', 'PostgreSQL'),
(12, 'Svelte', 'SQLite', 'MongoDB'),
(13, 'Phoenix (Elixir)', 'PostgreSQL', 'MySQL'),
(14, 'Next.js', 'MySQL', 'SQLite'),
(15, 'NestJS', 'PostgreSQL', 'MongoDB');


INSERT INTO Modulos (id_modulo, nombre, horas_duracion) VALUES
(1001, 'Introducción a la algoritmia', 30),
(1002, 'PSeInt', 20),
(1003, 'Python', 50),
(1004, 'HTML', 30),
(1005, 'CSS', 30),
(1006, 'Bootstrap', 40),
(1007, 'Java', 70),
(1008, 'JavaScript', 50),
(1009, 'C#', 60),
(1010, 'MySQL', 50),
(1011, 'MongoDB', 50),
(1012, 'PostgreSQL', 50),
(1013, 'NetCore', 70),
(1014, 'Spring Boot', 80),
(1015, 'NodeJS', 60),
(1016, 'Express', 50);


INSERT INTO ModulosRuta (id_mod_ruta, id_ruta, id_modulo) VALUES
(10001, 1, 1001),
(10002, 2, 1001),
(10003, 3, 1001),
(10004, 4, 1001),
(10005, 5, 1001),
(10006, 6, 1001),
(10007, 7, 1001),
(10008, 8, 1001),
(10009, 9, 1001),
(10010, 10, 1001),
(10011, 1, 1002),
(10012, 2, 1002),
(10013, 3, 1002),
(10014, 4, 1002),
(10015, 5, 1002),
(10016, 6, 1002),
(10017, 7, 1002),
(10018, 8, 1002),
(10019, 9, 1002),
(10020, 10, 1002),
(10021, 1, 1003),
(10022, 2, 1003),
(10023, 3, 1003),
(10024, 4, 1003),
(10025, 5, 1003),
(10026, 6, 1003),
(10027, 7, 1003),
(10028, 8, 1003),
(10029, 9, 1003),
(10030, 10, 1003),
(10031, 8, 1004),
(10032, 9, 1004),
(10033, 10, 1004),
(10034, 8, 1005),
(10035, 9, 1005),
(10036, 10, 1005),
(10037, 8, 1006),
(10038, 9, 1006),
(10039, 10, 1006),
(10040, 1, 1007),
(10041, 3, 1008),
(10042, 4, 1008),
(10043, 11, 1009),
(10044, 1, 1010),
(10045, 2, 1011),
(10046, 3, 1012),
(10047, 4, 1010),
(10048, 5, 1012),
(10049, 6, 1010),
(10050, 7, 1011),
(10051, 8, 1012),
(10052, 9, 1010),
(10053, 10, 1012),
(10054, 11, 1013),
(10055, 1, 1014),
(10056, 4, 1015),
(10057, 4, 1016);


INSERT INTO Evaluaciones (documento_camper, id_modulo, evaluacion_teorica, evaluacion_practica, trabajos_quizzes, nota_final) VALUES
('2000123456', 1001, 85.50, 90.00, 88.00, 87.83),
('2000234567', 1002, 78.00, 82.50, 80.00, 80.17),
('2000345678', 1003, 92.00, 95.50, 94.00, 93.83),
('2000456789', 1004, 88.50, 87.00, 89.00, 88.17),
('2000567890', 1005, 76.00, 80.00, 78.00, 78.00),
('2000678901', 1006, 95.00, 97.50, 96.00, 96.17),
('2000789012', 1007, 85.50, 89.00, 86.50, 87.00),
('2000890123', 1008, 79.00, 83.50, 81.00, 81.83),
('2000901234', 1009, 91.00, 94.50, 92.00, 92.83),
('2001012345', 1010, 87.50, 86.00, 88.00, 87.17),
('2001123456', 1011, 82.00, 85.00, 83.00, 83.33),
('2001234567', 1012, 90.50, 92.50, 91.00, 91.33),
('2001345678', 1013, 78.50, 81.00, 79.50, 79.67),
('2001456789', 1014, 96.00, 98.50, 97.00, 97.17),
('2001567890', 1015, 84.00, 87.50, 85.50, 85.67),
('2001678901', 1016, 81.50, 85.00, 83.50, 83.83);


INSERT INTO AreasEntrenamiento (id_area, nombre, capacidad_maxima) VALUES
(1, 'Apolo', 33),
(2, 'Sputnik', 33),
(3, 'Artemis', 33),
(4, 'Voyager', 33),
(5, 'Hubble', 33),
(6, 'Galileo', 33),
(7, 'Cassini', 33),
(8, 'Kepler', 33),
(9, 'Pioneer', 33),
(10, 'Orion', 33),
(11, 'Venus', 33),
(12, 'Luna', 33),
(13, 'Júpiter', 33),
(14, 'Neptuno', 33),
(15, 'Andrómeda', 33);


INSERT INTO Trainers (documento_trainer, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, id_tipo_documento, id_telefono) VALUES
('9000123456', 'Jholver', 'José', 'Pardo', 'Gómez', 1, 1),
('9000234567', 'Pedro', NULL, 'Sánchez', 'López', 1, 2),
('9000345678', 'Miguel', NULL, 'Castro', 'Martínez', 1, 3),
('9000456789', 'Michael', NULL, 'Garzón', 'Rodríguez', 1, 4),
('9000567890', 'Carolina', 'Andrea', 'Fernández', 'Torres', 1, 5),
('9000678901', 'Juan', 'Sebastián', 'Ortiz', 'Ramírez', 1, 6),
('9000789012', 'Daniela', 'Paola', 'Gutiérrez', 'Díaz', 1, 7),
('9000890123', 'Luis', 'Felipe', 'Mendoza', 'Jiménez', 1, 8),
('9000901234', 'Camila', 'Alejandra', 'Romero', 'Vargas', 1, 9),
('9001012345', 'Andrés', 'Mauricio', 'Herrera', 'Castro', 1, 10),
('9001123456', 'Valentina', 'Sofía', 'Ruiz', 'Méndez', 1, 11),
('9001234567', 'Felipe', 'Armando', 'González', 'Pérez', 1, 12),
('9001345678', 'Laura', 'Isabel', 'Cárdenas', 'Suárez', 1, 13),
('9001456789', 'Santiago', 'Javier', 'Morales', 'Peña', 1, 14),
('9001567890', 'Jessica', 'Lorena', 'Navarro', 'Figueroa', 1, 15);

INSERT INTO Grupos (id_grupo, documento_trainer, id_area, id_ruta, hora_inicio, hora_fin, cupos_disponibles) VALUES
('J001', '9000123456', 1, 1, '08:00:00', '11:30:00', 25),
('P002', '9000234567', 2, 2, '08:00:00', '11:30:00', 18),
('M003', '9000345678', 3, 3, '08:00:00', '11:30:00', 30),
('M004', '9000456789', 4, 4, '08:00:00', '11:30:00', 22),
('J005', '9000567890', 5, 5, '08:00:00', '11:30:00', 28),
('P006', '9000678901', 6, 6, '08:00:00', '11:30:00', 15),
('M007', '9000789012', 7, 7, '08:00:00', '11:30:00', 10),
('M008', '9000890123', 8, 8, '08:00:00', '11:30:00', 33),
('J009', '9000901234', 9, 9, '08:00:00', '11:30:00', 5),
('P010', '9001012345', 10, 10, '08:00:00', '11:30:00', 0),
('M011', '9001123456', 11, 11, '08:00:00', '11:30:00', 12),
('M012', '9001234567', 12, 12, '08:00:00', '11:30:00', 7),
('J013', '9001345678', 13, 13, '08:00:00', '11:30:00', 3),
('P014', '9001456789', 14, 14, '08:00:00', '11:30:00', 20),
('M015', '9001567890', 15, 15, '08:00:00', '11:30:00', 27),
('J016', '9000123456', 1, 2, '11:30:00', '15:00:00', 22),
('P017', '9000234567', 2, 3, '11:30:00', '15:00:00', 16),
('M018', '9000345678', 3, 4, '11:30:00', '15:00:00', 10),
('M019', '9000456789', 4, 5, '11:30:00', '15:00:00', 30),
('J020', '9000567890', 5, 6, '11:30:00', '15:00:00', 8),
('P021', '9000678901', 6, 7, '11:30:00', '15:00:00', 14),
('M022', '9000789012', 7, 8, '11:30:00', '15:00:00', 5),
('M023', '9000890123', 8, 9, '11:30:00', '15:00:00', 9),
('J024', '9000901234', 9, 10, '11:30:00', '15:00:00', 12),
('P025', '9001012345', 10, 11, '11:30:00', '15:00:00', 1),
('M026', '9001123456', 11, 12, '11:30:00', '15:00:00', 3),
('M027', '9001234567', 12, 13, '11:30:00', '15:00:00', 6),
('J028', '9001345678', 13, 14, '11:30:00', '15:00:00', 25),
('P029', '9001456789', 14, 15, '11:30:00', '15:00:00', 19),
('M030', '9001567890', 15, 1, '11:30:00', '15:00:00', 8);


INSERT INTO CampersGrupo (id_grupo, documento_camper) VALUES
('J001', '2000123456'),
('P002', '2000234567'),
('M003', '2000345678'),
('M004', '2000456789'),
('J005', '2000567890'),
('P006', '2000678901'),
('M007', '2000789012'),
('M008', '2000890123'),
('J009', '2000901234'),
('P010', '2001012345'),
('M011', '2001123456'),
('M012', '2001234567'),
('J013', '2001345678'),
('P014', '2001456789'),
('M015', '2001567890'),
('J016', '2001678901'),
('P017', '2001789012'),
('M018', '2001890123'),
('M019', '2001901234'),
('J020', '2002012345');


INSERT INTO HistorialEstadosCampers (documento_camper, estado_anterior, estado_nuevo, fecha_cambio) VALUES
('2000123456', 'En proceso de ingreso', 'Inscrito', '2024-01-10 08:30:00'),
('2000123456', 'Inscrito', 'Aprobado', '2024-01-20 09:00:00'),
('2000123456', 'Aprobado', 'Cursando', '2024-02-01 10:15:00'),
('2000234567', 'Inscrito', 'Aprobado', '2024-02-10 11:00:00'),
('2000234567', 'Aprobado', 'Cursando', '2024-02-15 10:45:00'),
('2000345678', 'Cursando', 'Graduado', '2024-06-20 14:00:00'),
('2000456789', 'En proceso de ingreso', 'Inscrito', '2024-03-05 09:15:00'),
('2000456789', 'Inscrito', 'Expulsado', '2024-04-12 16:20:00'),
('2000567890', 'Cursando', 'Retirado', '2024-05-30 11:10:00'),
('2000678901', 'Inscrito', 'Aprobado', '2024-04-02 13:35:00'),
('2000678901', 'Aprobado', 'Cursando', '2024-04-15 09:50:00'),
('2000789012', 'En proceso de ingreso', 'Inscrito', '2024-02-28 08:50:00'),
('2000789012', 'Inscrito', 'Aprobado', '2024-03-10 10:30:00'),
('2000789012', 'Aprobado', 'Cursando', '2024-03-20 14:00:00'),
('2000890123', 'Cursando', 'Graduado', '2024-07-10 17:40:00'),
('2000901234', 'Inscrito', 'Aprobado', '2024-05-05 14:20:00'),
('2000901234', 'Aprobado', 'Cursando', '2024-05-15 12:30:00'),
('2001012345', 'Cursando', 'Expulsado', '2024-06-25 12:10:00'),
('2001123456', 'En proceso de ingreso', 'Inscrito', '2024-03-18 07:45:00'),
('2001123456', 'Inscrito', 'Aprobado', '2024-04-01 09:00:00'),
('2001123456', 'Aprobado', 'Cursando', '2024-04-10 11:30:00'),
('2001234567', 'Cursando', 'Graduado', '2024-08-14 15:00:00'),
('2001345678', 'En proceso de ingreso', 'Inscrito', '2024-04-10 10:00:00'),
('2001345678', 'Inscrito', 'Aprobado', '2024-04-20 12:00:00'),
('2001345678', 'Aprobado', 'Cursando', '2024-05-01 13:30:00'),
('2001456789', 'Cursando', 'Retirado', '2024-07-30 16:30:00'),
('2001567890', 'Inscrito', 'Aprobado', '2024-05-14 12:20:00'),
('2001567890', 'Aprobado', 'Cursando', '2024-05-25 15:10:00'),
('2001678901', 'Cursando', 'Expulsado', '2024-06-09 14:55:00'),
('2001789012', 'Cursando', 'Graduado', '2024-09-12 15:20:00'),
('2001890123', 'Inscrito', 'Aprobado', '2024-02-27 11:05:00'),
('2001890123', 'Aprobado', 'Cursando', '2024-03-10 13:00:00'),
('2001901234', 'Cursando', 'Retirado', '2024-07-05 13:15:00'),
('2002012345', 'En proceso de ingreso', 'Inscrito', '2024-03-03 09:40:00'),
('2002012345', 'Inscrito', 'Aprobado', '2024-03-15 10:20:00'),
('2002012345', 'Aprobado', 'Cursando', '2024-04-01 14:00:00');



INSERT INTO Egresados (documento_camper, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, id_ruta, fecha_graduacion) VALUES
('2000123456', 'Carlos', 'Andrés', 'López', 'García', 1, '2024-06-15'),
('2000234567', 'María', 'Fernanda', 'Gómez', 'Rodríguez', 2, '2024-07-10'),
('2000345678', 'Javier', 'Eduardo', 'Martínez', 'Pérez', 3, '2024-08-05'),
('2000456789', 'Paula', 'Andrea', 'Ramírez', 'Hernández', 4, '2024-09-20'),
('2000567890', 'Daniel', 'Alejandro', 'Torres', 'Castro', 5, '2024-10-30'),
('2000678901', 'Laura', 'Isabel', 'Fernández', 'Mendoza', 6, '2024-06-25'),
('2000789012', 'José', 'Luis', 'Ortega', 'Suárez', 7, '2024-07-15'),
('2000890123', 'Camila', 'Beatriz', 'Morales', 'Díaz', 8, '2024-08-25'),
('2000901234', 'Alejandro', 'David', 'Silva', 'Rojas', 9, '2024-09-30'),
('2001012345', 'Sofía', 'Natalia', 'Pérez', 'Vargas', 10, '2024-10-10'),
('2001123456', 'Juan', 'Sebastián', 'García', 'Luna', 11, '2024-06-12'),
('2001234567', 'Valentina', 'Mariana', 'Castro', 'Mejía', 12, '2024-07-18'),
('2001345678', 'Luis', 'Miguel', 'Hernández', 'Salazar', 13, '2024-08-08'),
('2001456789', 'Andrea', 'Patricia', 'Ríos', 'Córdoba', 14, '2024-09-27'),
('2001567890', 'Tomás', 'Felipe', 'Vargas', 'Ortega', 15, '2024-10-22');


INSERT INTO Asistencia (documento_camper, id_area, fecha, hora_entrada, hora_salida) VALUES
('2000123456', 1, '2024-03-25', '08:00:00', '11:30:00'),
('2000234567', 2, '2024-03-25', '08:15:00', '11:45:00'),
('2000345678', 3, '2024-03-25', '08:30:00', '12:00:00'),
('2000456789', 4, '2024-03-26', '08:00:00', '11:30:00'),
('2000567890', 5, '2024-03-26', '08:15:00', '11:45:00'),
('2000678901', 1, '2024-03-26', '08:30:00', '12:00:00'),
('2000789012', 2, '2024-03-27', '08:00:00', '11:30:00'),
('2000890123', 3, '2024-03-27', '08:15:00', '11:45:00'),
('2000901234', 4, '2024-03-27', '08:30:00', '12:00:00'),
('2001012345', 5, '2024-03-28', '08:00:00', '11:30:00'),
('2001123456', 1, '2024-03-28', '08:15:00', '11:45:00'),
('2001234567', 2, '2024-03-28', '08:30:00', '12:00:00'),
('2001345678', 3, '2024-03-29', '08:00:00', '11:30:00'),
('2001456789', 4, '2024-03-29', '08:15:00', '11:45:00'),
('2001567890', 5, '2024-03-29', '08:30:00', '12:00:00');


INSERT INTO TrainersModulos (documento_trainer, id_modulo) VALUES
('9000123456', 1001),
('9000123456', 1002),
('9000234567', 1003),
('9000234567', 1004),
('9000345678', 1005),
('9000345678', 1006),
('9000456789', 1007),
('9000456789', 1008),
('9000567890', 1009),
('9000567890', 1010),
('9000678901', 1011),
('9000678901', 1012),
('9000789012', 1013),
('9000789012', 1014),
('9000890123', 1015),
('9000890123', 1016);
