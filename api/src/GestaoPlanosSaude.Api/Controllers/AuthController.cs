using GestaoPlanosSaude.Application.Common;
using GestaoPlanosSaude.Application.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace GestaoPlanosSaude.Api.Controllers;

[ApiController]
[Route("api/auth")]
[AllowAnonymous]
public sealed class AuthController(AuthService service) : ControllerBase
{
    [HttpPost("login")]
    public async Task<ActionResult<ResultWrapper<UsuarioAutenticado>>> Login(LoginRequest request)
    {
        var usuario = await service.AutenticarAsync(request);
        if (usuario is null)
        {
            return Unauthorized(ResultWrapper<UsuarioAutenticado>.Fail("E-mail ou senha inválidos."));
        }

        return Ok(ResultWrapper<UsuarioAutenticado>.Ok(usuario, "Login realizado com sucesso."));
    }

    [HttpPost("cadastro")]
    public async Task<ActionResult<ResultWrapper<object>>> Cadastro(CadastroUsuarioRequest request)
    {
        var emailNaoInformado = string.IsNullOrWhiteSpace(request.Email);
        var senhaInvalida = string.IsNullOrWhiteSpace(request.Senha) || request.Senha.Length < 6;
        if (emailNaoInformado || senhaInvalida)
        {
            return BadRequest(ResultWrapper<object>.Fail(
                "Dados inválidos.",
                "Informe um e-mail e uma senha com pelo menos 6 caracteres."));
        }

        var id = await service.CadastrarAsync(request);
        if (id == 0)
        {
            return Conflict(ResultWrapper<object>.Fail("Já existe um usuário com este e-mail."));
        }

        return StatusCode(201, ResultWrapper<object>.Ok(new { id }, "Usuário cadastrado com sucesso."));
    }
}
