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
    @Test("entropyNotReady case exists")
    func entropyNotReadyExists() {
        let error = Random.Error.entropyNotReady
        _ = error // Verify it compiles
    }

    @Test("systemError case holds error code")
    func systemErrorHoldsCode() {
        let error = Random.Error.systemError(42)
        if case .systemError(let code) = error {
            #expect(code == 42)
        } else {
            Issue.record("Expected systemError case")
        }
    }

    @Test("Error conforms to Swift.Error")
    func conformsToError() {
        let error: any Swift.Error = Random.Error.entropyNotReady
        _ = error
    }

    @Test("Error conforms to Sendable")
    func conformsToSendable() {
        let error: any Sendable = Random.Error.entropyNotReady
        _ = error
    }

    @Test("Error conforms to Hashable")
    func conformsToHashable() {
        var set = Set<Random.Error>()
        set.insert(.entropyNotReady)
        set.insert(.systemError(1))
        set.insert(.systemError(2))
        #expect(set.count == 3)
    }

    @Test("Equal errors are equal")
    func equality() {
        #expect(Random.Error.entropyNotReady == Random.Error.entropyNotReady)
        #expect(Random.Error.systemError(42) == Random.Error.systemError(42))
    }

    @Test("Different errors are not equal")
    func inequality() {
        #expect(Random.Error.entropyNotReady != Random.Error.systemError(0))
        #expect(Random.Error.systemError(1) != Random.Error.systemError(2))
    }
}
