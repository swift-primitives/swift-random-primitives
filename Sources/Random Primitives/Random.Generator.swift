// Random.Generator.swift
// Protocol for cryptographically-secure random byte generators.

extension Random {
    /// A cryptographically-secure random byte generator.
    ///
    /// Types conforming to this protocol provide cryptographically-secure
    /// pseudo-random bytes suitable for security-sensitive operations like
    /// key generation, nonces, and UUIDs.
    ///
    /// The primary implementation is `Random.fill(_:)` provided by platform
    /// packages (swift-darwin, swift-linux, swift-windows). This protocol
    /// exists for testing and custom generator implementations.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Using the platform's CSPRNG (most common)
    /// try Random.fill(buffer)
    ///
    /// // Using a custom generator
    /// var generator = MyTestGenerator()
    /// try generator.fill(buffer)
    /// ```
    public protocol Generator: Sendable {
        /// Fills the buffer with cryptographically-secure random bytes.
        ///
        /// The entire buffer is filled with random data. If the operation
        /// fails partway through, the buffer contents are undefined.
        ///
        /// - Parameter buffer: The buffer to fill with random bytes.
        ///   If the buffer is empty, this method returns immediately.
        /// - Throws: `Random.Error` if random bytes cannot be generated.
        mutating func fill(_ buffer: UnsafeMutableRawBufferPointer) throws(Random.Error)
    }
}
