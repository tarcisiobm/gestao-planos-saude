namespace GestaoPlanosSaude.Application.Services;

public sealed class SimulacaoService(MensalidadeService mensalidadeService)
{
    public Task<Mensalidade> SimularAsync(
        int planoId,
        int idadeTitular,
        IReadOnlyList<int> idadesDependentes)
    {
        var pessoas = new List<PessoaMensalidade> { new("Titular", idadeTitular) };
        for (var indice = 0; indice < idadesDependentes.Count; indice++)
        {
            var descricao = $"Dependente {indice + 1}";
            pessoas.Add(new(descricao, idadesDependentes[indice]));
        }

        return mensalidadeService.CalcularAsync(planoId, pessoas);
    }
}
