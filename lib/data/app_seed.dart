import 'package:mysql_client_plus/mysql_client_plus.dart';

import '../domain/constants/status.dart';

class AppSeed {
  static Future<void> popularExemplos(MySQLConnectionPool db) async {
    final total = await db.execute('SELECT COUNT(*) AS total FROM cliente');
    final clientes = total.rows.first.typedColByName<int>('total') ?? 0;
    if (clientes > 0) return;

    await db.transactional((connection) async {
      await _insertAll(connection, 'cliente', [
        {
          'nome': 'Ana Souza',
          'cpf': '123.456.789-01',
          'telefone': '(32) 98888-1001',
          'email': 'ana.souza@email.com',
          'endereco': 'Rua das Flores, 120',
        },
        {
          'nome': 'Bruno Lima',
          'cpf': '234.567.890-12',
          'telefone': '(32) 98888-1002',
          'email': 'bruno.lima@email.com',
          'endereco': 'Av. Brasil, 455',
        },
        {
          'nome': 'Carla Mendes',
          'cpf': '345.678.901-23',
          'telefone': '(32) 98888-1003',
          'email': 'carla.mendes@email.com',
          'endereco': 'Rua Santa Rita, 87',
        },
        {
          'nome': 'Daniel Rocha',
          'cpf': '456.789.012-34',
          'telefone': '(32) 98888-1004',
          'email': 'daniel.rocha@email.com',
          'endereco': 'Rua XV de Novembro, 300',
        },
        {
          'nome': 'Elisa Martins',
          'cpf': '567.890.123-45',
          'telefone': '(32) 98888-1005',
          'email': 'elisa.martins@email.com',
          'endereco': 'Rua Tiradentes, 51',
        },
        {
          'nome': 'Felipe Costa',
          'cpf': '678.901.234-56',
          'telefone': '(32) 98888-1006',
          'email': 'felipe.costa@email.com',
          'endereco': 'Av. Rio Branco, 710',
        },
        {
          'nome': 'Gabriela Alves',
          'cpf': '789.012.345-67',
          'telefone': '(32) 98888-1007',
          'email': 'gabriela.alves@email.com',
          'endereco': 'Rua Halfeld, 45',
        },
        {
          'nome': 'Henrique Dias',
          'cpf': '890.123.456-78',
          'telefone': '(32) 98888-1008',
          'email': 'henrique.dias@email.com',
          'endereco': 'Rua Batista de Oliveira, 99',
        },
        {
          'nome': 'Isabela Nunes',
          'cpf': '901.234.567-89',
          'telefone': '(32) 98888-1009',
          'email': 'isabela.nunes@email.com',
          'endereco': 'Rua Marechal Deodoro, 180',
        },
        {
          'nome': 'Joao Pereira',
          'cpf': '012.345.678-90',
          'telefone': '(32) 98888-1010',
          'email': 'joao.pereira@email.com',
          'endereco': 'Rua Sao Mateus, 640',
        },
      ]);

      await _insertAll(connection, 'plano', [
        {
          'nome': 'Vida Essencial',
          'tipo_cobertura': 'Basica',
          'valor': 189.90,
          'valor_dependente': 60.00,
          'vigencia': '12 meses',
          'forma_pagamento': 'Boleto',
        },
        {
          'nome': 'Vida Familiar',
          'tipo_cobertura': 'Intermediaria',
          'valor': 289.90,
          'valor_dependente': 90.00,
          'vigencia': '12 meses',
          'forma_pagamento': 'Cartao',
        },
        {
          'nome': 'Vida Premium',
          'tipo_cobertura': 'Completa',
          'valor': 449.90,
          'valor_dependente': 140.00,
          'vigencia': '12 meses',
          'forma_pagamento': 'Cartao',
        },
        {
          'nome': 'Saude Jovem',
          'tipo_cobertura': 'Basica',
          'valor': 159.90,
          'valor_dependente': 50.00,
          'vigencia': '6 meses',
          'forma_pagamento': 'Pix',
        },
        {
          'nome': 'Saude Senior',
          'tipo_cobertura': 'Completa',
          'valor': 599.90,
          'valor_dependente': 200.00,
          'vigencia': '12 meses',
          'forma_pagamento': 'Boleto',
        },
        {
          'nome': 'Odonto Plus',
          'tipo_cobertura': 'Odontologica',
          'valor': 79.90,
          'valor_dependente': 25.00,
          'vigencia': '12 meses',
          'forma_pagamento': 'Cartao',
        },
        {
          'nome': 'Empresarial Start',
          'tipo_cobertura': 'Intermediaria',
          'valor': 249.90,
          'valor_dependente': 80.00,
          'vigencia': '24 meses',
          'forma_pagamento': 'Boleto',
        },
        {
          'nome': 'Empresarial Total',
          'tipo_cobertura': 'Completa',
          'valor': 529.90,
          'valor_dependente': 170.00,
          'vigencia': '24 meses',
          'forma_pagamento': 'Transferencia',
        },
        {
          'nome': 'Regional Minas',
          'tipo_cobertura': 'Intermediaria',
          'valor': 219.90,
          'valor_dependente': 70.00,
          'vigencia': '12 meses',
          'forma_pagamento': 'Pix',
        },
        {
          'nome': 'Nacional Total',
          'tipo_cobertura': 'Completa',
          'valor': 699.90,
          'valor_dependente': 230.00,
          'vigencia': '12 meses',
          'forma_pagamento': 'Cartao',
        },
      ]);

      await _insertAll(connection, 'prestador', [
        {
          'nome': 'Hospital Santa Clara',
          'tipo': 'Hospital',
          'especialidade': 'Pronto atendimento',
          'localizacao': 'Juiz de Fora',
        },
        {
          'nome': 'Clinica Vida',
          'tipo': 'Clinica',
          'especialidade': 'Clinica geral',
          'localizacao': 'Juiz de Fora',
        },
        {
          'nome': 'Laboratorio Analise',
          'tipo': 'Laboratorio',
          'especialidade': 'Exames laboratoriais',
          'localizacao': 'Juiz de Fora',
        },
        {
          'nome': 'Centro Cardiologico Minas',
          'tipo': 'Clinica',
          'especialidade': 'Cardiologia',
          'localizacao': 'Belo Horizonte',
        },
        {
          'nome': 'Hospital Sao Lucas',
          'tipo': 'Hospital',
          'especialidade': 'Ortopedia',
          'localizacao': 'Barbacena',
        },
        {
          'nome': 'Clinica Bem Estar',
          'tipo': 'Clinica',
          'especialidade': 'Pediatria',
          'localizacao': 'Uba',
        },
        {
          'nome': 'Imagem Center',
          'tipo': 'Clinica',
          'especialidade': 'Diagnostico por imagem',
          'localizacao': 'Juiz de Fora',
        },
        {
          'nome': 'Odonto Prime',
          'tipo': 'Clinica',
          'especialidade': 'Odontologia',
          'localizacao': 'Juiz de Fora',
        },
        {
          'nome': 'Laboratorio Central',
          'tipo': 'Laboratorio',
          'especialidade': 'Analises clinicas',
          'localizacao': 'Belo Horizonte',
        },
        {
          'nome': 'Hospital Regional',
          'tipo': 'Hospital',
          'especialidade': 'Internacao',
          'localizacao': 'Leopoldina',
        },
      ]);

      await _insertAll(connection, 'dependente', [
        {
          'cliente_id': 1,
          'nome': 'Lucas Souza',
          'cpf': '111.222.333-01',
          'parentesco': 'Filho(a)',
        },
        {
          'cliente_id': 2,
          'nome': 'Mariana Lima',
          'cpf': '111.222.333-02',
          'parentesco': 'Conjuge',
        },
        {
          'cliente_id': 3,
          'nome': 'Pedro Mendes',
          'cpf': '111.222.333-03',
          'parentesco': 'Filho(a)',
        },
        {
          'cliente_id': 4,
          'nome': 'Laura Rocha',
          'cpf': '111.222.333-04',
          'parentesco': 'Filho(a)',
        },
        {
          'cliente_id': 5,
          'nome': 'Roberto Martins',
          'cpf': '111.222.333-05',
          'parentesco': 'Pai/Mae',
        },
        {
          'cliente_id': 6,
          'nome': 'Camila Costa',
          'cpf': '111.222.333-06',
          'parentesco': 'Conjuge',
        },
        {
          'cliente_id': 7,
          'nome': 'Rafael Alves',
          'cpf': '111.222.333-07',
          'parentesco': 'Filho(a)',
        },
        {
          'cliente_id': 8,
          'nome': 'Beatriz Dias',
          'cpf': '111.222.333-08',
          'parentesco': 'Filho(a)',
        },
        {
          'cliente_id': 9,
          'nome': 'Sergio Nunes',
          'cpf': '111.222.333-09',
          'parentesco': 'Pai/Mae',
        },
        {
          'cliente_id': 10,
          'nome': 'Patricia Pereira',
          'cpf': '111.222.333-10',
          'parentesco': 'Conjuge',
        },
      ]);

      await _insertAll(connection, 'contrato', [
        {
          'cliente_id': 1,
          'plano_id': 1,
          'data_inicio': '01/01/2026',
          'validade': '12 meses',
          'status': StatusContrato.ativo,
          'renovacao_automatica': 1,
        },
        {
          'cliente_id': 1,
          'plano_id': 3,
          'data_inicio': '12/01/2026',
          'validade': '12 meses',
          'status': StatusContrato.ativo,
          'renovacao_automatica': 0,
        },
        {
          'cliente_id': 2,
          'plano_id': 2,
          'data_inicio': '05/01/2026',
          'validade': '12 meses',
          'status': StatusContrato.ativo,
          'renovacao_automatica': 1,
        },
        {
          'cliente_id': 3,
          'plano_id': 3,
          'data_inicio': '10/01/2026',
          'validade': '12 meses',
          'status': StatusContrato.ativo,
          'renovacao_automatica': 0,
        },
        {
          'cliente_id': 4,
          'plano_id': 4,
          'data_inicio': '15/01/2026',
          'validade': '6 meses',
          'status': StatusContrato.vencido,
          'renovacao_automatica': 0,
        },
        {
          'cliente_id': 5,
          'plano_id': 5,
          'data_inicio': '20/01/2026',
          'validade': '12 meses',
          'status': StatusContrato.ativo,
          'renovacao_automatica': 1,
        },
        {
          'cliente_id': 6,
          'plano_id': 6,
          'data_inicio': '25/01/2026',
          'validade': '12 meses',
          'status': StatusContrato.ativo,
          'renovacao_automatica': 0,
        },
        {
          'cliente_id': 7,
          'plano_id': 7,
          'data_inicio': '01/02/2026',
          'validade': '24 meses',
          'status': StatusContrato.ativo,
          'renovacao_automatica': 1,
        },
        {
          'cliente_id': 8,
          'plano_id': 8,
          'data_inicio': '05/02/2026',
          'validade': '24 meses',
          'status': StatusContrato.ativo,
          'renovacao_automatica': 1,
        },
        {
          'cliente_id': 9,
          'plano_id': 9,
          'data_inicio': '10/02/2026',
          'validade': '12 meses',
          'status': StatusContrato.vencido,
          'renovacao_automatica': 0,
        },
        {
          'cliente_id': 10,
          'plano_id': 10,
          'data_inicio': '15/02/2026',
          'validade': '12 meses',
          'status': StatusContrato.ativo,
          'renovacao_automatica': 1,
        },
      ]);

      await _insertAll(connection, 'pagamento', [
        {
          'cliente_id': 1,
          'valor': 189.90,
          'vencimento': '10/01/2026',
          'status': StatusPagamento.pago,
        },
        {
          'cliente_id': 2,
          'valor': 289.90,
          'vencimento': '10/01/2026',
          'status': StatusPagamento.pendente,
        },
        {
          'cliente_id': 3,
          'valor': 449.90,
          'vencimento': '10/01/2026',
          'status': StatusPagamento.pago,
        },
        {
          'cliente_id': 4,
          'valor': 159.90,
          'vencimento': '10/01/2026',
          'status': StatusPagamento.atrasado,
        },
        {
          'cliente_id': 5,
          'valor': 599.90,
          'vencimento': '10/02/2026',
          'status': StatusPagamento.pendente,
        },
        {
          'cliente_id': 6,
          'valor': 79.90,
          'vencimento': '10/02/2026',
          'status': StatusPagamento.pago,
        },
        {
          'cliente_id': 7,
          'valor': 249.90,
          'vencimento': '10/02/2026',
          'status': StatusPagamento.pago,
        },
        {
          'cliente_id': 8,
          'valor': 529.90,
          'vencimento': '10/03/2026',
          'status': StatusPagamento.pendente,
        },
        {
          'cliente_id': 9,
          'valor': 219.90,
          'vencimento': '10/03/2026',
          'status': StatusPagamento.atrasado,
        },
        {
          'cliente_id': 10,
          'valor': 699.90,
          'vencimento': '10/03/2026',
          'status': StatusPagamento.pago,
        },
      ]);

      await _insertAll(connection, 'servico', [
        {'plano_id': 1, 'prestador_id': 1, 'nome': 'Consulta clinica'},
        {'plano_id': 1, 'prestador_id': 2, 'nome': 'Pronto atendimento'},
        {'plano_id': 2, 'prestador_id': 3, 'nome': 'Exames laboratoriais'},
        {'plano_id': 2, 'prestador_id': 6, 'nome': 'Pediatria'},
        {'plano_id': 3, 'prestador_id': 4, 'nome': 'Cardiologia'},
        {'plano_id': 3, 'prestador_id': 7, 'nome': 'Diagnostico por imagem'},
        {'plano_id': 4, 'prestador_id': 2, 'nome': 'Consulta ambulatorial'},
        {'plano_id': 5, 'prestador_id': 5, 'nome': 'Ortopedia'},
        {'plano_id': 5, 'prestador_id': 10, 'nome': 'Internacao'},
        {'plano_id': 6, 'prestador_id': 8, 'nome': 'Odontologia'},
        {'plano_id': 7, 'prestador_id': 6, 'nome': 'Clinica geral'},
        {'plano_id': 8, 'prestador_id': 7, 'nome': 'Tomografia'},
        {'plano_id': 9, 'prestador_id': 9, 'nome': 'Check-up laboratorial'},
        {'plano_id': 10, 'prestador_id': 1, 'nome': 'Cirurgia geral'},
        {'plano_id': 10, 'prestador_id': 4, 'nome': 'Acompanhamento cardiaco'},
      ]);

      await _insertAll(connection, 'faixa_valor', [
        for (var planoId = 1; planoId <= 10; planoId++) ...[
          {
            'plano_id': planoId,
            'idade_min': 0,
            'idade_max': 18,
            'valor': 100.00,
          },
          {
            'plano_id': planoId,
            'idade_min': 19,
            'idade_max': 59,
            'valor': 200.00,
          },
          {
            'plano_id': planoId,
            'idade_min': 60,
            'idade_max': 999,
            'valor': 300.00,
          },
        ],
      ]);

      await _insertAll(connection, 'atendimento', [
        {
          'cliente_id': 1,
          'servico_id': 1,
          'data': '12/01/2026',
          'horario': '09:30',
          'descricao': 'Consulta de rotina',
        },
        {
          'cliente_id': 2,
          'servico_id': 3,
          'data': '18/01/2026',
          'horario': '14:00',
          'descricao': 'Exames de sangue',
        },
        {
          'cliente_id': 3,
          'servico_id': 5,
          'data': '22/01/2026',
          'horario': '10:15',
          'descricao': 'Avaliacao cardiologica',
        },
        {
          'cliente_id': 4,
          'servico_id': 7,
          'data': '03/02/2026',
          'horario': '16:20',
          'descricao': 'Consulta ambulatorial',
        },
        {
          'cliente_id': 5,
          'servico_id': 9,
          'data': '08/02/2026',
          'horario': '08:45',
          'descricao': 'Internacao de observacao',
        },
        {
          'cliente_id': 6,
          'servico_id': 10,
          'data': '11/02/2026',
          'horario': '13:30',
          'descricao': 'Limpeza odontologica',
        },
        {
          'cliente_id': 7,
          'servico_id': 11,
          'data': '17/02/2026',
          'horario': '11:00',
          'descricao': 'Consulta clinica geral',
        },
        {
          'cliente_id': 8,
          'servico_id': 12,
          'data': '21/02/2026',
          'horario': '15:10',
          'descricao': 'Tomografia solicitada pelo medico',
        },
        {
          'cliente_id': 9,
          'servico_id': 13,
          'data': '25/02/2026',
          'horario': '07:50',
          'descricao': 'Check-up anual',
        },
        {
          'cliente_id': 10,
          'servico_id': 14,
          'data': '02/03/2026',
          'horario': '12:30',
          'descricao': 'Cirurgia eletiva',
        },
      ]);

      await _insertAll(connection, 'usuario', [
        {'nome': 'Administrador', 'email': 'admin@email.com', 'senha': '123'},
      ]);
    });
  }

  static Future<void> _insertAll(
    MySQLConnection connection,
    String table,
    List<Map<String, Object?>> rows,
  ) async {
    for (final row in rows) {
      final columns = row.keys.join(', ');
      final values = row.keys.map((column) => ':$column').join(', ');
      await connection.execute(
        'INSERT INTO $table ($columns) VALUES ($values)',
        row,
      );
    }
  }
}
