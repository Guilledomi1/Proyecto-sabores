DROP DATABASE IF EXISTS SaboresdelMundo;
CREATE DATABASE SaboresdelMundo;
USE SaboresdelMundo;

CREATE TABLE Roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT
    );
    
    CREATE TABLE Permisos (
    id_permiso INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT
);

CREATE TABLE Roles_Permisos (
    id_rol INT,
    id_permiso INT,
    PRIMARY KEY (id_rol, id_permiso),
    FOREIGN KEY (id_rol) REFERENCES Roles(id_rol) ON DELETE CASCADE,
    FOREIGN KEY (id_permiso) REFERENCES Permisos(id_permiso) ON DELETE CASCADE
);

CREATE TABLE Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    id_rol INT,
    FOREIGN KEY (id_rol) REFERENCES Roles(id_rol) ON DELETE SET NULL
);

CREATE TABLE Categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT
);

CREATE TABLE Etiquetas (
    id_etiqueta INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT
);

CREATE TABLE Ingredientes (
    id_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

CREATE TABLE Unidades_Medida (
    id_unidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    abreviatura VARCHAR(10)
);

CREATE TABLE Paises (
    id_pais INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigo CHAR(2) NOT NULL
);

CREATE TABLE Recetas (
    id_receta INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    descripcion TEXT,
    tiempo_preparacion INT NOT NULL,
    dificultad VARCHAR(20) NOT NULL,
    porciones INT NOT NULL,
    instrucciones TEXT,
    id_usuario INT,
    id_categoria INT,
    id_pais INT,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE SET NULL,
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria) ON DELETE SET NULL,
    FOREIGN KEY (id_pais) REFERENCES Paises(id_pais) ON DELETE SET NULL
);

CREATE TABLE Recetas_Etiquetas (
    id_receta INT,
    id_etiqueta INT,
    PRIMARY KEY (id_receta, id_etiqueta),
    FOREIGN KEY (id_receta) REFERENCES Recetas(id_receta) ON DELETE CASCADE,
    FOREIGN KEY (id_etiqueta) REFERENCES Etiquetas(id_etiqueta) ON DELETE CASCADE
);

CREATE TABLE Recetas_Ingredientes (
    id_receta INT,
    id_ingrediente INT,
    cantidad DECIMAL(10,2) NOT NULL,
    id_unidad INT,
    notas TEXT,
    PRIMARY KEY (id_receta, id_ingrediente),
    FOREIGN KEY (id_receta) REFERENCES Recetas(id_receta) ON DELETE CASCADE,
    FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente) ON DELETE CASCADE,
    FOREIGN KEY (id_unidad) REFERENCES Unidades_Medida(id_unidad) ON DELETE SET NULL
);

CREATE TABLE Pasos_Receta (
    id_paso INT AUTO_INCREMENT PRIMARY KEY,
    id_receta INT,
    numero_paso INT NOT NULL,
    descripcion TEXT NOT NULL,
    FOREIGN KEY (id_receta) REFERENCES Recetas(id_receta) ON DELETE CASCADE
);

CREATE TABLE Comentarios (
    id_comentario INT AUTO_INCREMENT PRIMARY KEY,
    id_receta INT,
    id_usuario INT,
    texto TEXT NOT NULL,
    FOREIGN KEY (id_receta) REFERENCES Recetas(id_receta) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE SET NULL
);

CREATE TABLE Valoraciones (
    id_valoracion INT AUTO_INCREMENT PRIMARY KEY,
    id_receta INT,
    id_usuario INT,
    puntuacion DECIMAL(2,1) NOT NULL,
    FOREIGN KEY (id_receta) REFERENCES Recetas(id_receta) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE SET NULL,
    CONSTRAINT check_puntuacion CHECK (puntuacion >= 0 AND puntuacion <= 5)
);

CREATE TABLE Favoritos (
    id_usuario INT,
    id_receta INT,
    PRIMARY KEY (id_usuario, id_receta),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_receta) REFERENCES Recetas(id_receta) ON DELETE CASCADE
);

INSERT INTO Roles (nombre, descripcion) VALUES
('Administrador', 'Control total del sistema'),
('Editor', 'Puede crear y editar contenido'),
('Usuario Premium', 'Usuario con acceso a funciones premium'),
('Usuario Estándar', 'Usuario con acceso básico'),
('Chef Verificado', 'Chef profesional verificado'),
('Moderador', 'Puede moderar comentarios y contenido'),
('Nutricionista', 'Especialista en nutrición'),
('Invitado', 'Usuario no registrado con acceso limitado'),
('Colaborador', 'Puede contribuir con contenido'),
('Bloqueado', 'Usuario con restricciones de acceso');

INSERT INTO Permisos (nombre, descripcion) VALUES
('crear_receta', 'Permiso para crear nuevas recetas'),
('editar_receta', 'Permiso para editar recetas existentes'),
('eliminar_receta', 'Permiso para eliminar recetas'),
('comentar', 'Permiso para comentar en recetas'),
('valorar', 'Permiso para valorar recetas'),
('moderar_comentarios', 'Permiso para moderar comentarios'),
('gestionar_usuarios', 'Permiso para gestionar usuarios'),
('gestionar_categorias', 'Permiso para gestionar categorías'),
('ver_estadisticas', 'Permiso para ver estadísticas del sistema'),
('destacar_receta', 'Permiso para destacar recetas en la página principal');

INSERT INTO Roles_Permisos (id_rol, id_permiso) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10), -- Administrador tiene todos los permisos
(2, 1), (2, 2), (2, 4), (2, 5), (2, 10), -- Editor
(3, 1), (3, 2), (3, 4), (3, 5), -- Usuario Premium
(4, 1), (4, 4), (4, 5), -- Usuario Estándar
(5, 1), (5, 2), (5, 4), (5, 5), (5, 10), -- Chef Verificado
(6, 4), (6, 6), -- Moderador
(7, 1), (7, 2), (7, 4), (7, 5), -- Nutricionista
(9, 1), (9, 4), (9, 5); -- Colaborador

INSERT INTO Usuarios (nombre, apellidos, email, password, id_rol) VALUES
('Admin', 'Sistema', 'admin@sabores.com', 'hashed_password_1', 1),
('María', 'García', 'maria@ejemplo.com', 'hashed_password_2', 3),
('Juan', 'Pérez', 'juan@ejemplo.com', 'hashed_password_3', 4),
('Laura', 'Fernández', 'laura@ejemplo.com', 'hashed_password_4', 4),
('Carlos', 'Rodríguez', 'carlos@ejemplo.com', 'hashed_password_5', 5),
('Ana', 'Martínez', 'ana@ejemplo.com', 'hashed_password_6', 3),
('Miguel', 'López', 'miguel@ejemplo.com', 'hashed_password_7', 4),
('Sofía', 'Sánchez', 'sofia@ejemplo.com', 'hashed_password_8', 7),
('Pablo', 'González', 'pablo@ejemplo.com', 'hashed_password_9', 6),
('Elena', 'Díaz', 'elena@ejemplo.com', 'hashed_password_10', 4);

INSERT INTO Categorias (nombre, descripcion) VALUES
('Italiana', 'Recetas tradicionales de la cocina italiana'),
('Latinoamericana', 'Sabores auténticos de América Latina'),
('Japonesa', 'Cocina tradicional japonesa'),
('Vegana', 'Recetas sin ingredientes de origen animal'),
('Mediterránea', 'Cocina saludable del Mediterráneo'),
('Repostería', 'Postres y dulces de todo el mundo'),
('Comida Rápida', 'Versiones caseras de comida rápida'),
('Asiática', 'Recetas de diferentes países asiáticos'),
('Española', 'Platos tradicionales de la cocina española'),
('Saludable', 'Recetas enfocadas en la alimentación saludable');

INSERT INTO Etiquetas (nombre, descripcion) VALUES
('Popular', 'Recetas más populares entre los usuarios'),
('Nuevo', 'Recetas añadidas recientemente'),
('Saludable', 'Recetas con enfoque en la salud'),
('Rápido', 'Recetas que se preparan en menos de 30 minutos'),
('Sin Gluten', 'Recetas sin ingredientes con gluten'),
('Bajo en Calorías', 'Recetas con menos de 500 calorías por porción'),
('Vegetariano', 'Recetas sin carne pero pueden incluir huevos o lácteos'),
('Picante', 'Recetas con un toque picante'),
('Festivo', 'Recetas ideales para celebraciones'),
('Económico', 'Recetas con ingredientes accesibles y económicos');

INSERT INTO Ingredientes (nombre, descripcion) VALUES
('Filete de pescado blanco', 'Pescado blanco fresco como corvina o mero'),
('Limón', 'Cítrico ácido utilizado para aderezar'),
('Cebolla morada', 'Variedad de cebolla de color morado y sabor suave'),
('Ají limo', 'Chile peruano de sabor picante'),
('Espaguetis', 'Pasta larga y delgada'),
('Guanciale', 'Panceta italiana curada de mejilla de cerdo'),
('Huevo', 'Huevo de gallina entero'),
('Queso Pecorino', 'Queso italiano de leche de oveja'),
('Arroz para sushi', 'Arroz de grano corto para preparar sushi'),
('Alga nori', 'Alga seca utilizada para envolver sushi'),
('Aguacate', 'Fruto cremoso también conocido como palta'),
('Quinoa', 'Pseudocereal de alto valor nutritivo'),
('Tomate', 'Fruto rojo utilizado en muchas preparaciones'),
('Mozzarella', 'Queso italiano fresco de textura suave'),
('Albahaca', 'Hierba aromática utilizada en la cocina italiana');

INSERT INTO Unidades_Medida (nombre, abreviatura) VALUES
('Gramo', 'g'),
('Kilogramo', 'kg'),
('Mililitro', 'ml'),
('Litro', 'l'),
('Cucharada', 'cda'),
('Cucharadita', 'cdta'),
('Taza', 'taza'),
('Unidad', 'u'),
('Pizca', 'pizca'),
('Puñado', 'puñado');

-- Insertar datos en la tabla Paises
INSERT INTO Paises (nombre, codigo) VALUES
('Perú', 'PE'),
('Italia', 'IT'),
('Japón', 'JP'),
('México', 'MX'),
('España', 'ES'),
('Grecia', 'GR'),
('Tailandia', 'TH'),
('India', 'IN'),
('Francia', 'FR'),
('China', 'CN');

-- Insertar datos en la tabla Recetas (sin fecha_publicacion)
INSERT INTO Recetas (titulo, descripcion, tiempo_preparacion, dificultad, porciones, instrucciones, id_usuario, id_categoria, id_pais) VALUES
('Pescado a la limeña', 'Un plato emblemático de la gastronomía peruana. El pescado a la limeña combina la frescura del pescado blanco con el ácido del limón y el picante del ají, creando una explosión de sabores que representa la esencia de la cocina peruana.', 35, 'Media', 4, 'Instrucciones detalladas para preparar el pescado a la limeña...', 5, 2, 1),
('Pasta Carbonara Auténtica', 'La verdadera carbonara romana, sin nata y con ingredientes tradicionales. Este plato clásico italiano combina la cremosidad del huevo con el sabor intenso del guanciale y el queso pecorino para crear una pasta sencilla pero extraordinaria.', 25, 'Media', 4, 'Instrucciones detalladas para preparar la pasta carbonara...', 2, 1, 2),
('Sushi Variado Premium', 'Selección de nigiri, maki y sashimi con ingredientes de primera calidad.', 50, 'Alta', 2, 'Instrucciones detalladas para preparar sushi variado...', 8, 3, 3),
('Buddha Bowl Vegano', 'Combinación de quinoa, aguacate, garbanzos y vegetales de temporada con aderezo de tahini.', 30, 'Baja', 2, 'Instrucciones detalladas para preparar buddha bowl...', 3, 4, 5),
('Pizza Margherita Casera', 'La clásica pizza italiana con masa artesanal, tomate San Marzano, mozzarella fresca y albahaca.', 45, 'Media', 4, 'Instrucciones detalladas para preparar pizza margherita...', 6, 1, 2),
('Tacos al Pastor', 'Auténticos tacos mexicanos con carne marinada en achiote, piña asada y cilantro fresco.', 60, 'Media', 6, 'Instrucciones detalladas para preparar tacos al pastor...', 4, 2, 4),
('Paella Valenciana', 'El plato más emblemático de la cocina española, con arroz, azafrán, pollo y mariscos.', 70, 'Alta', 6, 'Instrucciones detalladas para preparar paella valenciana...', 7, 9, 5),
('Ensalada Griega', 'Refrescante ensalada con tomate, pepino, cebolla, aceitunas y queso feta.', 15, 'Baja', 4, 'Instrucciones detalladas para preparar ensalada griega...', 9, 5, 6),
('Pad Thai', 'Fideos de arroz salteados con huevo, tofu, brotes de soja y cacahuetes.', 30, 'Media', 2, 'Instrucciones detalladas para preparar pad thai...', 10, 8, 7),
('Tiramisú Clásico', 'Postre italiano a base de bizcochos de soletilla, café, mascarpone y cacao.', 40, 'Media', 8, 'Instrucciones detalladas para preparar tiramisú...', 2, 6, 2);

-- Insertar datos en la tabla Recetas_Etiquetas
INSERT INTO Recetas_Etiquetas (id_receta, id_etiqueta) VALUES
(1, 1), (1, 3), -- Pescado a la limeña: Popular, Saludable
(2, 2), (2, 4), -- Pasta Carbonara: Nuevo, Rápido
(3, 1), (3, 3), -- Sushi: Popular, Saludable
(4, 3), (4, 5), (4, 7), -- Buddha Bowl: Saludable, Sin Gluten, Vegetariano
(5, 1), (5, 10), -- Pizza: Popular, Económico
(6, 1), (6, 8), -- Tacos: Popular, Picante
(7, 9), (7, 1), -- Paella: Festivo, Popular
(8, 3), (8, 4), (8, 6), -- Ensalada: Saludable, Rápido, Bajo en Calorías
(9, 4), (9, 10), -- Pad Thai: Rápido, Económico
(10, 9), (10, 1); -- Tiramisú: Festivo, Popular

INSERT INTO Recetas_Ingredientes (id_receta, id_ingrediente, cantidad, id_unidad, notas) VALUES
(1, 1, 500, 1, 'Preferiblemente corvina o mero'),
(1, 2, 8, 8, 'Para jugo'),
(1, 3, 1, 8, 'Cortada en juliana fina'),
(1, 4, 2, 8, 'Sin semillas y picados finamente'),
(2, 5, 350, 1, NULL),
(2, 6, 150, 1, 'O panceta si no encuentras guanciale'),
(2, 7, 3, 8, 'Grandes y a temperatura ambiente'),
(2, 8, 80, 1, 'Rallado finamente'),
(3, 9, 300, 1, 'Lavado y cocido según instrucciones'),
(3, 10, 5, 8, 'Hojas enteras'),
(4, 11, 1, 8, 'Maduro pero firme'),
(4, 12, 200, 1, 'Cocida según instrucciones'),
(5, 13, 4, 8, 'Maduros y jugosos'),
(5, 14, 200, 1, 'Fresca, en rodajas'),
(5, 15, 10, 8, 'Hojas frescas');

INSERT INTO Pasos_Receta (id_receta, numero_paso, descripcion) VALUES
(1, 1, 'Corta el pescado en cubos de aproximadamente 2 cm. Asegúrate de que esté muy fresco y bien limpio.'),
(1, 2, 'En un recipiente de vidrio o cerámica (nunca metal), coloca el pescado y agrega el jugo de limón recién exprimido. El pescado debe quedar completamente cubierto por el jugo.'),
(1, 3, 'Añade la cebolla morada en juliana, el ajo machacado y el ají limo picado. Mezcla suavemente.'),
(1, 4, 'Sazona con sal y pimienta al gusto. Cubre el recipiente y refrigera por al menos 15 minutos.'),
(2, 1, 'Pon a hervir una olla grande con agua. Cuando hierva, añade sal generosamente.'),
(2, 2, 'Mientras tanto, corta el guanciale en tiras pequeñas o cubos. Calienta una sartén grande a fuego medio y añade el guanciale.'),
(2, 3, 'En un bol, bate los huevos enteros y la yema adicional. Añade el queso Pecorino rallado y pimienta negra recién molida.'),
(2, 4, 'Añade los espaguetis al agua hirviendo y cocínalos según las instrucciones del paquete hasta que estén al dente.'),
(3, 1, 'Prepara el arroz para sushi según las instrucciones, mezclándolo con vinagre de arroz, azúcar y sal.'),
(3, 2, 'Corta los ingredientes para el sushi en tiras finas o cubos pequeños, dependiendo del tipo de sushi que vayas a preparar.'),
(4, 1, 'Cocina la quinoa según las instrucciones del paquete y deja enfriar.'),
(4, 2, 'Prepara todos los vegetales: lava, pela y corta según sea necesario.'),
(5, 1, 'Prepara la masa de pizza mezclando harina, agua, levadura, sal y aceite de oliva.'),
(5, 2, 'Deja reposar la masa hasta que duplique su tamaño, aproximadamente 1-2 horas.'),
(10, 1, 'Prepara un café fuerte y déjalo enfriar.'),
(10, 2, 'Mezcla el queso mascarpone con azúcar y yemas de huevo hasta obtener una crema suave.');

INSERT INTO Comentarios (id_receta, id_usuario, texto) VALUES
(1, 3, '¡Excelente receta! El pescado quedó con un sabor increíble.'),
(1, 4, 'Me encantó la combinación de sabores, muy refrescante.'),
(2, 6, 'Por fin una carbonara auténtica sin nata. ¡Deliciosa!'),
(2, 7, 'La preparé ayer y quedó espectacular. Gracias por compartir.'),
(3, 2, 'Nunca pensé que podría hacer sushi en casa. ¡Quedó muy bien!'),
(4, 9, 'Una opción muy saludable y sabrosa. La hago cada semana.'),
(5, 10, 'La mejor pizza casera que he probado. La masa quedó perfecta.'),
(6, 5, 'Los tacos quedaron deliciosos, aunque me costó encontrar el achiote.'),
(7, 8, 'Excelente paella, aunque le añadí más azafrán del indicado.'),
(10, 3, 'El tiramisú quedó espectacular. Todos en casa quedaron encantados.');

INSERT INTO Valoraciones (id_receta, id_usuario, puntuacion) VALUES
(1, 3, 4.8),
(1, 4, 4.7),
(1, 6, 4.9),
(2, 6, 4.6),
(2, 7, 4.5),
(2, 9, 4.7),
(3, 2, 4.9),
(3, 5, 5.0),
(4, 9, 4.7),
(5, 10, 4.5),
(6, 5, 4.7),
(7, 8, 4.8),
(8, 4, 4.6),
(9, 7, 4.4),
(10, 3, 4.9);

INSERT INTO Favoritos (id_usuario, id_receta) VALUES
(2, 1),
(3, 1),
(4, 1),
(6, 2),
(7, 2),
(2, 3),
(5, 3),
(9, 4),
(10, 5),
(3, 10);

-- Obtener todas las recetas
SELECT id_receta, titulo, tiempo_preparacion, dificultad 
FROM Recetas;

-- Obtener recetas italianas
SELECT id_receta, titulo, tiempo_preparacion 
FROM Recetas 
WHERE id_categoria = 1;

-- Buscar recetas que contengan "pasta" en el título
SELECT id_receta, titulo, tiempo_preparacion 
FROM Recetas 
WHERE titulo LIKE '%pasta%';

-- Obtener ingredientes de una receta
SELECT nombre 
FROM Ingredientes 
WHERE id_ingrediente IN (
    SELECT id_ingrediente 
    FROM Recetas_Ingredientes 
    WHERE id_receta = 1
);

-- Obtener los pasos de una receta
SELECT numero_paso, descripcion 
FROM Pasos_Receta 
WHERE id_receta = 2 
ORDER BY numero_paso;

-- Obtener comentarios de una receta
SELECT texto 
FROM Comentarios 
WHERE id_receta = 1;

-- Obtener recetas rápidas (menos de 30 minutos)
SELECT titulo, tiempo_preparacion 
FROM Recetas 
WHERE tiempo_preparacion < 30;

-- 2. OPERACIONES DE INSERCIÓN

-- Insertar un nuevo usuario
INSERT INTO Usuarios (nombre, apellidos, email, password, id_rol) 
VALUES ('Nuevo', 'Usuario', 'nuevo@ejemplo.com', 'contraseña123', 4);

-- Insertar una nueva receta
INSERT INTO Recetas (titulo, descripcion, tiempo_preparacion, dificultad, porciones, instrucciones, id_usuario, id_categoria, id_pais) 
VALUES ('Ensalada César', 'Ensalada clásica con pollo', 15, 'Baja', 2, 'Mezclar todos los ingredientes', 3, 5, 9);

-- Insertar un comentario
INSERT INTO Comentarios (id_receta, id_usuario, texto) 
VALUES (5, 3, '¡Muy buena receta!');

-- 3. OPERACIONES DE ACTUALIZACIÓN

-- Actualizar título de una receta
UPDATE Recetas 
SET titulo = 'Pasta Carbonara Tradicional' 
WHERE id_receta = 2;

-- Actualizar email de usuario
UPDATE Usuarios 
SET email = 'nuevo_email@ejemplo.com' 
WHERE id_usuario = 4;

-- 4. OPERACIONES DE ELIMINACIÓN

-- Eliminar un comentario
DELETE FROM Comentarios 
WHERE id_comentario = 1;

-- Eliminar una receta de favoritos
DELETE FROM Favoritos 
WHERE id_usuario = 2 AND id_receta = 1;
