/// Central feature switches designed so cloud sync, accounts, Admin CMS,
/// policy-reviewed ads, and subscriptions can be enabled in later phases
/// without rewriting UI or domain logic.
class AppFeatureFlags {
  const AppFeatureFlags._();

  /// v1 runs 100% offline in Guest Mode with zero cloud cost.
  static const bool enableCloudSync = false;
  static const bool enableUserAccounts = false;
  static const bool enableRemoteAdminCms = false;
  static const bool enableAds = false;
  static const bool enableSubscriptions = false;
}
