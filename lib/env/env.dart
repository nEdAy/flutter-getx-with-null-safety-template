/// Represents a single environment configuration.
class Env {
  /// The name of the environment (e.g., "production", "staging").
  final String name;

  /// The configuration settings for this environment.
  final Map<String, dynamic> config;

  /// Creates an environment with the given [name] and [config].
  Env(this.name, this.config);

  /// Converts the environment to a JSON-compatible map.
  Map<String, dynamic> toJson() => {'name': name, 'config': config};

  /// Creates an environment instance from JSON data.
  factory Env.fromJson(String name, Map<String, dynamic> json) {
    return Env(name, json['config']);
  }
}
