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
- **RF07 — Gerenciar roteiros diários:** organizar as atividades previstas para cada dia da viagem.

Regras de negócio estabelecem as condições que o sistema precisa respeitar.

Por exemplo, no nosso sistema de viagens:
- Requisito funcional: permitir cadastrar uma viagem.
- Regra de negócio: a data de término de uma viagem não pode ser anterior à data de início.

## 3. Regras de Negócio

- RN01 — A data de término de uma viagem não pode ser anterior à data de início.
- RN02 — Uma viagem pode ser cadastrada sem destinos definidos inicialmente, permitindo que o viajante adicione um ou vários destinos posteriormente.
- RN03 — Uma viagem não pode possuir dois passeios cadastrados com a mesma data e o mesmo horário de início.
- RN04 — O sistema deve permitir o registro de despesas que ultrapassem o orçamento planejado da viagem, exibindo um aviso quando o valor total das despesas exceder esse orçamento.
- RN05 — As datas de entrada e saída de uma hospedagem devem estar dentro do período da viagem à qual ela pertence, sendo a data de saída posterior à data de entrada.
- RN06 — As datas e os horários de partida e chegada dos transportes cadastrados devem estar dentro do período da viagem à qual pertencem, sendo a chegada posterior à partida.
- RN07 — Um passeio somente poderá ser associado a um destino que faça parte da viagem à qual o passeio pertence.
- RN08 — Uma hospedagem somente poderá ser associada a um destino que faça parte da viagem à qual ela pertence.
- RN09 — A data de um roteiro diário deve estar dentro do período da viagem à qual ele pertence.
- RN10 — Um passeio associado a um roteiro diário deve pertencer à mesma viagem e possuir a mesma data do roteiro.