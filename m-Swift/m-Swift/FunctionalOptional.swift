import Foundation

infix operator <?>: ApplicativePrecedence
public func <?><A, B>(_ function: (A) -> B, arg: A?) -> B? {
    return arg.map(function)
}

infix operator <*>: ApplicativePrecedence
public func <*><A, B>(_ transform: ((A) -> B)?, arg: A?) -> B? {
    return transform.flatMap { arg.map($0) }
}

infix operator |>>: BindingPrecedence
public func |>><A, B>(_ transform: ((A) -> B?)?, arg: A?) -> B? {
    return transform.flatMap { arg.flatMap($0) }
}
