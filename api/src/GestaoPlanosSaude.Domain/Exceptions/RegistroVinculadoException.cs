namespace GestaoPlanosSaude.Domain.Exceptions;

public sealed class RegistroVinculadoException()
    : Exception("O registro possui vínculos e não pode ser excluído.");
