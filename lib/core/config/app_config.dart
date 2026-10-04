/// Client configuration. The anon/publishable key is safe in the app binary;
/// never ship the service_role key.
class AppConfig {
  const AppConfig._();

  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://gmrqsgxjmtxccxctcttf.supabase.co',
  );

  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  /// When true and the user has no BPM history yet, Progress shows seeded
  /// demo samples so chart layout can be reviewed.
  static const showSeededBpmTrend = bool.fromEnvironment(
    'SHOW_SEEDED_BPM_TREND',
    defaultValue: true,
  );

  static bool get hasSupabaseConfig =>
      supabaseUrl.contains('supabase.co') &&
      !supabaseUrl.contains('your-supabase-url') &&
      supabaseAnonKey.isNotEmpty &&
      supabaseAnonKey != 'your-anon-key';
}
