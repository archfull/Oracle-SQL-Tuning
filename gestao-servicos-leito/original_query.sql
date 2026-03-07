SELECT distinct
    substr(obter_nome_setor(c.cd_setor_atendimento), 1, 80) AS ds_setor,
    c.cd_unidade_basica || '  ' || c.cd_unidade_compl AS cd_unidade,
    a.dt_prevista AS dt_prevista,
    a.dt_inicio AS dt_inicio,
    a.dt_fim AS dt_fim,
    substr(obter_nome_pf(a.cd_executor), 1, 80) AS nm_executor,
    substr(obter_valor_dominio(1812, a.ie_status_serv), 1, 40) AS ds_status,
    substr(obter_valor_dominio(1811, a.ie_executor), 1, 40) AS ds_executor,
    b.ds_servico AS ds_servico,
    a.nm_usuario AS nm_usuario,
    -- Cálculo do tempo em execução em horas
    ROUND((dt_fim - dt_prevista) * 1440,2) AS atraso_minutostempo_execucao_horas,
    b.ds_servico,
    substr(obter_descricao_padrao('SL_SERVICO', 'DS_SERVICO', a.NR_SEQ_SERVICO), 1, 80)
    
FROM 
    sl_unid_atend a,
    sl_servico b,
    unidade_atendimento c
WHERE 
    trunc(a.dt_prevista) BETWEEN :dt_inicial AND :dt_final
    AND a.nr_seq_unidade = c.nr_seq_interno
    AND b.ds_servico = substr(obter_descricao_padrao('SL_SERVICO', 'DS_SERVICO', a.NR_SEQ_SERVICO), 1, 80)
    AND ((:ds_servico = 0) OR (:ds_servico = a.nr_seq_servico))
    AND ((:ds_status = '0') OR (a.ie_status_serv = :ds_status))
    AND ((:ds_setor = 0) OR (c.cd_setor_atendimento = :ds_setor));