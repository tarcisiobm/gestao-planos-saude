using GestaoPlanosSaude.Application.Services;
using GestaoPlanosSaude.Domain.Entities;
using GestaoPlanosSaude.Domain.Repositories;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Logging;

namespace GestaoPlanosSaude.Infrastructure.Services;

public sealed class PasswordHasher : IPasswordHasher
{
    public string CriarHash(string senha) => BCrypt.Net.BCrypt.HashPassword(senha);

    public bool Verificar(string senha, string hash)
    {
        if (string.IsNullOrWhiteSpace(hash))
        {
            return false;
        }

        return BCrypt.Net.BCrypt.Verify(senha, hash);
    }
}

public sealed class CachedPlanoService(
    IRepository<Plano> planoRepository,
    IMemoryCache cache,
    ILogger<CachedPlanoService> logger) : ICrudService<Plano>
{
    private const string CacheKey = "planos:todos";

    public async Task<IReadOnlyList<Plano>> ListarAsync(string? busca = null)
    {
        if (!string.IsNullOrWhiteSpace(busca))
        {
            return await planoRepository.ListarAsync(busca);
        }

        var encontradoNoCache = cache.TryGetValue<IReadOnlyList<Plano>>(
            CacheKey,
            out var planosEmCache);
        if (encontradoNoCache && planosEmCache is not null)
        {
            logger.LogInformation("Listagem de planos recuperada do cache.");
            return planosEmCache;
        }

        logger.LogInformation("Cache de planos vazio; consultando o banco de dados.");
        var planos = await planoRepository.ListarAsync();
        cache.Set(CacheKey, planos, TimeSpan.FromMinutes(5));
        return planos;
    }

    public Task<Plano?> ObterAsync(int id)
    {
        return planoRepository.ObterAsync(id);
    }

    public async Task<int> SalvarAsync(Plano plano)
    {
        if (plano.Id == 0)
        {
            var novoId = await planoRepository.InserirAsync(plano);
            if (novoId == 0)
            {
                return 0;
            }

            InvalidarCache("gravação");
            return novoId;
        }

        var atualizado = await planoRepository.AtualizarAsync(plano);
        if (!atualizado)
        {
            return 0;
        }

        InvalidarCache("gravação");
        return plano.Id;
    }

    public async Task<bool> ExcluirAsync(int id)
    {
        var excluido = await planoRepository.ExcluirAsync(id);
        if (!excluido)
        {
            return false;
        }

        InvalidarCache("exclusão");
        return true;
    }

    private void InvalidarCache(string operacao)
    {
        cache.Remove(CacheKey);
        logger.LogInformation("Cache de planos invalidado após {Operacao}.", operacao);
    }
}
