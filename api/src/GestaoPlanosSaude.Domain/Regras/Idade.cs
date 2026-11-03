namespace GestaoPlanosSaude.Domain.Regras;

public static class Idade
{
    public static int Calcular(DateOnly dataNascimento, DateOnly dataReferencia)
    {
        var idade = dataReferencia.Year - dataNascimento.Year;
        var aniversarioNoAno = dataNascimento.AddYears(idade);
        if (aniversarioNoAno > dataReferencia)
        {
            idade--;
        }

        return idade;
    }
}
