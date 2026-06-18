# Plano de Desenvolvimento

Tracker do trabalho. Marcar `[x]` ao concluir. Princípio: menos = mais, código simples
(ver `CLAUDE.md`). Git/commits ficam para o fim.

> Status (2026-06-14): **app completo** — 9 módulos cobrindo todos os RF/RN, + login.
> `flutter analyze` sem erros e camada de dados testada. Falta rodar no desktop
> (instalar libs GTK) e a entrega (DER em PNG/PDF, doc, Git, SIGAA).

## Núcleo (feito)

### [x] 0. Setup — app Flutter, pacotes, estrutura em camadas, HomePage
### [x] 1. Modelagem — DER (`database/der.md`) + DDL MySQL (`database/schema.sql`)
### [x] 2. Banco — MySQL/MariaDB, tabelas + seed de 10 por tabela
### [x] 3. CRUD Cliente — RF01
### [x] 4. CRUD Plano — RF02
### [x] 5. CRUD Prestador — RF06

## Módulos restantes (feitos)

- [x] **Dependente** — RF01 (completa) / RN03. CRUD com dropdown do titular.
- [x] **Contrato** — RF03 / RN01. Liga Cliente + Plano; data, validade, status,
      switch de renovação automática.
- [x] **Pagamento** — RF05 / RN05. CRUD com status pago/pendente/atrasado.
- [x] **Serviço** — RF07 / RN04. Liga Plano × Prestador e nome do serviço oferecido.
- [x] **Faixas de valor** — valores configuráveis por idade dentro de cada plano.
- [x] **Simulação** — RF04 / RN02. Tela que calcula valor estimado por idade + dependentes.
- [x] **Histórico** — RF08 / RF09. Cadastro de atendimentos e histórico por cliente.
- [x] **Login/Registro** — tela de login + cadastro de usuário (igual ao exemplo do
      prof); o app abre no login. Usuário padrão: `admin@email.com` / `123`.

Cada CRUD tem busca, popup de exclusão, FAB e dados em banco. Cada lista tem ≥ 10 itens.

## Entrega (falta)

- [ ] Rodar no desktop — instalar as libs uma vez (precisa de sudo):
      `sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev` e depois
      `flutter run -d linux`
- [ ] Exportar o DER em PNG/PDF para a entrega
- [ ] Documentação (modelo da sala) — preencher "Plano de Liberação" no doc
- [ ] Montar o Git/GitHub a partir do projeto pronto e pegar o link
- [ ] Compactar e enviar no SIGAA (+ backup no Drive)

## Entregáveis finais (enunciado)

- [x] DDL `.sql` (MySQL/MariaDB) — `database/schema.sql`
- [x] App completo (todos os RF/RN) — `flutter analyze` limpo
- [ ] DER imagem/PDF (fonte Mermaid pronta em `database/der.md`; falta exportar)
- [ ] Documentação (base em `docs/`)
- [ ] Link do repositório no GitHub
- [ ] Projeto compactado e enviado no SIGAA (não atualizar após a data)
