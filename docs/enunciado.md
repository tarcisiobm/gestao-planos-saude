# Enunciado do Trabalho — Gestão de Planos de Saúde

> **Disciplina (real):** Desenvolvimento para Dispositivos Móveis I
> **Tema sorteado para o grupo:** Sistema de Gestão de Planos de Saúde
>
> Observação: o texto original do enunciado vem com o cabeçalho **"Engenharia de
> Software I"** porque o professor reaproveitou o mesmo modelo de especificação. O
> conteúdo se aplica integralmente ao nosso trabalho de Dispositivos Móveis — a
> tecnologia exigida é a apresentada na disciplina de **Programação para
> Dispositivos Móveis** (Flutter/Dart).

Transcrição fiel e organizada do arquivo original `enunciado_professor`.

---

## 1. Especificação do Trabalho

### 1.1 Objetivos

O objetivo deste trabalho é aplicar os conceitos da disciplina de Engenharia de
Software por meio do
desenvolvimento de um software completo, baseado em uma especificação sorteada em
sala de aula para cada grupo. O desenvolvimento deverá seguir o **Processo
Unificado (PU)**, passando por todas as suas fases: **Iniciação, Elaboração,
Construção e Transição**.

Durante o desenvolvimento, o grupo deverá:

- Criar o **Diagrama de Entidade e Relacionamento (DER)** do sistema;
- Implementar os **scripts SQL** com a estrutura do banco de dados, utilizando
  comandos **DDL (Data Definition Language)**, garantindo que o banco seja
  implementado em **MariaDB / MySQL**;
- Desenvolver a aplicação utilizando a linguagem e os frameworks propostos na
  disciplina de Programação para Dispositivos Móveis (e demais tecnologias
  sugeridas durante as aulas);
- Produzir a **documentação completa** do projeto de acordo com o modelo
  apresentado em sala (*link do modelo apresentado em aula — não incluído no texto
  original*);
- Criar um **repositório Git** do projeto com o objetivo de gerenciar as
  iterações através de **branches**, conforme o projeto exemplo
  [Controle de Endereços em Flutter](#projeto-exemplo-referência).

### 1.2 Instruções de Entrega

- A entrega é feita **exclusivamente pela plataforma SIGAA**. Não são aceitos
  trabalhos fora do prazo, nem por e-mail ou outra plataforma.
- Em caso de imprevisto, avisar com antecedência mínima de **24 horas**.
- O projeto é completo e deve ser entregue **compactado**. Qualquer outro formato
  é considerado não entregue. Conferir antes de enviar se o arquivo compactado
  contém todos os arquivos e não está corrompido/vazio.
- Como **backup de envio**, é permitido subir o projeto no Google Drive ou OneDrive
  e enviar o link de compartilhamento (público) também no SIGAA. O professor
  recomenda fortemente usar essa opção de backup.
- **Atenção:** após a data de entrega, **não atualizar o projeto** em nenhuma
  plataforma (GitHub, Drive, OneDrive, etc.). A data da última atualização é
  exibida; alteração posterior faz o trabalho ser pontuado como **0 (zero)**.

### 1.3 Arquivos que devem ser entregues

- [ ] **Script DDL** com a estrutura da base de dados — extensão **`.sql`**
      (formato diferente não é aceito);
- [ ] **Documentação** do projeto seguindo o modelo apresentado em sala;
- [ ] **Projeto completo** desenvolvido na linguagem escolhida, incluindo todas
      as interfaces, funcionalidades e lógica de negócio;
- [ ] **Modelo de Entidade e Relacionamento** em imagem **ou** PDF — incluir
      também o **arquivo-fonte** do diagrama;
- [ ] **Link para o repositório** do projeto no GitHub.

---

## 2. Tema Sorteado: Gestão de Planos de Saúde

> Texto original do escopo funcional (item 10 do enunciado).

### 2.1 Cadastro de Clientes e Planos

O software deve permitir o cadastro detalhado de clientes, incluindo informações
como **nome, endereço, telefone, e-mail, CPF e informações de dependentes**. Além
disso, o sistema deve permitir o cadastro e a associação de diferentes **tipos de
planos de saúde** ao cliente, informando detalhes como **tipo de cobertura, valor
do plano, vigência e forma de pagamento**.

### 2.2 Gestão de Vendas e Contratos

O sistema deve incluir funcionalidades para registrar e acompanhar as **vendas** de
planos de saúde, permitindo a emissão e o gerenciamento de **contratos**. Cada
contrato deve conter detalhes como **data de início, prazo de validade, termos e
condições do plano**, além da possibilidade de **renovação automática**. O software
também deve permitir a geração de **propostas** de planos com base no perfil do
cliente e **simulações de valores**.

### 2.3 Gestão de Pagamentos e Cobrança

Deve haver funcionalidades para o controle de pagamentos. O sistema deve registrar
o **status de cada pagamento** (pago, pendente, atrasado). Além disso, deve ser
possível gerar **relatórios financeiros detalhados**, incluindo **receitas,
inadimplências e comissões de vendedores**.

### 2.4 Gestão de Prestadores e Coberturas

O sistema deve permitir o cadastro e a gestão de **prestadores de serviços
médicos** (clínicas, hospitais e laboratórios). Para cada prestador, deve registrar
informações como **especialidades atendidas, localização, contrato firmado e
histórico de atendimento**. O software deve também permitir a **associação de
prestadores aos planos de saúde**, indicando quais **coberturas** são oferecidas
por cada um.

### 2.5 Relatórios e Análise de Dados

O sistema deve permitir a geração de **relatórios completos** sobre diversos
aspectos da gestão, como:

- número de **clientes ativos**;
- **receitas mensais**;
- quantidade de **sinistros abertos**;
- **prestadores mais utilizados**;
- **taxa de renovação** de contratos.

---

## Projeto Exemplo (Referência)

O que o enunciado **de fato** diz sobre o projeto exemplo (seção 1.1):

> Criar um repositório no Git do projeto com o objetivo de **gerenciar as iterações
> através de branches**, conforme projeto exemplo — **Link Projeto Exemplo: Controle
> de Endereços em Flutter**.

Ou seja, no enunciado o projeto exemplo é a referência para o **versionamento por
branches / gestão de iterações**. O enunciado não descreve a arquitetura interna do
exemplo nem cita um segundo projeto.

> **Nota do organizador (não faz parte do texto do enunciado):** o projeto exemplo
> citado foi salvo, em versão curada, em
> [`../reference/flutter_controle_enderecos/`](../reference/flutter_controle_enderecos/)
> — origem: clone `flutter_controle_enderecos-main`. Uma referência adicional de
> interface usada nas aulas está em
> [`../reference/flutter_exemplo_menu/`](../reference/flutter_exemplo_menu/). A
> análise de arquitetura e dos padrões de tela (busca, popup, listagem) está no
> [`README.md` do repositório](../README.md) e em
> [`adicionais-professor.md`](adicionais-professor.md), **não** neste enunciado.
