using GestaoPlanosSaude.Domain.Entities;
using GestaoPlanosSaude.Domain.Exceptions;
using GestaoPlanosSaude.Domain.Regras;
using GestaoPlanosSaude.Domain.Repositories;

namespace GestaoPlanosSaude.Application.Services;

public sealed class PagamentoService(
    IRepository<Pagamento> pagamentoRepository,
    IContratoRepository contratoRepository) : CrudService<Pagamento>(pagamentoRepository)
{
    public override async Task<IReadOnlyList<Pagamento>> ListarAsync(string? busca = null)
    {
        var pagamentos = await base.ListarAsync(busca);
        var hoje = DateOnly.FromDateTime(DateTime.Today);
        foreach (var pagamento in pagamentos)
        {
            AtualizarSituacao(pagamento, hoje);
        }

        return pagamentos;
    }

    public override async Task<Pagamento?> ObterAsync(int id)
    {
        var pagamento = await base.ObterAsync(id);
        if (pagamento is null)
        {
            return null;
        }

        var hoje = DateOnly.FromDateTime(DateTime.Today);
        AtualizarSituacao(pagamento, hoje);
        return pagamento;
    }

    public override async Task<int> SalvarAsync(Pagamento pagamento)
    {
        var contrato = await contratoRepository.ObterAsync(pagamento.ContratoId);
        if (contrato is null)
        {
            throw new DadosInvalidosException("Contrato não encontrado.");
        }

        if (pagamento.Valor <= 0)
        {
            pagamento.Valor = contrato.ValorMensal;
        }

        if (pagamento.Status != StatusPagamento.Pago)
        {
            pagamento.Status = StatusPagamento.Pendente;
        }

        return await base.SalvarAsync(pagamento);
    }

    private static void AtualizarSituacao(Pagamento pagamento, DateOnly hoje)
    {
        var pago = pagamento.Status == StatusPagamento.Pago;
        var vencido = pagamento.Vencimento < hoje;
        if (pago || !vencido)
        {
            return;
        }

        pagamento.Status = StatusPagamento.Atrasado;
        pagamento.DiasAtraso = hoje.DayNumber - pagamento.Vencimento.DayNumber;
    }
}
