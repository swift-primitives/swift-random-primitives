# Random Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

The shared abstraction for cryptographically-secure random byte generation in Swift — a `Random.Generator` protocol and a typed `Random.Error`, with zero platform dependencies.

---

## Quick Start

`Random` is the ecosystem's vocabulary for cryptographically-secure randomness. It defines the `Random.Generator` protocol — the contract every CSPRNG implements — and `Random.Error`, the typed failure that random generation can surface. The package imports nothing: platform packages (swift-darwin, swift-linux, swift-windows) supply the concrete generators that fill buffers from the operating system's CSPRNG.

```swift
import Random_Primitives

// Conform a type to the generator contract.
struct CountingGenerator: Random.Generator {
    var fillByte: UInt8

    mutating func fill(_ buffer: UnsafeMutableRawBufferPointer) throws(Random.Error) {
        guard let baseAddress = buffer.baseAddress else { return }
        for i in 0..<buffer.count {
            baseAddress.storeBytes(of: fillByte, toByteOffset: i, as: UInt8.self)
        }
    }
}

// Fill a buffer with bytes from the generator.
var generator = CountingGenerator(fillByte: 0xAB)
var bytes = [UInt8](repeating: 0, count: 32)
try bytes.withUnsafeMutableBytes { buffer in
    try generator.fill(buffer)
}
```

`fill(_:)` is a `mutating` requirement, so generators may carry state, and it throws a typed `Random.Error` rather than an erased error — callers `catch` a concrete type. `Random.Error` is `Sendable` and `Hashable` with two cases: `.entropyNotReady` (Linux `getrandom(2)` called before the entropy pool is seeded) and `.systemError(Int32)`, which preserves the platform's raw `errno` / `NTSTATUS` code.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-random-primitives.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Random Primitives", package: "swift-random-primitives"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

Two library products, zero external dependencies.

| Product | Target | Purpose |
|---------|--------|---------|
| `Random Primitives` | `Sources/Random Primitives/` | The `Random` namespace + the `Random.Generator` protocol (CSPRNG contract) and `Random.Error` (`.entropyNotReady` / `.systemError`). |
| `Random Primitives Test Support` | `Tests/Support/` | Re-exports the main target for test consumers. |

Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |
| Swift Embedded | Supported |

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
