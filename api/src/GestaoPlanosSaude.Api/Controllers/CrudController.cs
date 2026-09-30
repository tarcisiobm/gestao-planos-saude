using GestaoPlanosSaude.Application.Common;
using GestaoPlanosSaude.Application.Services;
using GestaoPlanosSaude.Domain.Entities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace GestaoPlanosSaude.Api.Controllers;

[ApiController]
[Authorize]
public abstract class CrudController<T>(ICrudService<T> service) : ControllerBase where T : class, IEntity
{
    [HttpGet]
    public async Task<ActionResult<ResultWrapper<IReadOnlyList<T>>>> Listar(
        [FromQuery] string? busca)
    {
        var registros = await service.ListarAsync(busca);
        return Ok(ResultWrapper<IReadOnlyList<T>>.Ok(registros));
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<ResultWrapper<T>>> Obter(int id)
    {
        var entidade = await service.ObterAsync(id);
        if (entidade is null)
        {
            return NotFound(ResultWrapper<T>.Fail("Registro não encontrado."));
        }

        return Ok(ResultWrapper<T>.Ok(entidade));
    }

    [HttpPost]
    public async Task<ActionResult<ResultWrapper<object>>> Criar(T entidade)
    {
        entidade.Id = 0;
        var id = await service.SalvarAsync(entidade);
        var resultado = ResultWrapper<object>.Ok(new { id }, "Registro criado com sucesso.");
        return StatusCode(StatusCodes.Status201Created, resultado);
    }

    [HttpPut("{id:int}")]
    public async Task<ActionResult<ResultWrapper<object>>> Atualizar(int id, T entidade)
    {
        entidade.Id = id;
        var salvo = await service.SalvarAsync(entidade);
        if (salvo == 0)
        {
            return NotFound(ResultWrapper<object>.Fail("Registro não encontrado."));
        }

        return Ok(ResultWrapper<object>.Ok(new { id }, "Registro atualizado com sucesso."));
    }

    [HttpDelete("{id:int}")]
    public async Task<ActionResult<ResultWrapper<object>>> Excluir(int id)
    {
        var excluido = await service.ExcluirAsync(id);
        if (!excluido)
        {
            return NotFound(ResultWrapper<object>.Fail("Registro não encontrado."));
        }

        return Ok(ResultWrapper<object>.Ok(new { id }, "Registro excluído com sucesso."));
    }
}
