using GestaoPlanosSaude.Domain.Entities;

namespace GestaoPlanosSaude.Domain.Repositories;

public interface IRepository<T> where T : class, IEntity
{
    Task<IReadOnlyList<T>> ListarAsync(string? busca = null);
    Task<T?> ObterAsync(int id);
    Task<int> InserirAsync(T entidade);
    Task<bool> AtualizarAsync(T entidade);
    Task<bool> ExcluirAsync(int id);
}

public interface IUsuarioRepository
{
    Task<Usuario?> ObterPorEmailAsync(string email);
    Task<int> InserirAsync(Usuario usuario);
    Task<bool> ValidarSenhaLegadaAsync(int id, string senha);
    Task AtualizarSenhaHashAsync(int id, string senhaHash);
}

public interface IFaixaValorRepository : IRepository<FaixaValor>
{
    Task<IReadOnlyList<FaixaValor>> ListarPorPlanoAsync(int planoId);
    Task<FaixaValor?> ObterPorIdadeAsync(int planoId, int idade);
}

public interface IServicoRepository : IRepository<Servico>
{
    Task<IReadOnlyList<Servico>> ListarPorPlanoAsync(int planoId);
}

public interface IAtendimentoRepository : IRepository<Atendimento>
{
    Task<IReadOnlyList<Atendimento>> ListarPorClienteAsync(int clienteId);
}

public interface IDependenteRepository : IRepository<Dependente>
{
    Task<IReadOnlyList<Dependente>> ListarPorClienteAsync(int clienteId);
}

public interface IContratoRepository : IRepository<Contrato>
{
    Task<IReadOnlyList<Contrato>> ListarVencidosAtivosAsync(DateOnly dataReferencia);
    Task<bool> PossuiContratoAtivoAsync(int clienteId, int planoId, DateOnly data);
}
