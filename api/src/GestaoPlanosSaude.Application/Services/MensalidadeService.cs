using GestaoPlanosSaude.Domain.Exceptions;
using GestaoPlanosSaude.Domain.Repositories;

namespace GestaoPlanosSaude.Application.Services;

public sealed record PessoaMensalidade(string Descricao, int Idade);
public sealed record ValorPessoa(string Descricao, int Idade, decimal Valor);
public sealed record Mensalidade(decimal ValorTotal, IReadOnlyList<ValorPessoa> Pessoas);

public sealed class MensalidadeService(IFaixaValorRepository faixaValorRepository)
{
    public async Task<Mensalidade> CalcularAsync(int planoId, IReadOnlyList<PessoaMensalidade> pessoas)
    {
        var valores = new List<ValorPessoa>();
        foreach (var pessoa in pessoas)
        {
            var valor = await ObterValorDaFaixaAsync(planoId, pessoa.Idade);
            valores.Add(new(pessoa.Descricao, pessoa.Idade, valor));
        }

        var valorTotal = valores.Sum(valorPessoa => valorPessoa.Valor);
        return new(valorTotal, valores);
    }

    private async Task<decimal> ObterValorDaFaixaAsync(int planoId, int idade)
    {
        if (idade < 0)
        {
            throw new DadosInvalidosException("A idade não pode ser negativa.");
        }

        var faixa = await faixaValorRepository.ObterPorIdadeAsync(planoId, idade);
        if (faixa is null)
        {
            throw new DadosInvalidosException($"O plano não possui faixa de valor para a idade {idade}.");
        }

        return faixa.Valor;
    }
}
