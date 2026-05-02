//
//  AsyncValueStreamTests.swift
//  Swiftlets
//
//  Created by Kevin Hayes on 2026-05-02.
//

import Testing
@testable import Swiftlets

@Suite struct AsyncValueStreamTests {
    @Test func sendsValuesToRegisteredAction() async {
        let stream = AsyncValueStream<Int>()
        let recorder = Recorder<Int>()

        await stream.registerAction { value in
            await recorder.append(value)
        }

        await stream.send(42)

        let received = await waitForSingleValue(from: recorder)
        #expect(received == 42)
    }

    @Test func sendsValuesToAllRegisteredActions() async {
        let stream = AsyncValueStream<String>()
        let firstRecorder = Recorder<String>()
        let secondRecorder = Recorder<String>()

        await stream.registerAction { value in
            await firstRecorder.append(value)
        }

        await stream.registerAction { value in
            await secondRecorder.append(value)
        }

        await stream.send("hello")

        let receivedByFirst = await waitForSingleValue(from: firstRecorder)
        let receivedBySecond = await waitForSingleValue(from: secondRecorder)

        #expect(receivedByFirst == "hello")
        #expect(receivedBySecond == "hello")
    }

    @Test func deregisteredActionStopsReceivingValues() async {
        let stream = AsyncValueStream<Int>()
        let recorder = Recorder<Int>()

        let id = await stream.registerAction { value in
            await recorder.append(value)
        }

        await stream.send(1)
        #expect(await waitUntil { await recorder.snapshot() == [1] })

        await stream.deregisterAction(id)
        await stream.send(2)

        try? await Task.sleep(nanoseconds: 100_000_000)
        #expect(await recorder.snapshot() == [1])
    }

    @Test func registeringAfterStoppingStartsDeliveryAgain() async {
        let stream = AsyncValueStream<Int>()
        let firstRecorder = Recorder<Int>()
        let secondRecorder = Recorder<Int>()

        let firstID = await stream.registerAction { value in
            await firstRecorder.append(value)
        }

        await stream.send(1)
        #expect(await waitUntil { await firstRecorder.snapshot() == [1] })

        await stream.deregisterAction(firstID)
        try? await Task.sleep(nanoseconds: 50_000_000)

        let secondID = await stream.registerAction { value in
            await secondRecorder.append(value)
        }

        await stream.send(2)

        let restartedValue = await waitForSingleValue(from: secondRecorder)
        #expect(restartedValue == 2)
        #expect(await firstRecorder.snapshot() == [1])

        await stream.deregisterAction(secondID)
    }

    @Test func orderedSendBeforeRegistrationDoesNotReplayOldValues() async {
        let stream = AsyncValueStream<Int>()
        let recorder = Recorder<Int>()

        await stream.send(1)

        await stream.registerAction { value in
            await recorder.append(value)
        }

        await stream.send(2)

        let received = await waitForSingleValue(from: recorder)
        #expect(received == 2)
        #expect(await recorder.snapshot() == [2])
    }

    @Test func detachedSendDeliversValueToRegisteredAction() async {
        let stream = AsyncValueStream<Int>()
        let recorder = Recorder<Int>()

        await stream.registerAction { value in
            await recorder.append(value)
        }

        stream.sendDetached(42)

        let received = await waitForSingleValue(from: recorder)
        #expect(received == 42)
    }

    @Test func detachedSendBeforeRegistrationCanStillReachLaterSubscriber() async {
        let stream = AsyncValueStream<Int>()
        let recorder = Recorder<Int>()

        stream.sendDetached(1)

        await stream.registerAction { value in
            await recorder.append(value)
        }

        #expect(await waitUntil { await recorder.snapshot() == [1] })
    }

    @Test func voidConvenienceSendPublishesEvent() async {
        let stream = AsyncValueStream<Void>()
        let counter = Counter()

        await stream.registerAction {
            await counter.increment()
        }

        await stream.send()

        #expect(await waitUntil { await counter.value == 1 })
    }

    @Test func detachedVoidConvenienceSendPublishesEvent() async {
        let stream = AsyncValueStream<Void>()
        let counter = Counter()

        await stream.registerAction {
            await counter.increment()
        }

        stream.sendDetached()

        #expect(await waitUntil { await counter.value == 1 })
    }

    private func waitForSingleValue<T>(from recorder: Recorder<T>) async -> T? {
        let didReceiveValue = await waitUntil {
            await recorder.snapshot().count == 1
        }

        guard didReceiveValue else { return nil }
        return await recorder.snapshot().first
    }

    private func waitUntil(
        timeoutNanoseconds: UInt64 = 1_000_000_000,
        pollIntervalNanoseconds: UInt64 = 10_000_000,
        condition: @escaping @Sendable () async -> Bool
    ) async -> Bool {
        let pollCount = max(1, Int(timeoutNanoseconds / pollIntervalNanoseconds))

        for _ in 0..<pollCount {
            if await condition() {
                return true
            }

            try? await Task.sleep(nanoseconds: pollIntervalNanoseconds)
        }

        return await condition()
    }
}

private actor Recorder<T> {
    private var values = [T]()

    func append(_ value: T) {
        values.append(value)
    }

    func snapshot() -> [T] {
        values
    }
}

private actor Counter {
    private(set) var value = 0

    func increment() {
        value += 1
    }
}
