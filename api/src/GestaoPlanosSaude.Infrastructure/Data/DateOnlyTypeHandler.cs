using System.Data;
using Dapper;

namespace GestaoPlanosSaude.Infrastructure.Data;

public sealed class DateOnlyTypeHandler : SqlMapper.TypeHandler<DateOnly>
{
    public override void SetValue(IDbDataParameter parameter, DateOnly value)
    {
        parameter.DbType = DbType.Date;
        parameter.Value = value.ToDateTime(TimeOnly.MinValue);
    }

    public override DateOnly Parse(object value)
    {
        if (value is DateOnly data)
        {
            return data;
        }

        return DateOnly.FromDateTime((DateTime)value);
    }
}
