import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysql_client_plus/mysql_client_plus.dart';

import 'app_seed.dart';

class AppDatabase {
  static late MySQLConnectionPool db;

  static Future<void> init() async {
    db = MySQLConnectionPool(
      host: AppDatabaseConfig.host,
      port: AppDatabaseConfig.port,
      userName: AppDatabaseConfig.user,
      password: AppDatabaseConfig.password,
      databaseName: AppDatabaseConfig.database,
      maxConnections: AppDatabaseConfig.maxConnections,
      secure: AppDatabaseConfig.secure,
    );

    await _criarTabelas();
    await AppSeed.popularExemplos(db);
  }

  static Future<void> _criarTabelas() async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cliente(
        id INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(120) NOT NULL,
        cpf VARCHAR(14) NOT NULL,
        telefone VARCHAR(20),
        email VARCHAR(120),
        endereco VARCHAR(200))
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS plano(
        id INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(120) NOT NULL,
        tipo_cobertura VARCHAR(80),
        valor DECIMAL(10,2) NOT NULL,
        valor_dependente DECIMAL(10,2) NOT NULL DEFAULT 0,
        vigencia VARCHAR(40),
        forma_pagamento VARCHAR(40))
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS prestador(
        id INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(120) NOT NULL,
        tipo VARCHAR(40),
        especialidade VARCHAR(80),
        localizacao VARCHAR(200))
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS dependente(
        id INT AUTO_INCREMENT PRIMARY KEY,
        cliente_id INT NOT NULL,
        nome VARCHAR(120) NOT NULL,
        cpf VARCHAR(14),
        parentesco VARCHAR(40),
        FOREIGN KEY (cliente_id) REFERENCES cliente(id))
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS contrato(
        id INT AUTO_INCREMENT PRIMARY KEY,
        cliente_id INT NOT NULL,
        plano_id INT NOT NULL,
        data_inicio VARCHAR(20),
        validade VARCHAR(40),
        status VARCHAR(20),
        renovacao_automatica TINYINT DEFAULT 0,
        FOREIGN KEY (cliente_id) REFERENCES cliente(id),
        FOREIGN KEY (plano_id) REFERENCES plano(id))
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS pagamento(
        id INT AUTO_INCREMENT PRIMARY KEY,
        cliente_id INT NOT NULL,
        valor DECIMAL(10,2) NOT NULL,
        vencimento VARCHAR(20),
        status VARCHAR(20),
        FOREIGN KEY (cliente_id) REFERENCES cliente(id))
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS cobertura(
        id INT AUTO_INCREMENT PRIMARY KEY,
        plano_id INT NOT NULL,
        prestador_id INT NOT NULL,
        FOREIGN KEY (plano_id) REFERENCES plano(id),
        FOREIGN KEY (prestador_id) REFERENCES prestador(id))
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS usuario(
        id INT AUTO_INCREMENT PRIMARY KEY,
        nome VARCHAR(120),
        email VARCHAR(120) NOT NULL,
        senha VARCHAR(120) NOT NULL)
    ''');
  }
}

class AppDatabaseConfig {
  static String get host => dotenv.env['DB_HOST'] ?? '127.0.0.1';

  static int get port => int.tryParse(dotenv.env['DB_PORT'] ?? '') ?? 3306;

  static String get user => dotenv.env['DB_USER'] ?? 'root';

  static String get password => dotenv.env['DB_PASSWORD'] ?? '';

  static String get database => dotenv.env['DB_NAME'] ?? 'gestao_planos';

  static const int maxConnections = 5;

  static bool get secure => dotenv.env['DB_SECURE']?.toLowerCase() == 'true';
}
