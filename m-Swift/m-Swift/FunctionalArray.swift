import Foundation

public func <?><A, B>(_ function: (A) -> B, arg: [A]) -> [B] {
    return arg.map(function)
}

public func <*><A, B>(_ transform: [(A) -> B], arg: [A]) -> [B] {
    return transform.flatMap { arg.map($0) }
}

public func |>><A, B>(_ transform: [(A) -> [B]], arg: [A]) -> [B] {
    return transform.flatMap { arg.flatMap($0) }
}
