-- Inserindo novo colaborador
INSERT INTO C##brh.COLABORADOR (matricula, cpf, nome, salario, departamento, cep, logradouro, complemento_endereco)
VALUES ('Fulano123', '123.456.789-01', 'Fulano de Tal', 5000.00, 'SEDES', '12345-678', 'Rua A, 123', 'Apt 2B');

-- Insere telefone celular
INSERT INTO C##brh.TELEFONE_COLABORADOR (numero, colaborador, tipo)
VALUES ('(61) 9 9999-9999', 'Fulano123', 'M'); -- Mobile phone

-- Insere telefone fixo
INSERT INTO C##brh.TELEFONE_COLABORADOR (numero, colaborador, tipo)
VALUES ('(61) 3030-4040', 'Fulano123', 'R'); 

-- Insere email pessoal
INSERT INTO C##brh.EMAIL_COLABORADOR (email, colaborador, tipo)
VALUES ('fulano@email.com', 'Fulano123', 'P'); 

-- Insere email de trabalho
INSERT INTO C##brh.EMAIL_COLABORADOR (email, colaborador, tipo)
VALUES ('fulano.tal@brh.com', 'Fulano123', 'T');

-- Inserir o novo CEP. Ele não adiciona o colaborador se não colocar o CEP... (PK..)
INSERT INTO c##brh.endereco(cep, uf, cidade, bairro)
VALUES ('12345-678', 'SP', 'Ribeirão Preto', 'Ipiranga');

-- Insere dependentes
INSERT INTO C##brh.DEPENDENTE (cpf, nome, data_nascimento, parentesco, colaborador)
VALUES ('111.222.333-44', 'Beltrana de Tal', TO_DATE('2000-01-15', 'YYYY-MM-DD'), 'Filho(a)', 'Fulano123');

INSERT INTO C##brh.DEPENDENTE (cpf, nome, data_nascimento, parentesco, colaborador)
VALUES ('222.333.444-55', 'Cicrana de Tal', TO_DATE('1985-05-20', 'YYYY-MM-DD'), 'Cônjuge', 'Fulano123');

-- Insere papel do colaborador
INSERT INTO C##brh.PAPEL (nome)
VALUES ('Especialista de Negócios');

-- Consulta conjugue
SELECT C.nome AS "Nome do Colaborador", D.nome AS "Nome do Dependente", D.data_nascimento AS "Data de Nascimento do Dependente", D.parentesco AS "Parentesco do Dependente"
FROM C##brh.COLABORADOR C
INNER JOIN C##brh.DEPENDENTE D ON C.matricula = D.colaborador
ORDER BY C.nome, D.nome;

-- RELATORIO DE CONTATO TELEFÔNICOS
SELECT
    C.nome AS "Nome",
    E.email AS "Email",
    T.numero AS "Telefone"
FROM
    C##brh.COLABORADOR C
LEFT JOIN
    C##brh.EMAIL_COLABORADOR E ON C.matricula = E.colaborador AND E.tipo = 'T'
LEFT JOIN
    C##brh.TELEFONE_COLABORADOR T ON C.matricula = T.colaborador AND T.tipo = 'M'
ORDER BY
    "Nome";

-- LISTA COLABORADOR MAIOR SALARIO

SELECT
    nome,
    salario
FROM
    c##brh.colaborador
WHERE salario = (SELECT MAX(salario) FROM c##brh.colaborador);


-- RELATORIO SENIORIDADE

SELECT
    matricula,
    nome,
    salario,
    CASE
        WHEN salario BETWEEN 0 AND 3000 THEN 'JUNIOR'
        WHEN salario BETWEEN 3000.01 AND 6000 THEN 'PLENO'
        WHEN salario BETWEEN 6000.01 AND 20000 THEN 'SENIOR'
        WHEN salario > 20000 THEN 'CORPO DIRETOR'
        ELSE 'DESCONHECIDO'
    END AS SENIORIDADE
FROM
    c##brh.colaborador
ORDER BY
    SENIORIDADE, NOME;


-- LISTAR COLABORADORES COM MAIS DEPENDENTES
-- No relatório deve ter somente colaboradores com 2 ou mais dependentes.
-- Ordenar consulta pela quantidade de dependentes em ordem decrescente, e colaborador crescente.

SELECT 
    C.NOME,
    COUNT(*) AS "QUANTIDADE DE DEPENDENTES"
FROM
    BRH.DEPENDENTE D
INNER JOIN
    BRH.COLABORADOR C ON D.COLABORADOR = C.MATRICULA
GROUP BY 
    C.NOME
HAVING (COUNT(*)) >= 2
ORDER BY
   "QUANTIDADE DE DEPENDENTES" DESC, C.NOME;


 -- DESAFIO RELATORIO ANALITICO
SELECT
    D.nome AS "Departamento",
    D.chefe AS "Chefe do Departamento",
    C.nome AS "Colaborador",
    P.nome AS "Projeto",
    PA.nome AS "Nome do Papel",
    TO_CHAR(TC.numero) AS "Telefone",
    DE.nome AS "Dependente"
FROM
    C##brh.DEPARTAMENTO D
JOIN
    C##brh.COLABORADOR C ON D.sigla = C.departamento
LEFT JOIN
    C##brh.PROJETO P ON C.matricula = P.responsavel
LEFT JOIN
    C##brh.PAPEL PA ON C.matricula = TO_CHAR(PA.id)
LEFT JOIN
    C##brh.TELEFONE_COLABORADOR TC ON C.matricula = TC.colaborador
LEFT JOIN
    C##brh.DEPENDENTE DE ON C.matricula = DE.colaborador
ORDER BY
    "Projeto", "Colaborador", "Dependente";

 

