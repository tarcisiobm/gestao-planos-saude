namespace GestaoPlanosSaude.Domain.Exceptions;

public sealed class DadosInvalidosException(string message) : Exception(message);
