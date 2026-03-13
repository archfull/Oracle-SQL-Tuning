select distinct
  a.nr_atendimento, 
  obter_nome_pf(a.cd_pessoa_fisica) as nome_pac,
  a.ds_setor_atendimento,
  a.cd_unidade_basica,
  b.dt_alta_medica,
  max(c.dt_alta) as max_dt_alta,
  a.dt_saida_real
from
  atendimento_paciente_v a
  join atend_previsao_alta b on a.nr_atendimento = b.nr_atendimento
  join atend_alta_hist c on c.nr_atendimento = a.nr_atendimento
  join atend_paciente_unidade d on a.nr_atendimento = d.nr_atendimento
where
  a.cd_estabelecimento = :cd_estabelecimento
  and a.dt_alta between to_date(:dt_inicial) and to_date(:dt_fim)
  
group by
  a.nr_atendimento, 
  obter_nome_pf(a.cd_pessoa_fisica),
  a.ds_setor_leito,
  b.dt_alta_medica,
  a.dt_saida_real,
  a.ds_setor_atendimento,
  a.cd_unidade_basica

order by ds_setor_atendimento desc;