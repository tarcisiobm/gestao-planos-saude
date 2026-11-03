using GestaoPlanosSaude.Domain.Entities;
using GestaoPlanosSaude.Domain.Exceptions;
using GestaoPlanosSaude.Domain.Repositories;

namespace GestaoPlanosSaude.Application.Services;

public sealed class AtendimentoService(
    IAtendimentoRepository atendimentoRepository,
    IServicoRepository servicoRepository,
    IContratoRepository contratoRepository,
    IDependenteRepository dependenteRepository) : CrudService<Atendimento>(atendimentoRepository)
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

        if (atendimento.DependenteId is not null)
        {
            var dependente = await dependenteRepository.ObterAsync(atendimento.DependenteId.Value);
            if (dependente is null || dependente.ClienteId != atendimento.ClienteId)
            {
                throw new DadosInvalidosException("O dependente não pertence ao cliente informado.");
            }
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
