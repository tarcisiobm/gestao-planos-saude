using System.Data.Common;
using MySqlConnector;

namespace GestaoPlanosSaude.Infrastructure.Data;

public interface IDbConnectionFactory
{
    DbConnection Criar();
}

public sealed class DbConnectionFactory(string connectionString) : IDbConnectionFactory
{
    public DbConnection Criar() => new MySqlConnection(connectionString);
}
