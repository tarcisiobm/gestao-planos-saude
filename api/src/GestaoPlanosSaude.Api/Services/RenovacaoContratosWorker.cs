using GestaoPlanosSaude.Application.Services;

namespace GestaoPlanosSaude.Api.Services;

public sealed class RenovacaoContratosWorker(
    IServiceScopeFactory scopeFactory,
    ILogger<RenovacaoContratosWorker> logger) : BackgroundService
{
    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        using var timer = new PeriodicTimer(TimeSpan.FromHours(24));
        do
        {
            await RenovarContratosAsync();
        }
        while (await timer.WaitForNextTickAsync(stoppingToken));
    }

    private async Task RenovarContratosAsync()
    {
        try
        {
            using var scope = scopeFactory.CreateScope();
            var contratoService = scope.ServiceProvider.GetRequiredService<ContratoService>();
            var hoje = DateOnly.FromDateTime(DateTime.Today);
            var resultado = await contratoService.RenovarVencidosAsync(hoje);
            logger.LogInformation(
                "Renovação automática: {Renovados} renovado(s), {Encerrados} encerrado(s), {Erros} com erro.",
                resultado.Renovados,
                resultado.Encerrados,
                resultado.Erros.Count);
        }
        catch (Exception exception)
        {
            logger.LogError(exception, "Erro ao executar a renovação automática de contratos.");
        }
    }
}
