select
    setor.ds_setor_atendimento as ds_setor_atendimento,
    unidade.cd_unidade_basica || '  ' || unidade.cd_unidade_compl as cd_unidade_atendimento,
    atendimento.dt_inicio as dt_inicio_atendimento,
    atendimento.dt_fim as dt_fim_atendimento,
    executor.nm_pessoa_fisica as nm_executor,
    status_servico.ds_valor_dominio as ds_status_servico,
    tipo_executor.ds_valor_dominio as ds_tipo_executor,
    to_char(atendimento.dt_prevista, 'dd/mm/yyyy hh24:mi:ss') as dt_prevista_formatada,

    case
        when atendimento.dt_inicio is not null
        and atendimento.dt_prevista is not null then
            case
                when atendimento.dt_prevista - atendimento.dt_inicio >= 0 then '-'
                else '+'
            end
            || floor(abs((atendimento.dt_prevista - atendimento.dt_inicio) * 24))
            || ':'
            || lpad(
                mod(
                    floor(abs((atendimento.dt_prevista - atendimento.dt_inicio) * 1440)),
                    60
                ),
                2,
                '0'
            )
            || ':'
            || lpad(
                mod(
                    floor(abs((atendimento.dt_prevista - atendimento.dt_inicio) * 86400)),
                    60
                ),
                2,
                '0'
            )
    end as ds_diferenca_tempo_hms,

    servico.ds_servico as ds_servico,
    atendimento.nm_usuario as nm_usuario_solicitante

from sl_unid_atend atendimento

inner join unidade_atendimento unidade
    on unidade.nr_seq_interno = atendimento.nr_seq_unidade

inner join sl_servico servico
    on servico.nr_sequencia = atendimento.nr_seq_servico

inner join setor_atendimento setor
    on setor.cd_setor_atendimento = unidade.cd_setor_atendimento

left join pessoa_fisica executor
    on executor.cd_pessoa_fisica = atendimento.cd_executor

inner join valor_dominio status_servico
    on status_servico.cd_dominio = 1812
   and status_servico.vl_dominio = atendimento.ie_status_serv

inner join valor_dominio tipo_executor
    on tipo_executor.cd_dominio = 1811
   and tipo_executor.vl_dominio = atendimento.ie_executor

where atendimento.dt_prevista between :dt_inicial
                                 and fim_dia(:dt_final)
and (
    :ds_servico = 0
    or atendimento.nr_seq_servico = :ds_servico
)
and (
    :ds_status = '0'
    or atendimento.ie_status_serv = :ds_status
)
and (
    :ds_setor = 0
    or unidade.cd_setor_atendimento = :ds_setor
)

order by atendimento.dt_prevista;