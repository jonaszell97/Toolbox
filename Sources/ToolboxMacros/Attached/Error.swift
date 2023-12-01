
import Foundation

enum MacroError {
    /// An invalid macro argument was passed.
    case invalidArgument(String)
}

extension MacroError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidArgument(let argument):
            return "Invalid macro argument: \(argument)"
        }
    }
}
