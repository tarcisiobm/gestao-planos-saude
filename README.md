# Gestão de Planos de Saúde

Sistema acadêmico composto por um aplicativo Flutter e uma API REST em ASP.NET Core para gerenciar clientes, dependentes, planos, prestadores, serviços, contratos, pagamentos, simulações e atendimentos.

**Integrantes:** Tarcísio, Mayara, Pedro e Gabriel

## Arquitetura

O Flutter contém somente interface, navegação, modelos de transporte e clientes HTTP. Regras de negócio, autenticação, cache e persistência ficam na API.

```text
Flutter -> HTTP/JSON + JWT -> ASP.NET Core -> MySQL/MariaDB
```

A solução `api/GestaoPlanosSaude.sln` está separada em:

- `Domain`: entidades, exceções e contratos de repositórios;
- `Application`: casos de uso, serviços e `ResultWrapper`;
- `Infrastructure`: Dapper, MySQL, BCrypt e cache;
- `Api`: controllers, Swagger, JWT, tratamento de erros e injeção de dependência.

Fluxo de uma requisição:

```text
Controller (Api) -> Service (Application) -> Repository (Infrastructure) -> MySQL
```

O controller recebe a requisição, chama o serviço da camada `Application` e devolve o resultado dentro do `ResultWrapper`. O acesso ao banco fica restrito aos repositórios da `Infrastructure`, que implementam as interfaces definidas no `Domain`.

No Flutter:

- `lib/data`: `ApiClient` (HTTP, token e tratamento das respostas) e repositórios que consomem a API;
- `lib/domain`: modelos, interfaces de repositório e serviços usados pelas telas;
- `lib/presentation`: telas e navegação.

Erros retornados pela API são convertidos em `ApiException` e exibidos ao usuário em uma mensagem na tela.

## Decisões técnicas

- **Dapper**: consultas SQL explícitas e mapeamento simples, aproveitando o banco já existente do aplicativo anterior;
- **Repositórios genéricos**: o CRUD comum fica em `DapperRepository<T>`; cada repositório define apenas seu SQL;
- **Middleware de erros**: exceções viram respostas no padrão `ResultWrapper`, sem expor detalhes internos;
- **`IMemoryCache` na listagem de planos**: dado consultado com frequência e alterado raramente; como a API roda em uma única instância, não há necessidade de cache distribuído;
- **JWT sem estado**: a API não guarda sessão; cada requisição é validada pelo token;
- **`flutter_secure_storage`**: o token é salvo no armazenamento seguro do dispositivo, não em texto puro.

## Tecnologias

- Flutter/Dart, `http`, `flutter_secure_storage` e `flutter_dotenv`;
- .NET 8, ASP.NET Core, Dapper e Swagger;
- JWT Bearer e BCrypt;
- `IMemoryCache`;
- MySQL ou MariaDB.

## Banco de dados

Para uma instalação nova:

```bash
mysql -u root -p < database/schema.sql
```

Usuário da aplicação (mesmos dados de `appsettings.Development.example.json`):

```sql
CREATE USER 'gestao_user'@'localhost' IDENTIFIED BY 'troque_aqui';
GRANT ALL PRIVILEGES ON gestao_planos.* TO 'gestao_user'@'localhost';
FLUSH PRIVILEGES;
```

Para atualizar um banco da versão antiga, faça backup e execute:

```bash
mysql -u root -p < database/migration_api.sql
mysql -u root -p < database/migration_regras.sql
```

A `migration_regras.sql` converte as datas de texto para `DATE`, cria as datas de nascimento e o valor mensal do contrato e vincula cada pagamento a um contrato do cliente. Pagamentos de clientes sem contrato são removidos. Depois de executá-la, informe a data de nascimento dos clientes e dependentes e salve os contratos novamente para calcular o valor mensal.

A migração da API mantém o endereço antigo no campo `rua`. Os demais campos devem ser revisados. No primeiro login de um usuário antigo, a API valida a credencial legada uma única vez, grava o hash BCrypt e apaga a senha em texto puro.

## Executar a API

Requisitos: SDK .NET 8 e MySQL/MariaDB.

1. Crie o arquivo de configuração local, ignorado pelo Git:

```bash
cp api/src/GestaoPlanosSaude.Api/appsettings.Development.example.json api/src/GestaoPlanosSaude.Api/appsettings.Development.json
```

2. Ajuste a conexão e a chave JWT (mínimo de 32 caracteres) nesse arquivo. Também é possível usar as variáveis `ConnectionStrings__MySql` e `Jwt__Key`.
3. Execute:

```bash
cd api
dotnet restore
dotnet run --project src/GestaoPlanosSaude.Api
```

A API inicia em `http://localhost:5080` pelo perfil local. O Swagger fica em `http://localhost:5080/swagger`.

Para testar pelo Swagger: execute `POST /api/auth/cadastro`, depois `POST /api/auth/login`, copie o valor de `data.token`, clique em **Authorize** e cole o token. Os demais endpoints passam a responder com o usuário autenticado.

## Executar o Flutter

Requisitos: Flutter compatível com Dart 3.12 e dependências da plataforma escolhida.

```bash
cp .env.example .env
flutter pub get
flutter run -d <id-do-dispositivo>
```

O `.env.example` já aponta para `http://10.0.2.2:5080/api`, endereço do computador visto pelo emulador Android. No Linux desktop, use `http://localhost:5080/api` e execute com `flutter run -d linux`. Em celular físico, use o IP do computador na rede local.

A API deve estar em execução antes de abrir o aplicativo.

Na primeira utilização, abra **Registre-se** e crie um usuário com senha de pelo menos seis caracteres. O token retornado no login é salvo pelo armazenamento seguro da plataforma e enviado como `Bearer` nas requisições protegidas.

## Autenticação

- `POST /api/auth/cadastro` grava a senha com hash BCrypt;
- `POST /api/auth/login` valida a senha e gera um JWT assinado com HMAC SHA-256, válido por 120 minutos;
- o token contém id, e-mail e nome do usuário;
- todos os endpoints, exceto cadastro e login, exigem o cabeçalho `Authorization: Bearer <token>`;
- a API valida emissor, público, assinatura e expiração do token.

## Respostas da API

Todos os controllers retornam a estrutura:

```json
{
  "success": true,
  "message": "Operação realizada com sucesso.",
  "data": {},
  "errors": []
}
```

Códigos utilizados:

- `200`/`201`: sucesso;
- `400`: dados inválidos (JSON inválido, campo acima do tamanho permitido, registro relacionado inexistente ou regra de negócio não atendida);
- `401`: token ausente, inválido ou expirado;
- `404`: registro ou rota não encontrados;
- `405`: método HTTP não permitido;
- `409`: e-mail já cadastrado ou registro com vínculos (exemplo: cliente com contratos);
- `500`: erro interno, registrado no log da API.

## Regras de negócio

- Clientes e dependentes possuem data de nascimento; a idade é calculada a partir dela.
- O valor mensal do contrato é a soma da faixa de valor do titular e de cada dependente, conforme a idade de cada um. Ele é calculado ao salvar o contrato.
- A simulação recebe a idade do titular e de cada dependente e retorna o total e o valor por pessoa.
- Na renovação, contratos vencidos com renovação automática ganham nova validade e têm as idades e o valor recalculados; os demais passam para `Vencido`. A API executa a renovação ao iniciar e a cada 24 horas, e também pelo endpoint `POST /api/contratos/renovacoes`.
- O pagamento pertence a um contrato. Sem valor informado, usa o valor mensal do contrato. Um pagamento não pago com vencimento passado é retornado como `Atrasado`, com os dias de atraso.
- O atendimento só é aceito se o cliente tiver contrato ativo com o plano do serviço na data do atendimento.
- Datas são enviadas e retornadas no formato `yyyy-MM-dd`.

## Endpoints principais

- `POST /api/auth/cadastro` e `POST /api/auth/login` são públicos;
- `GET|POST /api/clientes` e `GET|PUT|DELETE /api/clientes/{id}`;
- o mesmo CRUD existe para `planos`, `prestadores`, `dependentes`, `contratos`, `pagamentos`, `servicos`, `faixas-valor` e `atendimentos`;
- `GET /api/servicos/por-plano/{planoId}`;
- `GET /api/faixas-valor/por-plano/{planoId}`;
- `GET /api/atendimentos/por-cliente/{clienteId}`;
- `POST /api/contratos/renovacoes` processa os contratos vencidos;
- `POST /api/simulacoes` executa o cálculo no servidor.

Exemplo de simulação:

```json
{ "plano_id": 1, "idade_titular": 60, "idades_dependentes": [5, 61] }
```

Exemplo de login:

```bash
curl -X POST http://localhost:5080/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"usuario@email.com","senha":"123456"}'
```

Resposta:

```json
{
  "success": true,
  "message": "Login realizado com sucesso.",
  "data": {
    "id": 1,
    "nome": "Usuário",
    "email": "usuario@email.com",
    "token": "eyJhbGciOi..."
  },
  "errors": []
}
```

Use o token retornado nos demais endpoints:

```bash
curl http://localhost:5080/api/planos -H 'Authorization: Bearer SEU_TOKEN'
```

Sem token ou com token inválido, a resposta é `401`:

```json
{
  "success": false,
  "message": "Autenticação necessária.",
  "data": null,
  "errors": ["Informe um token JWT válido."]
}
```

## Cache

A listagem completa de planos é armazenada em memória por cinco minutos. Buscas textuais consultam o banco diretamente. Inclusão, alteração ou exclusão de um plano invalida o cache, garantindo que a próxima listagem consulte a fonte original.

Cada situação é registrada no log do terminal da API:

- `Cache de planos vazio; consultando o banco de dados.`
- `Listagem de planos recuperada do cache.`
- `Cache de planos invalidado após gravação.` / `Cache de planos invalidado após exclusão.`

Para verificar, chame `GET /api/planos` duas vezes, altere um plano e chame novamente.

## Configurações sensíveis

O `.env`, strings de conexão reais e chaves JWT não devem ser versionados. Use variáveis de ambiente no ambiente de entrega/produção.
