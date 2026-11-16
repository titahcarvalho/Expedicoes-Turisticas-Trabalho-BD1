# Sistema de Gerenciamento de Expedições Turísticas

## 1. Sobre o Projeto
O Sistema de Planejamento e Gerenciamento de Viagens e Roteiros Turísticos tem como finalidade auxiliar viajantes na organização de suas viagens, permitindo o cadastro e a consulta de informações relacionadas a destinos, roteiros, passeios, hospedagens, despesas (valor pretendido a ser gasto) e dicas importantes (propósito da viagem, temperatura, o que vestir, itens necessários, etc).

O sistema busca centralizar o planejamento das viagens em uma única aplicação, facilitando o gerenciamento das informações e o acompanhamento dos roteiros planejados.
## 2. Requisitos Funcionais - o que o sistema faz

O sistema deverá permitir que o viajante:

- **RF01 — Gerenciar viagens:** cadastrar e consultar viagens, incluindo datas de início e término.
- **RF02 — Gerenciar destinos:** cadastrar e consultar os destinos associados às viagens.
- **RF03 — Gerenciar passeios:** registrar passeios e atividades turísticas, incluindo datas e horários.
- **RF04 — Gerenciar hospedagens:** cadastrar informações sobre hospedagens utilizadas ou planejadas.
- **RF05 — Gerenciar despesas:** registrar gastos e acompanhar o orçamento de cada viagem.
- **RF06 — Gerenciar transportes:** cadastrar informações sobre voos, ônibus e outros meios de transporte.


Regras de negócio estabelecem as condições que o sistema precisa respeitar.

Por exemplo, no nosso sistema de viagens:
- Requisito funcional: permitir cadastrar uma viagem.
- Regra de negócio: a data de término de uma viagem não pode ser anterior à data de início.

## 3. Regras de Negócio

RN01 — Período da viagem: A data de término de uma viagem deve ser igual ou posterior à data de início.

RN02 — Destinos da viagem: Uma viagem deve ser cadastrada com destinos definidos, permitindo a inclusão de um ou vários destinos posteriormente.

RN03 — Agendamento de passeios: Uma viagem não pode possuir dois passeios com a mesma data e horário de início.

RN04 — Controle de orçamento: O sistema deve permitir despesas que ultrapassem o orçamento planejado, exibindo um aviso quando o total de gastos exceder esse valor.

RN05 — Período de hospedagem e transporte: As datas de hospedagem e os horários de transporte devem respeitar o período da viagem. A saída da hospedagem deve ser posterior à entrada, e a chegada do transporte deve ocorrer após a partida.

RN06 — Associação de passeios e hospedagens: Passeios e hospedagens somente podem ser associados a destinos que façam parte da viagem correspondente. (Hospedagem na Rússia, viagem para o Japão)

RN07 — Período dos passeios: Os passeios devem ocorrer dentro do período da viagem à qual pertencem.