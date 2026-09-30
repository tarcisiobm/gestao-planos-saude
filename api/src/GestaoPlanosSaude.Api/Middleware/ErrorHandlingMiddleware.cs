using GestaoPlanosSaude.Application.Common;

namespace GestaoPlanosSaude.Api.Middleware;

public sealed class ErrorHandlingMiddleware(RequestDelegate next, ILogger<ErrorHandlingMiddleware> logger)
{
    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await next(context);
        }
        catch (Exception exception)
        {
            logger.LogError(
                exception,
                "Erro não tratado ao processar {Method} {Path}",
                context.Request.Method,
                context.Request.Path);
            context.Response.StatusCode = StatusCodes.Status500InternalServerError;
            var resultado = ResultWrapper<object>.Fail(
                "Não foi possível concluir a operação.",
                "Ocorreu um erro interno na API.");
            await context.Response.WriteAsJsonAsync(resultado);
        }
    }
}
