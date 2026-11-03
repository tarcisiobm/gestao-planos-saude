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
    public async Task<ActionResult<ResultWrapper<Mensalidade>>> Simular(SimulacaoRequest request)
    {
        var resultado = await service.SimularAsync(
            request.PlanoId,
            request.IdadeTitular,
            request.IdadesDependentes);
        return Ok(ResultWrapper<Mensalidade>.Ok(resultado));
    }
}

public sealed record SimulacaoRequest(int PlanoId, int IdadeTitular, List<int> IdadesDependentes);
