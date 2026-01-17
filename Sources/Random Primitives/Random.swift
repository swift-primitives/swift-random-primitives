// Random.swift
// Namespace for random number generation types.

/// Cryptographically-secure random number generation.
///
/// Provides a cross-platform API for obtaining random bytes from
/// the operating system's CSPRNG.
///
/// ## Platform Implementation
///
/// The `fill(_:)` function is provided by platform-specific packages:
/// - **Darwin**: `swift-darwin` using `arc4random_buf`
/// - **Linux**: `swift-linux` using `getrandom(2)`
/// - **Windows**: `swift-windows` using `BCryptGenRandom`
///
/// ## Example
///
/// ```swift
/// import Random
///
/// // Fill a buffer with random bytes
/// var bytes = [UInt8](repeating: 0, count: 32)
/// try bytes.withUnsafeMutableBytes { buffer in
///     try Random.fill(buffer)
/// }
///
/// // Or use the convenience method
/// let key = try Random.bytes(count: 32)
/// ```
public enum Random {}
