using GestaoPlanosSaude.Domain.Entities;
using GestaoPlanosSaude.Domain.Exceptions;
using GestaoPlanosSaude.Domain.Repositories;

namespace GestaoPlanosSaude.Application.Services;

public sealed class AtendimentoService(
    IAtendimentoRepository atendimentoRepository,
    IServicoRepository servicoRepository,
    IContratoRepository contratoRepository) : CrudService<Atendimento>(atendimentoRepository)
{
    public Task<IReadOnlyList<Atendimento>> ListarPorClienteAsync(int clienteId)
    {
        return atendimentoRepository.ListarPorClienteAsync(clienteId);
    }

    public override async Task<int> SalvarAsync(Atendimento atendimento)
    {
        var servico = await servicoRepository.ObterAsync(atendimento.ServicoId);
        if (servico is null)
        {
            throw new DadosInvalidosException("Serviço não encontrado.");
        }

        var possuiContratoAtivo = await contratoRepository.PossuiContratoAtivoAsync(
            atendimento.ClienteId,
            servico.PlanoId,
            atendimento.Data);
        if (!possuiContratoAtivo)
        {
            throw new DadosInvalidosException(
                "O cliente não possui contrato ativo com o plano deste serviço na data do atendimento.");
        }

        return await base.SalvarAsync(atendimento);
    }
}
