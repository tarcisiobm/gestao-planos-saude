using Dapper;
using GestaoPlanosSaude.Domain.Entities;
using GestaoPlanosSaude.Domain.Repositories;
using GestaoPlanosSaude.Infrastructure.Data;

namespace GestaoPlanosSaude.Infrastructure.Repositories;

public abstract class DapperRepository<T>(IDbConnectionFactory factory) : IRepository<T>
    where T : class, IEntity
{
    protected IDbConnectionFactory Factory { get; } = factory;
    protected abstract string SelectSql { get; }
    protected abstract string InsertSql { get; }
    protected abstract string UpdateSql { get; }
    protected abstract string TableName { get; }
    protected virtual string OrderBy => "id DESC";
    protected virtual string SearchWhere => "1 = 1";

    public virtual async Task<IReadOnlyList<T>> ListarAsync(string? busca = null)
    {
        var sql = SelectSql;
        if (!string.IsNullOrWhiteSpace(busca))
        {
            sql += $" WHERE {SearchWhere}";
        }

        sql += $" ORDER BY {OrderBy}";
        var parametros = new { Busca = $"%{busca}%" };

        await using var connection = Factory.Criar();
        var registros = await connection.QueryAsync<T>(sql, parametros);
        return registros.AsList();
    }

    public virtual async Task<T?> ObterAsync(int id)
    {
        var sql = $"{SelectSql} WHERE {TableName}.id = @Id";

        await using var connection = Factory.Criar();
        return await connection.QuerySingleOrDefaultAsync<T>(sql, new { Id = id });
    }

    public async Task<int> InserirAsync(T entidade)
    {
        var sql = $"{InsertSql}; SELECT LAST_INSERT_ID();";

        await using var connection = Factory.Criar();
        return await connection.ExecuteScalarAsync<int>(sql, entidade);
    }

    public async Task<bool> AtualizarAsync(T entidade)
    {
        await using var connection = Factory.Criar();
        var registrosAlterados = await connection.ExecuteAsync(UpdateSql, entidade);
        return registrosAlterados > 0;
    }

    public async Task<bool> ExcluirAsync(int id)
    {
        var sql = $"DELETE FROM {TableName} WHERE id = @Id";

        await using var connection = Factory.Criar();
        var registrosExcluidos = await connection.ExecuteAsync(sql, new { Id = id });
        return registrosExcluidos > 0;
    }
}

public sealed class ClienteRepository(IDbConnectionFactory factory)
    : DapperRepository<Cliente>(factory)
{
    protected override string TableName => "cliente";
    protected override string SelectSql => "SELECT * FROM cliente";
    protected override string SearchWhere => "nome LIKE @Busca OR cpf LIKE @Busca";
    protected override string OrderBy => "nome";
    protected override string InsertSql => """
        INSERT INTO cliente
            (nome, cpf, telefone, email, rua, numero, complemento, bairro, cidade, estado, cep)
        VALUES
            (@Nome, @Cpf, @Telefone, @Email, @Rua, @Numero, @Complemento, @Bairro, @Cidade, @Estado, @Cep)
        """;
    protected override string UpdateSql => """
        UPDATE cliente
        SET nome = @Nome,
            cpf = @Cpf,
            telefone = @Telefone,
            email = @Email,
            rua = @Rua,
            numero = @Numero,
            complemento = @Complemento,
            bairro = @Bairro,
            cidade = @Cidade,
            estado = @Estado,
            cep = @Cep
        WHERE id = @Id
        """;
}

public sealed class PlanoRepository(IDbConnectionFactory factory)
    : DapperRepository<Plano>(factory)
{
    protected override string TableName => "plano";
    protected override string SelectSql => "SELECT * FROM plano";
    protected override string SearchWhere => "nome LIKE @Busca";
    protected override string OrderBy => "nome";
    protected override string InsertSql => """
        INSERT INTO plano
            (nome, tipo_cobertura, valor, valor_dependente, vigencia, forma_pagamento)
        VALUES
            (@Nome, @TipoCobertura, @Valor, @ValorDependente, @Vigencia, @FormaPagamento)
        """;
    protected override string UpdateSql => """
        UPDATE plano
        SET nome = @Nome,
            tipo_cobertura = @TipoCobertura,
            valor = @Valor,
            valor_dependente = @ValorDependente,
            vigencia = @Vigencia,
            forma_pagamento = @FormaPagamento
        WHERE id = @Id
        """;
}

public sealed class PrestadorRepository(IDbConnectionFactory factory)
    : DapperRepository<Prestador>(factory)
{
    protected override string TableName => "prestador";
    protected override string SelectSql => "SELECT * FROM prestador";
    protected override string SearchWhere => "nome LIKE @Busca";
    protected override string OrderBy => "nome";
    protected override string InsertSql => """
        INSERT INTO prestador (nome, tipo, especialidade, localizacao)
        VALUES (@Nome, @Tipo, @Especialidade, @Localizacao)
        """;
    protected override string UpdateSql => """
        UPDATE prestador
        SET nome = @Nome,
            tipo = @Tipo,
            especialidade = @Especialidade,
            localizacao = @Localizacao
        WHERE id = @Id
        """;
}

public sealed class DependenteRepository(IDbConnectionFactory factory)
    : DapperRepository<Dependente>(factory)
{
    protected override string TableName => "dependente";
    protected override string SelectSql => """
        SELECT dependente.*, cliente.nome cliente_nome
        FROM dependente
        LEFT JOIN cliente ON cliente.id = dependente.cliente_id
        """;
    protected override string SearchWhere => "dependente.nome LIKE @Busca OR cliente.nome LIKE @Busca";
    protected override string OrderBy => "dependente.nome";
    protected override string InsertSql => """
        INSERT INTO dependente (cliente_id, nome, cpf, parentesco)
        VALUES (@ClienteId, @Nome, @Cpf, @Parentesco)
        """;
    protected override string UpdateSql => """
        UPDATE dependente
        SET cliente_id = @ClienteId,
            nome = @Nome,
            cpf = @Cpf,
            parentesco = @Parentesco
        WHERE id = @Id
        """;
}

public sealed class ContratoRepository(IDbConnectionFactory factory)
    : DapperRepository<Contrato>(factory)
{
    protected override string TableName => "contrato";
    protected override string SelectSql => """
        SELECT contrato.*, cliente.nome cliente_nome, plano.nome plano_nome
        FROM contrato
        LEFT JOIN cliente ON cliente.id = contrato.cliente_id
        LEFT JOIN plano ON plano.id = contrato.plano_id
        """;
    protected override string SearchWhere => "cliente.nome LIKE @Busca OR plano.nome LIKE @Busca";
    protected override string InsertSql => """
        INSERT INTO contrato
            (cliente_id, plano_id, data_inicio, validade, status, renovacao_automatica)
        VALUES
            (@ClienteId, @PlanoId, @DataInicio, @Validade, @Status, @RenovacaoAutomatica)
        """;
    protected override string UpdateSql => """
        UPDATE contrato
        SET cliente_id = @ClienteId,
            plano_id = @PlanoId,
            data_inicio = @DataInicio,
            validade = @Validade,
            status = @Status,
            renovacao_automatica = @RenovacaoAutomatica
        WHERE id = @Id
        """;
}

public sealed class PagamentoRepository(IDbConnectionFactory factory)
    : DapperRepository<Pagamento>(factory)
{
    protected override string TableName => "pagamento";
    protected override string SelectSql => """
        SELECT pagamento.*, cliente.nome cliente_nome
        FROM pagamento
        LEFT JOIN cliente ON cliente.id = pagamento.cliente_id
        """;
    protected override string SearchWhere => "cliente.nome LIKE @Busca";
    protected override string InsertSql => """
        INSERT INTO pagamento (cliente_id, valor, vencimento, status)
        VALUES (@ClienteId, @Valor, @Vencimento, @Status)
        """;
    protected override string UpdateSql => """
        UPDATE pagamento
        SET cliente_id = @ClienteId,
            valor = @Valor,
            vencimento = @Vencimento,
            status = @Status
        WHERE id = @Id
        """;
}

public sealed class ServicoRepository(IDbConnectionFactory factory)
    : DapperRepository<Servico>(factory), IServicoRepository
{
    protected override string TableName => "servico";
    protected override string SelectSql => """
        SELECT servico.*, plano.nome plano_nome, prestador.nome prestador_nome
        FROM servico
        LEFT JOIN plano ON plano.id = servico.plano_id
        LEFT JOIN prestador ON prestador.id = servico.prestador_id
        """;
    protected override string SearchWhere => "servico.nome LIKE @Busca";
    protected override string OrderBy => "servico.nome";
    protected override string InsertSql => """
        INSERT INTO servico (plano_id, prestador_id, nome)
        VALUES (@PlanoId, @PrestadorId, @Nome)
        """;
    protected override string UpdateSql => """
        UPDATE servico
        SET plano_id = @PlanoId,
            prestador_id = @PrestadorId,
            nome = @Nome
        WHERE id = @Id
        """;

    public async Task<IReadOnlyList<Servico>> ListarPorPlanoAsync(int planoId)
    {
        var sql = $"{SelectSql} WHERE servico.plano_id = @PlanoId ORDER BY servico.nome";

        await using var connection = Factory.Criar();
        var servicos = await connection.QueryAsync<Servico>(sql, new { PlanoId = planoId });
        return servicos.AsList();
    }
}

public sealed class FaixaValorRepository(IDbConnectionFactory factory)
    : DapperRepository<FaixaValor>(factory), IFaixaValorRepository
{
    protected override string TableName => "faixa_valor";
    protected override string SelectSql => "SELECT * FROM faixa_valor";
    protected override string OrderBy => "idade_min";
    protected override string InsertSql => """
        INSERT INTO faixa_valor (plano_id, idade_min, idade_max, valor)
        VALUES (@PlanoId, @IdadeMin, @IdadeMax, @Valor)
        """;
    protected override string UpdateSql => """
        UPDATE faixa_valor
        SET plano_id = @PlanoId,
            idade_min = @IdadeMin,
            idade_max = @IdadeMax,
            valor = @Valor
        WHERE id = @Id
        """;

    public async Task<IReadOnlyList<FaixaValor>> ListarPorPlanoAsync(int planoId)
    {
        var sql = $"{SelectSql} WHERE plano_id = @PlanoId ORDER BY idade_min";

        await using var connection = Factory.Criar();
        var faixas = await connection.QueryAsync<FaixaValor>(sql, new { PlanoId = planoId });
        return faixas.AsList();
    }

    public async Task<FaixaValor?> ObterPorIdadeAsync(int planoId, int idade)
    {
        var sql = $"""
            {SelectSql}
            WHERE plano_id = @PlanoId
              AND @Idade BETWEEN idade_min AND idade_max
            LIMIT 1
            """;
        var parametros = new { PlanoId = planoId, Idade = idade };

        await using var connection = Factory.Criar();
        return await connection.QuerySingleOrDefaultAsync<FaixaValor>(sql, parametros);
    }
}

public sealed class AtendimentoRepository(IDbConnectionFactory factory)
    : DapperRepository<Atendimento>(factory), IAtendimentoRepository
{
    protected override string TableName => "atendimento";
    protected override string SelectSql => """
        SELECT atendimento.*,
               cliente.nome cliente_nome,
               servico.nome servico_nome,
               plano.nome plano_nome,
               prestador.nome prestador_nome
        FROM atendimento
        LEFT JOIN cliente ON cliente.id = atendimento.cliente_id
        LEFT JOIN servico ON servico.id = atendimento.servico_id
        LEFT JOIN plano ON plano.id = servico.plano_id
        LEFT JOIN prestador ON prestador.id = servico.prestador_id
        """;
    protected override string SearchWhere => "cliente.nome LIKE @Busca OR servico.nome LIKE @Busca";
    protected override string InsertSql => """
        INSERT INTO atendimento (cliente_id, servico_id, data, horario, descricao)
        VALUES (@ClienteId, @ServicoId, @Data, @Horario, @Descricao)
        """;
    protected override string UpdateSql => """
        UPDATE atendimento
        SET cliente_id = @ClienteId,
            servico_id = @ServicoId,
            data = @Data,
            horario = @Horario,
            descricao = @Descricao
        WHERE id = @Id
        """;

    public async Task<IReadOnlyList<Atendimento>> ListarPorClienteAsync(int clienteId)
    {
        var sql = $"{SelectSql} WHERE atendimento.cliente_id = @ClienteId ORDER BY atendimento.id DESC";

        await using var connection = Factory.Criar();
        var atendimentos = await connection.QueryAsync<Atendimento>(sql, new { ClienteId = clienteId });
        return atendimentos.AsList();
    }
}

public sealed class UsuarioRepository(IDbConnectionFactory factory) : IUsuarioRepository
{
    public async Task<Usuario?> ObterPorEmailAsync(string email)
    {
        const string sql = """
            SELECT id, nome, email, senha_hash
            FROM usuario
            WHERE email = @Email
            LIMIT 1
            """;

        await using var connection = factory.Criar();
        return await connection.QuerySingleOrDefaultAsync<Usuario>(sql, new { Email = email });
    }

    public async Task<int> InserirAsync(Usuario usuario)
    {
        const string sql = """
            INSERT INTO usuario (nome, email, senha_hash)
            VALUES (@Nome, @Email, @SenhaHash);
            SELECT LAST_INSERT_ID();
            """;

        await using var connection = factory.Criar();
        return await connection.ExecuteScalarAsync<int>(sql, usuario);
    }

    public async Task<bool> ValidarSenhaLegadaAsync(int id, string senha)
    {
        const string sql = """
            SELECT COUNT(*)
            FROM usuario
            WHERE id = @Id AND senha = @Senha
            """;
        var parametros = new { Id = id, Senha = senha };

        await using var connection = factory.Criar();
        var total = await connection.ExecuteScalarAsync<int>(sql, parametros);
        return total > 0;
    }

    public async Task AtualizarSenhaHashAsync(int id, string senhaHash)
    {
        const string sql = """
            UPDATE usuario
            SET senha_hash = @SenhaHash, senha = NULL
            WHERE id = @Id
            """;
        var parametros = new { Id = id, SenhaHash = senhaHash };

        await using var connection = factory.Criar();
        await connection.ExecuteAsync(sql, parametros);
    }
}
