import Foundation

precedencegroup ApplicativePrecedence {
    associativity: left
    higherThan: NilCoalescingPrecedence
}

infix operator >>>: ApplicativePrecedence
public func >>><A, B>(_ function: (A) -> B, argument: A) -> B {
    return function(argument)
}

infix operator |>: ApplicativePrecedence
public func |><A, B, C>(_ lhs: @escaping (A) -> B, rhs: @escaping (B) -> C) -> (A) -> C {
    return { rhs(lhs($0)) }
}
