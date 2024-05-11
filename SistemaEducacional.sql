-- Tabela Alunos --
CREATE TABLE alunos(
	cpf varchar(14) PRIMARY KEY NOT NULL UNIQUE,
	nome_aluno varchar(50) NOT NULL,
	idade int,
	endereco text NOT NULL,
	contato text NOT NULL
)

-- Tabela Disciplinas --
CREATE TABLE disciplinas(
	id_disciplina serial PRIMARY KEY NOT NULL UNIQUE,
	nome_disciplina text NOT NULL,
	optativa boolean
)

-- Tabela Curso --
CREATE TABLE cursos(
	id_curso serial PRIMARY KEY NOT NULL UNIQUE,
	nome_curso text NOT NULL
)

-- Tabela Departamentos --
CREATE TABLE departamentos(
	id_departamento serial PRIMARY KEY NOT NULL UNIQUE,
	nome_departamento text NOT NULL
)

-- Tabela Matriculas --
CREATE TABLE matriculas(
	ra serial PRIMARY KEY,
	cpf varchar(14) REFERENCES alunos,
	status varchar(10),
	id_cursos int REFERENCES curso
)

-- Tabela cursos_disciplinas --
CREATE TABLE curso_disc(
	id_curso int REFERENCES cursos,
	id_disc int REFERENCES disciplinas
)

SELECT * FROM curso_disc

-----    INSERIR DADOS   -----

-- Dados Alunos --
INSERT INTO alunos (cpf,nome_aluno,idade,endereco, contato) VALUES
('12345678900', 'João Silva', 25, 'Rua das Flores, 123', '(11) 1234-5678'),
('98765432100', 'Maria Oliveira', 20, 'Avenida dos Anjos, 456', '(22) 9876-5432'),
('45678912300', 'Pedro Santos', 22, 'Travessa das Estrelas, 789', '(33) 4567-8901'),
('32165498700', 'Ana Pereira', 19, 'Rua das Palmeiras, 987', '(44) 3210-9876'),
('78912345600', 'Luiza Costa', 21, 'Alameda das Águias, 654', '(55) 7890-1234')

-- Dados Disciplinas --
INSERT INTO disciplinas (nome_disc, optativa) VALUES
('Cálculo', true),
('Culinária Básica', false),
('Carpintaria', false),
('Desenho Orientado', true),
('Algoritmos', true)

-- Dados Cursos --
INSERT INTO curso (nome_curso) VALUES
('Engenharia da Computação'),
('Gastronomia'),
('Engenharia Civil'),
('Artes Técnicas'),
('Ciências da Computação')

-- Dados Departamentos --
INSERT INTO departamento (nome_departamento) VALUES
('Engenharia'),
('Saúde'),
('Engenharia'),
('Humanas'),
('Tecnologia')

-- Dados Matriculas --
INSERT INTO matriculas (cpf,status,id_cursos) VALUES
('12345678900','Cursando', 1),
('98765432100','Trancado', 2),
('45678912300','Concluído', 3),
('32165498700','Cursando', 4),
('78912345600','Cursando', 5)

-- dropei pra adicionar dados

DROP TABLE matriculas;

-----  APLICANDO FILTROS -----

--/Dado o RA ou o Nome do Aluno, buscar no BD todos os demais dados do aluno\--
SELECT * FROM alunos NATURAL INNER JOIN matriculas
WHERE nome_aluno = 'Maria' OR ra = (SELECT ra FROM matriculas
				 WHERE ra = '7')	

--/Dado o nome de um departamento, exibir o nome de todos os cursos associados a ele\--
SELECT nome_curso
FROM cursos NATURAL INNER JOIN departamentos
WHERE area = 'Engenharia'

--/Dado o nome de uma disciplina, exibir a qual ou quais cursos ela pertence\--
SELECT c.nome_curso
FROM cursos c 
NATURAL INNER JOIN curso_disc cd 
INNER JOIN disciplinas d ON cd.id_disc = d.id_disc 
WHERE d.nome_disc = 'Cálculo';

--/Dado o CPF de um aluno, exibir quais disciplinas ele está cursando\--
SELECT d.nome_disc
FROM matriculas m
INNER JOIN curso_disc cd ON m.id_curso = cd.id_curso
INNER JOIN disciplinas d ON cd.id_disc = d.id_disc
WHERE m.cpf = '98765432100';

-- Filtrar todos os alunos matriculados em um determinado curso. --
SELECT a.nome_aluno
FROM alunos a
INNER JOIN matriculas m ON a.cpf = m.cpf
WHERE m.id_curso = (SELECT id_curso FROM cursos 
					WHERE nome_curso = 'Engenharia da Computação');

-- Filtrar todos os alunos matriculados em determinada disciplina. --
SELECT a.nome_aluno
FROM alunos a
INNER JOIN matriculas m ON a.cpf = m.cpf
INNER JOIN curso_disc cd ON m.id_curso = cd.id_curso
INNER JOIN disciplinas d ON cd.id_disc = d.id_disc
WHERE d.nome_disc = 'Carpintaria';

-- Filtrar alunos formados. --
SELECT nome_aluno
FROM alunos
INNER JOIN matriculas ON alunos.cpf = matriculas.cpf
WHERE matriculas.status = 'Concluído';

-- Filtrar alunos ativos --
SELECT nome_aluno
FROM alunos
INNER JOIN matriculas ON alunos.cpf = matriculas.cpf
WHERE matriculas.status = 'Cursando';

-- Apresentar a quantidade de alunos ativos por curso. --
SELECT c.nome_curso, COUNT(*) AS quantidade_alunos_ativos
FROM cursos c
INNER JOIN matriculas m ON c.id_curso = m.id_curso
WHERE m.status = 'Cursando'
GROUP BY c.nome_curso;

-- Apresentar a quantidade de alunos ativos por disciplina. --
SELECT d.nome_disc, COUNT(*) AS quantidade_alunos_ativos
FROM disciplinas d
INNER JOIN curso_disc cd ON d.id_disc = cd.id_disc
INNER JOIN matriculas m ON cd.id_curso = m.id_curso
WHERE m.status = 'Cursando'
GROUP BY d.nome_disc;



