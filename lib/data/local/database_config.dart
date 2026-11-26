/// SQLite database configuration prepared for Module 2 (sqflite).
/// Keeping schema metadata centralized ensures clean migrations in future
/// cloud-sync phases.
class DatabaseConfig {
  const DatabaseConfig._();

  static const String databaseFileName = 'hunardaily_local.db';
  static const int schemaVersion = 1;
}
