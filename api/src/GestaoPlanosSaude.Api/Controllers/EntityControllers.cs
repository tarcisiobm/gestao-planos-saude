using GestaoPlanosSaude.Application.Common;
using GestaoPlanosSaude.Application.Services;
using GestaoPlanosSaude.Domain.Entities;
using GestaoPlanosSaude.Domain.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace GestaoPlanosSaude.Api.Controllers;

[Route("api/clientes")]
public sealed class ClientesController(ICrudService<Cliente> service)
    : CrudController<Cliente>(service)
{
}

[Route("api/planos")]
public sealed class PlanosController(ICrudService<Plano> service)
    : CrudController<Plano>(service)
{
}

[Route("api/prestadores")]
public sealed class PrestadoresController(ICrudService<Prestador> service)
    : CrudController<Prestador>(service)
{
}

[Route("api/dependentes")]
public sealed class DependentesController(ICrudService<Dependente> service)
    : CrudController<Dependente>(service)
{
}

[Route("api/contratos")]
public sealed class ContratosController(ICrudService<Contrato> service)
    : CrudController<Contrato>(service)
{
}

[Route("api/pagamentos")]
public sealed class PagamentosController(ICrudService<Pagamento> service)
    : CrudController<Pagamento>(service)
{
}

[Route("api/servicos")]
public sealed class ServicosController(
    ICrudService<Servico> service,
    IServicoRepository repository) : CrudController<Servico>(service)
{
    [HttpGet("por-plano/{planoId:int}")]
    public async Task<ActionResult<ResultWrapper<IReadOnlyList<Servico>>>> PorPlano(int planoId)
    {
        var servicos = await repository.ListarPorPlanoAsync(planoId);
        return Ok(ResultWrapper<IReadOnlyList<Servico>>.Ok(servicos));
    }
}

[Route("api/faixas-valor")]
public sealed class FaixasValorController(
    ICrudService<FaixaValor> service,
    IFaixaValorRepository repository) : CrudController<FaixaValor>(service)
{
    [HttpGet("por-plano/{planoId:int}")]
    public async Task<ActionResult<ResultWrapper<IReadOnlyList<FaixaValor>>>> PorPlano(int planoId)
    {
        var faixas = await repository.ListarPorPlanoAsync(planoId);
        return Ok(ResultWrapper<IReadOnlyList<FaixaValor>>.Ok(faixas));
    }

    [HttpGet("valor-por-idade")]
    public async Task<ActionResult<ResultWrapper<decimal>>> ValorPorIdade(
        [FromQuery] int planoId,
        [FromQuery] int idade)
    {
        var faixa = await repository.ObterPorIdadeAsync(planoId, idade);
        if (faixa is null)
        {
            return NotFound(ResultWrapper<decimal>.Fail("Nenhuma faixa cobre a idade informada."));
        }

        return Ok(ResultWrapper<decimal>.Ok(faixa.Valor));
    }
}

[Route("api/atendimentos")]
public sealed class AtendimentosController(
    ICrudService<Atendimento> service,
    IAtendimentoRepository repository) : CrudController<Atendimento>(service)
{
    [HttpGet("por-cliente/{clienteId:int}")]
    public async Task<ActionResult<ResultWrapper<IReadOnlyList<Atendimento>>>> PorCliente(int clienteId)
    {
        var atendimentos = await repository.ListarPorClienteAsync(clienteId);
        return Ok(ResultWrapper<IReadOnlyList<Atendimento>>.Ok(atendimentos));
    }
}
