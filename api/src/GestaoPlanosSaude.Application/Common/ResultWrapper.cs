namespace GestaoPlanosSaude.Application.Common;

public sealed record ResultWrapper<T>(bool Success, string Message, T? Data, IReadOnlyList<string> Errors)
{
    public static ResultWrapper<T> Ok(
        T data,
        string message = "Operação realizada com sucesso.")
    {
        return new(true, message, data, []);
    }

    public static ResultWrapper<T> Fail(string message, params string[] errors)
    {
        return new(false, message, default, errors);
    }
}
