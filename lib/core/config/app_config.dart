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
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdtcnFzZ3hqbXR4Y2N4Y3RjdHRmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTEwOTM4ODYsImV4cCI6MjEwNjY2OTg4Nn0.9QbZTpL_e5JKOth-MMieSJ_6PNzcIkHJbBvHFgWZVxg',
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
