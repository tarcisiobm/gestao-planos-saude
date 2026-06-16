# Gestão de Planos de Saúde (app Flutter)

Aplicativo de gestão para uma operadora de planos de saúde: login, cadastros
(clientes, dependentes, planos, prestadores, coberturas, contratos e pagamentos),
simulação de proposta e relatórios. Os dados ficam em um banco **MySQL/MariaDB**.

## Tecnologias

- **Flutter / Dart** — interface do app (desktop Linux).
- **device_preview** — exibe o app dentro de uma **moldura de smartphone** (ex.: iPhone);
  o aparelho é escolhido na barra lateral. Desliga sozinho no modo release.
- **MySQL / MariaDB** — banco de dados, acessado pelo pacote
  [`mysql_client_plus`](https://pub.dev/packages/mysql_client_plus).
- **flutter_dotenv** — credenciais do banco ficam num arquivo `.env` (fora do código).
- **Arquitetura em camadas:** `domain/` (models, interfaces de repositório, services),
  `data/` (conexão MySQL + implementações dos repositórios), `presentation/screen/`
  (telas), com `service_locator.dart` (injeção de dependência) e `routes.dart` (rotas
  nomeadas). Estado das telas com `setState`.

## Funcionalidades (o que cada tela faz)

- **Login / Registrar** — autenticação por e-mail e senha; é possível criar um novo
  usuário. Usuário padrão: `admin@email.com` / `123`.
- **Início (Home)** — menu principal; mostra o usuário logado (avatar + nome + e-mail)
  e tem o botão de sair.
- **Clientes** — cadastro de clientes (nome, CPF, telefone, e-mail, endereço).
- **Dependentes** — dependentes vinculados a um cliente titular.
- **Planos** — planos de saúde (tipo de cobertura, mensalidade, valor por
  dependente, vigência e forma de pagamento).
- **Prestadores** — hospitais, clínicas e laboratórios (tipo, especialidade, local).
- **Coberturas** — vínculo plano × prestador (quais prestadores atendem cada plano).
- **Contratos** — venda de um plano a um cliente (datas, status, renovação automática).
- **Pagamentos** — mensalidades com status (pago, pendente, atrasado).
- **Simulação** — calcula um valor estimado (plano + nº de dependentes usando o
  valor por dependente definido no plano); não salva nada.
- **Relatórios** — totais, contratos ativos, inadimplência e receita recebida.

Toda lista tem **busca por nome**, **exclusão com confirmação**, botão **+** para
adicionar e já vem com **10 registros de exemplo** (criados na primeira execução).

## Como desenvolver localmente

### 1. Pré-requisitos
- **Flutter** instalado.
- Bibliotecas do desktop Linux (uma vez só):
  ```bash
  sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev
  ```
- **MySQL** ou **MariaDB** instalado e rodando.

### 2. Criar o banco e um usuário
No MySQL/MariaDB, crie o banco e um usuário (o app cria as **tabelas** e popula os
exemplos sozinho na primeira execução):

```sql
CREATE DATABASE gestao_planos;
CREATE USER 'gestao_user'@'localhost' IDENTIFIED BY 'sua_senha';
GRANT ALL PRIVILEGES ON gestao_planos.* TO 'gestao_user'@'localhost';
FLUSH PRIVILEGES;
```

### 3. Configurar o `.env`
Copie o exemplo e preencha com os dados acima:

```bash
cp .env.example .env
```

```env
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=gestao_user
DB_PASSWORD=sua_senha
DB_NAME=gestao_planos
DB_SECURE=false
```

### 4. Rodar
```bash
flutter pub get
flutter run -d linux
```

O app abre na tela de **login** — entre com `admin@email.com` / `123`.

## Estrutura (`lib/`)

```text
lib/
├── main.dart                  carrega o .env, conecta no banco e abre o app
├── app_constants.dart         constantes gerais (nome do app, etc.)
├── service_locator.dart       registra os repositórios (injeção de dependência)
├── routes.dart                rotas nomeadas
├── domain/
│   ├── models/                cliente, plano, contrato, ... (+ toMap/fromMap)
│   ├── repository/            interfaces dos repositórios
│   ├── services/              regras de negócio (uma por entidade)
│   └── constants/             status de contrato/pagamento
├── data/
│   ├── app_database.dart       conexão MySQL + criação das tabelas
│   ├── app_seed.dart           dados de exemplo (10 por tabela)
│   └── *_repository_mysql.dart  implementações dos repositórios (SQL)
└── presentation/
    ├── screen/                telas (login, home + lista/form de cada cadastro)
    └── constants/             itens compartilhados de UI (menu Editar/Excluir)
```

> Modelagem (DER + script DDL MySQL/MariaDB) está em `database/`.
> A documentação do trabalho está em `docs/`.

## Versionamento

O desenvolvimento foi organizado por branches de iteração/feature:

- `prototipo`
- `iteracao01-modelagem`
- `iteracao02-infra-banco`
- `iteracao03-autenticacao`
- `iteracao04-cadastros-base`
- `iteracao05-operacoes-plano`
- `iteracao06-relatorios-entrega`
