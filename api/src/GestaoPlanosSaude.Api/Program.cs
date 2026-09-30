using System.Text;
using System.Text.Json;
using Dapper;
using GestaoPlanosSaude.Api.Services;
using GestaoPlanosSaude.Api.Middleware;
using GestaoPlanosSaude.Application.Common;
using GestaoPlanosSaude.Application.Services;
using GestaoPlanosSaude.Domain.Entities;
using GestaoPlanosSaude.Domain.Repositories;
using GestaoPlanosSaude.Infrastructure.Data;
using GestaoPlanosSaude.Infrastructure.Repositories;
using GestaoPlanosSaude.Infrastructure.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Microsoft.AspNetCore.Mvc;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);
DefaultTypeMap.MatchNamesWithUnderscores = true;

builder.Services
    .AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower;
    });
builder.Services.Configure<ApiBehaviorOptions>(options =>
{
    options.InvalidModelStateResponseFactory = context =>
    {
        var errors = context.ModelState.Values
            .SelectMany(value => value.Errors)
            .Select(error => error.ErrorMessage)
            .ToArray();
        return new BadRequestObjectResult(ResultWrapper<object>.Fail("Dados inválidos.", errors));
    };
});
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        Scheme = "bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "Informe o token JWT obtido no login."
    });
    options.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        [new OpenApiSecurityScheme
        {
            Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "Bearer" }
        }] = Array.Empty<string>()
    });
});
builder.Services.AddMemoryCache();

var connectionString = builder.Configuration.GetConnectionString("MySql");
if (string.IsNullOrWhiteSpace(connectionString))
{
    throw new InvalidOperationException("Connection string MySql não configurada.");
}
builder.Services.AddSingleton<IDbConnectionFactory>(new DbConnectionFactory(connectionString));
builder.Services.AddScoped<IRepository<Cliente>, ClienteRepository>();
builder.Services.AddScoped<IRepository<Plano>, PlanoRepository>();
builder.Services.AddScoped<IRepository<Prestador>, PrestadorRepository>();
builder.Services.AddScoped<IRepository<Dependente>, DependenteRepository>();
builder.Services.AddScoped<IRepository<Contrato>, ContratoRepository>();
builder.Services.AddScoped<IRepository<Pagamento>, PagamentoRepository>();
builder.Services.AddScoped<IRepository<Servico>, ServicoRepository>();
builder.Services.AddScoped<IRepository<FaixaValor>, FaixaValorRepository>();
builder.Services.AddScoped<IRepository<Atendimento>, AtendimentoRepository>();
builder.Services.AddScoped<IServicoRepository, ServicoRepository>();
builder.Services.AddScoped<IFaixaValorRepository, FaixaValorRepository>();
builder.Services.AddScoped<IAtendimentoRepository, AtendimentoRepository>();
builder.Services.AddScoped<IUsuarioRepository, UsuarioRepository>();
builder.Services.AddScoped(typeof(ICrudService<>), typeof(CrudService<>));
builder.Services.AddScoped<ICrudService<Plano>, CachedPlanoService>();
builder.Services.AddScoped<IPasswordHasher, PasswordHasher>();
builder.Services.AddScoped<ITokenService, JwtTokenService>();
builder.Services.AddScoped<AuthService>();
builder.Services.AddScoped<SimulacaoService>();

var jwtKey = builder.Configuration["Jwt:Key"];
if (string.IsNullOrWhiteSpace(jwtKey) || jwtKey.Length < 32)
{
    throw new InvalidOperationException("Configure uma chave JWT com pelo menos 32 caracteres.");
}

builder.Services
    .AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["Jwt:Issuer"],
            ValidAudience = builder.Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey)),
            ClockSkew = TimeSpan.Zero
        };
        options.Events = new JwtBearerEvents
        {
            OnChallenge = async context =>
            {
                context.HandleResponse();
                context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                var resultado = ResultWrapper<object>.Fail(
                    "Autenticação necessária.",
                    "Informe um token JWT válido.");
                await context.Response.WriteAsJsonAsync(resultado);
            }
        };
    });
builder.Services.AddAuthorization();

var app = builder.Build();
app.UseMiddleware<ErrorHandlingMiddleware>();
app.UseSwagger();
app.UseSwaggerUI();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
app.Run();
