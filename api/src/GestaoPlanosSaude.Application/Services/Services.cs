using GestaoPlanosSaude.Domain.Entities;
using GestaoPlanosSaude.Domain.Repositories;

namespace GestaoPlanosSaude.Application.Services;

public interface ICrudService<T> where T : class, IEntity
{
    Task<IReadOnlyList<T>> ListarAsync(string? busca = null);
    Task<T?> ObterAsync(int id);
    Task<int> SalvarAsync(T entidade);
    Task<bool> ExcluirAsync(int id);
}

public class CrudService<T>(IRepository<T> repository) : ICrudService<T> where T : class, IEntity
{
    public Task<IReadOnlyList<T>> ListarAsync(string? busca = null)
    {
        return repository.ListarAsync(busca);
    }

    public Task<T?> ObterAsync(int id)
    {
        return repository.ObterAsync(id);
    }

    public async Task<int> SalvarAsync(T entidade)
    {
        if (entidade.Id == 0)
        {
            return await repository.InserirAsync(entidade);
        }

        var atualizado = await repository.AtualizarAsync(entidade);
        if (!atualizado)
        {
            return 0;
        }

        return entidade.Id;
    }

    public Task<bool> ExcluirAsync(int id)
    {
        return repository.ExcluirAsync(id);
    }
}

public sealed record SimulacaoResultado(
    decimal ValorTotal,
    decimal ValorFaixa,
    decimal ValorDependente,
    int QuantidadeDependentes);

public sealed class SimulacaoService(
    IRepository<Plano> planoRepository,
    IFaixaValorRepository faixaValorRepository)
{
    public async Task<SimulacaoResultado?> SimularAsync(
        int planoId,
        int idade,
        int quantidadeDependentes)
    {
        var idadeInvalida = idade < 0;
        var quantidadeInvalida = quantidadeDependentes < 0;
        if (idadeInvalida || quantidadeInvalida)
        {
            return null;
        }

        var plano = await planoRepository.ObterAsync(planoId);
        if (plano is null)
        {
            return null;
        }

        var faixaValor = await faixaValorRepository.ObterPorIdadeAsync(planoId, idade);
        if (faixaValor is null)
        {
            return null;
        }

        var valorDependentes = quantidadeDependentes * plano.ValorDependente;
        var valorTotal = faixaValor.Valor + valorDependentes;

        return new(
            valorTotal,
            faixaValor.Valor,
            plano.ValorDependente,
            quantidadeDependentes);
    }
}

public sealed record LoginRequest(string Email, string Senha);
public sealed record CadastroUsuarioRequest(string Nome, string Email, string Senha);
public sealed record UsuarioAutenticado(int Id, string Nome, string Email, string Token);

public interface IPasswordHasher
{
    string CriarHash(string senha);
    bool Verificar(string senha, string hash);
}

public interface ITokenService
{
    string Gerar(Usuario usuario);
}

public sealed class AuthService(
    IUsuarioRepository usuarioRepository,
    IPasswordHasher passwordHasher,
    ITokenService tokenService)
{
    public async Task<UsuarioAutenticado?> AutenticarAsync(LoginRequest request)
    {
        var emailNaoInformado = string.IsNullOrWhiteSpace(request.Email);
        var senhaNaoInformada = string.IsNullOrWhiteSpace(request.Senha);
        if (emailNaoInformado || senhaNaoInformada)
        {
            return null;
        }

        var email = request.Email.Trim();
        var usuario = await usuarioRepository.ObterPorEmailAsync(email);
        if (usuario is null)
        {
            return null;
        }

        var senhaValida = passwordHasher.Verificar(request.Senha, usuario.SenhaHash);
        if (!senhaValida)
        {
            senhaValida = await usuarioRepository.ValidarSenhaLegadaAsync(usuario.Id, request.Senha);
            if (senhaValida)
            {
                var senhaHash = passwordHasher.CriarHash(request.Senha);
                await usuarioRepository.AtualizarSenhaHashAsync(usuario.Id, senhaHash);
            }
        }

        if (!senhaValida)
        {
            return null;
        }

        var token = tokenService.Gerar(usuario);
        return new(usuario.Id, usuario.Nome, usuario.Email, token);
    }

    public async Task<int> CadastrarAsync(CadastroUsuarioRequest request)
    {
        var emailNaoInformado = string.IsNullOrWhiteSpace(request.Email);
        var senhaNaoInformada = string.IsNullOrWhiteSpace(request.Senha);
        if (emailNaoInformado || senhaNaoInformada)
        {
            return 0;
        }

        var email = request.Email.Trim();
        var usuarioExistente = await usuarioRepository.ObterPorEmailAsync(email);
        if (usuarioExistente is not null)
        {
            return 0;
        }

        var usuario = new Usuario
        {
            Nome = request.Nome.Trim(),
            Email = email,
            SenhaHash = passwordHasher.CriarHash(request.Senha)
        };

        return await usuarioRepository.InserirAsync(usuario);
    }
}
