CREATE or REPLACE function MatriculaTurmaNew(userID int) RETURNS refcursor
AS
$$
DECLARE
	cursor_out refcursor;
BEGIN

	OPEN cursor_out FOR 
		Select cc.Nome_completo, firstinner.Data_Inicio, firstinner.Data_Fim, firstinner.Horario, 
		CASE 
		WHEN firstinner.status_inscricao is not NULL then FALSE
		else TRUE
		END as matriculado 
		FROM componente_curricular cc
		left join (Select * from trilha_escolhida te
		inner join turma_especializacao turma
		ON te.id = turma.trilha_escolhida_id
		left join (select * from aluno_esp_cursa_turma_esp aecte
		inner join aluno_professor_isf api 
		ON aecte.aluno_professor_isf_id = api.membro_academico_id) secondInner 
		ON te.id = secondInner.turma_especializacao_id) firstInner
		ON cc.id_componente_curricular = firstInner.componente_curricular_id 
		where firstinner.membro_academico_id = 1;
        return cursor_out;
	CLOSE cursor_out;

END;
$$
language 'plpgsql';
