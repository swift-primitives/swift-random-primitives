// Random.Error Tests.swift

import Testing
import Random_Primitives

extension Random.Error {
    enum Test {
        @Suite struct Unit {}
        @Suite struct EdgeCase {}
        @Suite struct Integration {}
        @Suite(.serialized) struct Performance {}
    }
}

// MARK: - Unit Tests

extension Random.Error.Test.Unit {
    @Test
    func `entropyNotReady case exists`() {
        let error = Random.Error.entropyNotReady
        _ = error // Verify it compiles
    }

    @Test
    func `systemError case holds error code`() {
        let error = Random.Error.systemError(42)
        if case .systemError(let code) = error {
            #expect(code == 42)
        } else {
            Issue.record("Expected systemError case")
        }
    }

    @Test
    func `Error conforms to Swift.Error`() {
        let error: any Swift.Error = Random.Error.entropyNotReady
        _ = error
    }

    @Test
    func `Error conforms to Sendable`() {
        let error: any Sendable = Random.Error.entropyNotReady
        _ = error
    }

    @Test
    func `Error conforms to Hashable`() {
        var set = Set<Random.Error>()
        set.insert(.entropyNotReady)
        set.insert(.systemError(1))
        set.insert(.systemError(2))
        #expect(set.count == 3)
    }

    @Test
    func `Equal errors are equal`() {
        #expect(Random.Error.entropyNotReady == Random.Error.entropyNotReady)
        #expect(Random.Error.systemError(42) == Random.Error.systemError(42))
    }

    @Test
    func `Different errors are not equal`() {
        #expect(Random.Error.entropyNotReady != Random.Error.systemError(0))
        #expect(Random.Error.systemError(1) != Random.Error.systemError(2))
    }
}
