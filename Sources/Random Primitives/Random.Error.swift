// Random.Error.swift
// Errors that can occur during random byte generation.

extension Random {
    /// Errors that can occur during random byte generation.
    ///
    /// Most platforms provide infallible random number generation, but some
    /// edge cases can cause failures:
    /// - Linux's `getrandom(2)` may return `EAGAIN` immediately after boot
    ///   before the entropy pool is initialized
    /// - System calls may fail with platform-specific error codes
    public enum Error: Swift.Error, Sendable, Hashable {
        /// The entropy pool is not ready.
        ///
        /// This occurs on Linux when `getrandom(2)` is called with the
        /// default flags before the kernel's entropy pool has been initialized.
        /// This typically only happens immediately after system boot.
        ///
        /// Callers can either:
        /// - Retry after a short delay
        /// - Use blocking mode (not recommended for most applications)
        case entropyNotReady

        /// A platform-specific system error occurred.
        ///
        /// The associated value is the platform's error code:
        /// - POSIX: `errno` value
        /// - Windows: `NTSTATUS` or `GetLastError()` value
        case systemError(Int32)
    }
}
