using GestaoPlanosSaude.Domain.Entities;
using GestaoPlanosSaude.Domain.Exceptions;
using GestaoPlanosSaude.Domain.Regras;
using GestaoPlanosSaude.Domain.Repositories;

namespace GestaoPlanosSaude.Application.Services;

public sealed record RenovacaoResultado(int Renovados, int Encerrados, IReadOnlyList<string> Erros);

public sealed class ContratoService(
    IContratoRepository contratoRepository,
    IRepository<Cliente> clienteRepository,
    IDependenteRepository dependenteRepository,
    MensalidadeService mensalidadeService) : CrudService<Contrato>(contratoRepository)
{
    public override async Task<int> SalvarAsync(Contrato contrato)
    {
        if (contrato.Validade <= contrato.DataInicio)
        {
            throw new DadosInvalidosException("A validade deve ser posterior à data de início.");
        }

        var hoje = DateOnly.FromDateTime(DateTime.Today);
        contrato.ValorMensal = await CalcularValorMensalAsync(contrato, hoje);
        return await base.SalvarAsync(contrato);
    }

    public async Task<RenovacaoResultado> RenovarVencidosAsync(DateOnly hoje)
    {
        var contratos = await contratoRepository.ListarVencidosAtivosAsync(hoje);
        var renovados = 0;
        var encerrados = 0;
        var erros = new List<string>();

        foreach (var contrato in contratos)
        {
            if (!contrato.RenovacaoAutomatica)
            {
                contrato.Status = StatusContrato.Vencido;
                await contratoRepository.AtualizarAsync(contrato);
                encerrados++;
                continue;
            }

            try
            {
                await RenovarAsync(contrato, hoje);
                renovados++;
            }
            catch (DadosInvalidosException exception)
            {
                erros.Add($"Contrato {contrato.Id}: {exception.Message}");
            }
        }

        return new(renovados, encerrados, erros);
    }

    private async Task RenovarAsync(Contrato contrato, DateOnly hoje)
    {
        var novaValidade = contrato.Validade;
        while (novaValidade < hoje)
        {
            novaValidade = novaValidade.AddYears(1);
        }

        contrato.ValorMensal = await CalcularValorMensalAsync(contrato, hoje);
        contrato.Validade = novaValidade;
        await contratoRepository.AtualizarAsync(contrato);
    }

    private async Task<decimal> CalcularValorMensalAsync(Contrato contrato, DateOnly dataReferencia)
    {
        var cliente = await clienteRepository.ObterAsync(contrato.ClienteId);
        if (cliente is null)
        {
            throw new DadosInvalidosException("Cliente não encontrado.");
        }

        var pessoas = new List<PessoaMensalidade>
        {
            CriarPessoa(cliente.Nome, cliente.DataNascimento, dataReferencia)
        };
        var dependentes = await dependenteRepository.ListarPorClienteAsync(cliente.Id);
        foreach (var dependente in dependentes)
        {
            pessoas.Add(CriarPessoa(dependente.Nome, dependente.DataNascimento, dataReferencia));
        }

        var mensalidade = await mensalidadeService.CalcularAsync(contrato.PlanoId, pessoas);
        return mensalidade.ValorTotal;
    }

    private static PessoaMensalidade CriarPessoa(
        string nome,
        DateOnly? dataNascimento,
        DateOnly dataReferencia)
    {
        if (dataNascimento is null)
        {
            throw new DadosInvalidosException($"Informe a data de nascimento de {nome}.");
        }

        var idade = Idade.Calcular(dataNascimento.Value, dataReferencia);
        return new(nome, idade);
    }
}
