namespace GestaoPlanosSaude.Domain.Entities;

public interface IEntity
{
    int Id { get; set; }
}

public sealed class Cliente : IEntity
{
    public int Id { get; set; }
    public string Nome { get; set; } = "";
    public string Cpf { get; set; } = "";
    public string Telefone { get; set; } = "";
    public string Email { get; set; } = "";
    public string Rua { get; set; } = "";
    public string Numero { get; set; } = "";
    public string Complemento { get; set; } = "";
    public string Bairro { get; set; } = "";
    public string Cidade { get; set; } = "";
    public string Estado { get; set; } = "";
    public string Cep { get; set; } = "";
}

public sealed class Dependente : IEntity
{
    public int Id { get; set; }
    public int ClienteId { get; set; }
    public string Nome { get; set; } = "";
    public string Cpf { get; set; } = "";
    public string Parentesco { get; set; } = "";
    public string ClienteNome { get; set; } = "";
}

public sealed class Plano : IEntity
{
    public int Id { get; set; }
    public string Nome { get; set; } = "";
    public string TipoCobertura { get; set; } = "";
    public decimal Valor { get; set; }
    public decimal ValorDependente { get; set; }
    public string Vigencia { get; set; } = "";
    public string FormaPagamento { get; set; } = "";
}

public sealed class Prestador : IEntity
{
    public int Id { get; set; }
    public string Nome { get; set; } = "";
    public string Tipo { get; set; } = "";
    public string Especialidade { get; set; } = "";
    public string Localizacao { get; set; } = "";
}

public sealed class Contrato : IEntity
{
    public int Id { get; set; }
    public int ClienteId { get; set; }
    public int PlanoId { get; set; }
    public string DataInicio { get; set; } = "";
    public string Validade { get; set; } = "";
    public string Status { get; set; } = "Ativo";
    public bool RenovacaoAutomatica { get; set; }
    public string ClienteNome { get; set; } = "";
    public string PlanoNome { get; set; } = "";
}

public sealed class Pagamento : IEntity
{
    public int Id { get; set; }
    public int ClienteId { get; set; }
    public decimal Valor { get; set; }
    public string Vencimento { get; set; } = "";
    public string Status { get; set; } = "Pendente";
    public string ClienteNome { get; set; } = "";
}

public sealed class Servico : IEntity
{
    public int Id { get; set; }
    public int PlanoId { get; set; }
    public int PrestadorId { get; set; }
    public string Nome { get; set; } = "";
    public string PlanoNome { get; set; } = "";
    public string PrestadorNome { get; set; } = "";
}

public sealed class FaixaValor : IEntity
{
    public int Id { get; set; }
    public int PlanoId { get; set; }
    public int IdadeMin { get; set; }
    public int IdadeMax { get; set; }
    public decimal Valor { get; set; }
}

public sealed class Atendimento : IEntity
{
    public int Id { get; set; }
    public int ClienteId { get; set; }
    public int ServicoId { get; set; }
    public string Data { get; set; } = "";
    public string Horario { get; set; } = "";
    public string Descricao { get; set; } = "";
    public string ClienteNome { get; set; } = "";
    public string ServicoNome { get; set; } = "";
    public string PlanoNome { get; set; } = "";
    public string PrestadorNome { get; set; } = "";
}

public sealed class Usuario : IEntity
{
    public int Id { get; set; }
    public string Nome { get; set; } = "";
    public string Email { get; set; } = "";
    public string SenhaHash { get; set; } = "";
}
