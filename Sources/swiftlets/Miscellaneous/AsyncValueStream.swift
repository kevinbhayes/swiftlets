//
//  AsyncValueStream.swift
//  Common-iOS
//
//  Created by Kevin Hayes on 2024-04-10.
//

import SwiftUI

/// AsyncValueStream is a Combine-free replacement for PassthroughSubject
/// Using an AsyncStream, it allows the caller to send values to any object or struct
/// that has registered an action to be run when a value is sent into the stream.
///
/// To create an AsyncValueStream instance, simply call `AsyncValueStream<Type>()`.
/// For example,
/// ```
/// let myStream = AsyncValueStream<Bool>()
/// ```
///
/// To register an action, call
/// `registerAction(_ action: AsyncValueStream.Action) -> AsyncValueStream.ID`
/// The action should be deregistered when it is no longer needed. For example, a class’
/// `deinit` method could deregister the action.
///
/// To send a value into the stream, call `send(value: T)`.
/// See the SwiftUI Preview for an example.
public actor AsyncValueStream<T: Sendable> {
	public typealias ID = UUID
	public typealias Action = @Sendable (T) async -> Void
	public typealias VoidAction = @Sendable () async -> Void

	private var actions = [ID: Action]()
	private var task: Task<Void, Never>?

	private var stream: AsyncStream<T>?
	private var continuation: AsyncStream<T>.Continuation?

	public init() { }

	/// Sends the value of the declared type to those who have registered an action.
	/// - Parameter value: the value to send. It must match the type used to initialize the AsyncValueStream instance.
	public nonisolated func send(_ value: T) {
		Task {
			let _ = await continuation?.yield(value)
		}
	}

	/// Register an action to be run when a value is sent over the stream. Callers to this function should store the returned ID
	/// and use it to deregister the action when no longer needed.
	/// - Parameter action: a closure with the sent value as a parameter.
	/// - Returns: The AsyncValueStream.ID of the action. Store this for deregistering later.
	@discardableResult
	public func registerAction(_ action: @escaping Action) -> ID {
		let uuid = UUID()
		actions[uuid] = action

		if task == nil {
			stream = AsyncStream { (continuation: AsyncStream<T>.Continuation) in
				if self.continuation != nil {
					print("AsyncStream continuation was not properly stopped")
				}
				self.continuation = continuation
			}

			task = Task { [weak self] in
				guard let self,
					  let newStream = await stream
				else {
					return
				}

				for await value in newStream {
					for action in await actions.values {
						Task {
							await action(value)
						}
					}
				}
			}
		}
		return uuid
	}

	/// Deregisters the action with the given id. The stream is stopped when no actions remain. It will automatically start up again when a new action is registered.
	/// - Parameter id: the id of the action returned from `registerAction(_ action: Action)`
	public func deregisterAction(_ id: ID) {
		actions.removeValue(forKey: id)
		if actions.isEmpty {
			stop()
		}
	}

	private func removeContinuation() {
		continuation = nil
	}

	// developer note: I'm not sure if we'll need this. I'll leave it here for the preview. If we need it in the future,
	// feel free to make it public and document it. Consider if we should remove the actions too.
	fileprivate func stop() {
		removeContinuation()
		task?.cancel()
		task = nil
	}

	deinit {
		self.task?.cancel()
	}
}

public extension AsyncValueStream where T == Void {
	nonisolated func send() {
		send(())
	}
}
