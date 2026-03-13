with base_atendimento as (
    select
        a.nr_atendimento,
        a.cd_pessoa_fisica,
        a.dt_alta_medico,
        a.dt_saida_real,
        a.nm_usuario_alta_medica
    from atendimento_paciente a
    where a.cd_estabelecimento = :cd_estabelecimento
      and a.ie_tipo_atendimento = 1
      and a.dt_alta between :dt_inicial and fim_dia(:dt_fim)

),
ultima_unidade as (
    select 
        nr_atendimento,
        cd_setor_atendimento,
        cd_unidade_basica
    from (
        select
            b.nr_atendimento,
            b.cd_setor_atendimento,
            b.cd_unidade_basica,
            row_number() over (
                partition by b.nr_atendimento
                order by nvl(b.dt_saida_unidade, b.dt_entrada_unidade + 9999) desc,
                         b.nr_seq_interno desc
            ) rn
        from atend_paciente_unidade b
        join base_atendimento a
            on a.nr_atendimento = b.nr_atendimento
    )
    where rn = 1

),
alta_enfermagem as (
    select
        a.nr_atendimento,
        b.ds_motivo_alta,
        min(a.dt_alta) keep (
            dense_rank first order by a.nr_sequencia
        ) as dt_alta_enf

    from atend_alta_hist a
        left join motivo_alta b
            on a.cd_motivo_alta = b.cd_motivo_alta
    where a.ie_alta_estorno = 'A'
    group by a.nr_atendimento,b.ds_motivo_alta
)

select
    a.nr_atendimento,
    p.nm_pessoa_fisica,
    s.ds_setor_atendimento,
    u.cd_unidade_basica,
    e.ds_motivo_alta,
    to_char(a.dt_alta_medico,'DD/MM/YYYY HH24:MI:SS') as dt_alta_medico,
    to_char(e.dt_alta_enf,'DD/MM/YYYY HH24:MI:SS') as dt_alta_enf,
    to_char(a.dt_saida_real,'DD/MM/YYYY HH24:MI:SS') as dt_saida_real

from base_atendimento a
    join ultima_unidade u
        on a.nr_atendimento = u.nr_atendimento
    join setor_atendimento s
        on u.cd_setor_atendimento = s.cd_setor_atendimento
    join pessoa_fisica p
        on a.cd_pessoa_fisica = p.cd_pessoa_fisica
    left join alta_enfermagem e
        on a.nr_atendimento = e.nr_atendimento

order by s.ds_setor_atendimento desc;

