# Adicionais Comentados em Sala

Anotações feitas durante as aulas sobre solicitações específicas do professor.
Organização fiel ao arquivo original `adicionais_comentados_em_sala.txt` (linhas
duplicadas foram unificadas, sem perda de conteúdo).

---

## Como a nota será dividida (3 etapas)

A avaliação do trabalho é dividida em **três etapas**:

1. **Levantamento de requisitos / regras de negócio** — a parte escrita
   (ver [`requisitos.md`](requisitos.md)).
2. **App desenvolvido** — a implementação em Flutter.
3. **Apresentação** — defesa/demonstração do trabalho.

---

## Requisitos técnicos obrigatórios (pedidos explicitamente em sala)

Estes itens são **critérios de avaliação diretos** e precisam funcionar de verdade no
app:

- [ ] **Barra de pesquisa funcional** — a busca tem que efetivamente filtrar os
      itens da lista (não pode ser apenas decorativa).
- [ ] **Popup de confirmação ao excluir** — todo botão de exclusão deve abrir um
      diálogo de confirmação antes de remover o registro.
- [ ] **Conexão com banco de dados** — o app deve persistir os dados em banco e não
      apenas em memória. *(A anotação de aula diz apenas "conectar com banco de
      dados"; a tecnologia exigida — MySQL/MariaDB — vem das premissas em*
      [`requisitos.md`](requisitos.md)*, não desta anotação.)*
- [ ] **Menus seguindo UX/UI** — ícones e ações nas posições onde o usuário já está
      acostumado a encontrá-los (convenções de interface; ex.: FAB de adicionar no
      canto inferior, menu de contexto no item, etc.).
- [ ] **Mínimo de 10 itens por página/listagem** — as telas de listagem devem exibir
      ao menos 10 itens (massa de dados suficiente para demonstrar a funcionalidade).

---

## Onde isso já aparece nos exemplos de referência

> Observação do organizador (não faz parte da anotação de aula): mapeamento dos
> pedidos acima para o código de referência.

O exemplo da aula
[`reference/flutter_exemplo_menu/`](../reference/flutter_exemplo_menu/) já demonstra
boa parte desses pontos e deve ser usado como base de implementação:

- **Busca + listagem:** `lib/pages/search_disciplina_page.dart` usa `TextField` +
  `ListView.builder` (a lógica de filtro deve ser ligada ao `TextField`).
- **Popup Excluir/Editar:** `PopupMenuButton` com as opções **Excluir** e **Editar**
  em cada item da lista (falta apenas adicionar o **diálogo de confirmação** ao
  excluir).
- **FAB de adicionar:** `FloatingActionButton` no canto inferior direito (convenção
  de UX).
- **Reatividade da lista:** `SearchListModel` + `ListenableBuilder` atualizam a lista
  após inserir/editar/excluir.
