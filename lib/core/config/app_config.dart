/// Client configuration.
///
/// Pass secrets at build/run time via `--dart-define-from-file=dart_defines.json`
/// (see `.env.example`). Never commit real keys; never ship the service_role /
/// `sb_secret_*` key in the app binary.
class AppConfig {
  const AppConfig._();

  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://gmrqsgxjmtxccxctcttf.supabase.co',
  );

  /// Publishable key (`sb_publishable_...`). Legacy JWT anon keys are disabled.
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

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
      supabaseAnonKey != 'your-anon-key' &&
      !supabaseAnonKey.contains('REPLACE_ME') &&
      // Legacy JWT anon keys are disabled on this project.
      !supabaseAnonKey.startsWith('eyJ');
}
