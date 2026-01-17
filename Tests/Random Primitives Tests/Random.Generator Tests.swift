// Random.Generator Tests.swift

import Testing
import Testing_Extras
@testable import Random_Primitives

// MARK: - Mock Generator for Testing

/// A deterministic generator that fills buffers with a repeating byte pattern.
private struct MockGenerator: Random.Generator, Sendable {
    var fillByte: UInt8

    init(fillByte: UInt8 = 0xAB) {
        self.fillByte = fillByte
    }

    mutating func fill(_ buffer: UnsafeMutableRawBufferPointer) throws(Random.Error) {
        guard let baseAddress = buffer.baseAddress else { return }
        for i in 0..<buffer.count {
            baseAddress.storeBytes(of: fillByte, toByteOffset: i, as: UInt8.self)
        }
    }
}

/// A generator that always throws an error.
private struct FailingGenerator: Random.Generator, Sendable {
    let error: Random.Error

    init(error: Random.Error = .entropyNotReady) {
        self.error = error
    }

    mutating func fill(_ buffer: UnsafeMutableRawBufferPointer) throws(Random.Error) {
        throw error
    }
}

// MARK: - Test Suite

extension Random {
    enum GeneratorTests {
        #TestSuites
    }
}

// MARK: - Unit Tests

extension Random.GeneratorTests.Test.Unit {
    @Test("Generator protocol can be implemented")
    func protocolImplementation() throws {
        var generator = MockGenerator()
        var buffer = [UInt8](repeating: 0, count: 16)
        try buffer.withUnsafeMutableBytes { ptr in
            try generator.fill(ptr)
        }
        #expect(buffer.allSatisfy { $0 == 0xAB })
    }

    @Test("Generator handles empty buffer")
    func emptyBuffer() throws {
        var generator = MockGenerator()
        var buffer: [UInt8] = []
        try buffer.withUnsafeMutableBytes { ptr in
            try generator.fill(ptr)
        }
        #expect(buffer.isEmpty)
    }

    @Test("Generator can throw typed error")
    func throwsTypedError() {
        var generator = FailingGenerator(error: .entropyNotReady)
        var buffer = [UInt8](repeating: 0, count: 16)

        #expect(throws: Random.Error.entropyNotReady) {
            try buffer.withUnsafeMutableBytes { ptr in
                try generator.fill(ptr)
            }
        }
    }

    @Test("Generator can throw systemError")
    func throwsSystemError() {
        var generator = FailingGenerator(error: .systemError(123))
        var buffer = [UInt8](repeating: 0, count: 16)

        #expect(throws: Random.Error.systemError(123)) {
            try buffer.withUnsafeMutableBytes { ptr in
                try generator.fill(ptr)
            }
        }
    }

    @Test("Generator is Sendable")
    func sendable() {
        let generator: any Random.Generator & Sendable = MockGenerator()
        _ = generator
    }

    @Test("Generator can be used as existential")
    func existential() throws {
        var generator: any Random.Generator = MockGenerator(fillByte: 0xFF)
        var buffer = [UInt8](repeating: 0, count: 8)
        try buffer.withUnsafeMutableBytes { ptr in
            try generator.fill(ptr)
        }
        #expect(buffer.allSatisfy { $0 == 0xFF })
    }
}

// MARK: - Edge Cases

extension Random.GeneratorTests.Test.EdgeCase {
    @Test("Generator fills large buffer")
    func largeBuffer() throws {
        var generator = MockGenerator(fillByte: 0x42)
        var buffer = [UInt8](repeating: 0, count: 1024 * 1024)
        try buffer.withUnsafeMutableBytes { ptr in
            try generator.fill(ptr)
        }
        #expect(buffer.allSatisfy { $0 == 0x42 })
    }

    @Test("Generator state can be mutated")
    func mutableState() throws {
        var generator = MockGenerator(fillByte: 0x01)

        var buffer1 = [UInt8](repeating: 0, count: 4)
        try buffer1.withUnsafeMutableBytes { ptr in
            try generator.fill(ptr)
        }
        #expect(buffer1.allSatisfy { $0 == 0x01 })

        generator.fillByte = 0x02
        var buffer2 = [UInt8](repeating: 0, count: 4)
        try buffer2.withUnsafeMutableBytes { ptr in
            try generator.fill(ptr)
        }
        #expect(buffer2.allSatisfy { $0 == 0x02 })
    }
}
