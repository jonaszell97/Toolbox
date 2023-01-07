
import Foundation
import os

#if canImport(Combine)
import Combine
#endif

public final class Log {
    public static var reportCriticalError: (String) -> Void = {
        fatalError($0)
    }
}

#if DEBUG

public extension OSLog {
    func callAsFunction(_ type: OSLogType, _ s: String) {
        os_log("%{public}s", log: self, type: type, s)
    }
}

public final class LogContainer: ObservableObject {
    #if canImport(Combine)
    /// List of all log messages in chronological order.
    @Published public var logs: [(String, String, String, Date)] = []
    #else
    /// List of all log messages in chronological order.
    public var logs: [(String, String, String, Date)] = []
    #endif
    
    /// Shared instance.
    public static let shared: LogContainer = LogContainer()
    
    /// Default initializer.
    public init() {}
}

public struct Logger {
    /// The logger subsystem.
    public let subsystem: String
    
    /// The logger category.
    public let category: String
    
    /// The OS logger.
    public let logger: OSLog
    
    /// Default initializer.
    public init(subsystem: String, category: String) {
        self.subsystem = subsystem
        self.category = category
        self.logger = OSLog(subsystem: subsystem, category: category)
    }
    
    public func log(_ message: String) {
        LogContainer.shared.logs.append(("Log", category, message, Date()))
        logger(.default, message)
    }
    
    public func debug(_ message: String) {
        LogContainer.shared.logs.append(("Debug", category, message, Date()))
        logger(.debug, message)
    }
    
    public func info(_ message: String) {
        LogContainer.shared.logs.append(("Info", category, message, Date()))
        logger(.info, message)
    }
    
    public func notice(_ message: String) {
        LogContainer.shared.logs.append(("Notice", category, message, Date()))
        logger(.default, message)
    }
    
    public func warning(_ message: String) {
        LogContainer.shared.logs.append(("Warning", category, message, Date()))
        logger(.default, message)
    }
    
    public func error(_ message: String) {
        LogContainer.shared.logs.append(("Error", category, message, Date()))
        logger(.error, message)
    }
    
    public func critical(_ message: String) {
        var message = message
        message += """
            \n------------------------------
            [Stack Trace]
            \(Thread.callStackSymbols.joined(separator: "\n"))
            ------------------------------
        """
        
        LogContainer.shared.logs.append(("Critical", category, message, Date()))
        logger(.fault, message)
    }
    
    public func temporary(_ message: String) {
        LogContainer.shared.logs.append(("Debug", category, message, Date()))
        logger(.debug, message)
    }
}

extension DefaultStringInterpolation {
    public mutating func appendInterpolation<T>(_ argumentObject: @autoclosure @escaping () -> T,
                                                privacy: OSLogPrivacy)
    where T: CustomStringConvertible
    {
        self.appendInterpolation(argumentObject().description)
    }
}

#else

extension Logger {
    /// Discard a debug log.
    func debug(_ message: String) {
        
    }
    
    /// Log a critical error that should be submitted as Analytics.
    func critical(_ message: String) {
        os_log("%{public}s", type: .fault, message)
    }
}

#endif
