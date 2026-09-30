using GestaoPlanosSaude.Application.Common;
using GestaoPlanosSaude.Application.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace GestaoPlanosSaude.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/simulacoes")]
public sealed class SimulacaoController(SimulacaoService service) : ControllerBase
{
    [HttpPost]
    public async Task<ActionResult<ResultWrapper<SimulacaoResultado>>> Simular(SimulacaoRequest request)
    {
        var resultado = await service.SimularAsync(request.PlanoId, request.Idade, request.QuantidadeDependentes);
        if (resultado is null)
        {
            return BadRequest(ResultWrapper<SimulacaoResultado>.Fail(
                "Não foi possível realizar a simulação.",
                "Verifique plano, idade e quantidade de dependentes."));
        }

        return Ok(ResultWrapper<SimulacaoResultado>.Ok(resultado));
    }
}

public sealed record SimulacaoRequest(int PlanoId, int Idade, int QuantidadeDependentes);
