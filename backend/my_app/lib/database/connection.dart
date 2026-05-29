
import 'package:postgres/postgres.dart';

late final Connection db;

Future<void> initDatabase() async{
  db = await Connection.open(
    Endpoint(
      host: 'aws-1-sa-east-1.pooler.supabase.com',
      port: 5432,
      database: 'postgres',
      username: 'postgres.bwdbptexoanuyrfpgxtz',
      password: '_Paulo001_VCK'
      ),
    settings: const ConnectionSettings(
      sslMode: SslMode.disable,
    )
  );

  print('Postgres conectado');
}
