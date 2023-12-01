
// MARK: Task extensions

public extension Task where Success == Never, Failure == Never {
    /// Suspends the current task for at least the given duration
    /// in seconds.
    ///
    /// This function doesn't block the underlying thread.
    ///
    /// - Note: Unlike other `sleep` methods, this does not throw any errors.
    /// - Parameter duration: The duration to sleep for in seconds.
    static func sleep(seconds duration: Double) async {
        do {
            try await self.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
        }
        catch {
            
        }
    }
}
