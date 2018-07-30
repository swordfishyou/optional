# Optional
This simple playground introduces the functional approach to Swift `Optional`. Run through commits to investigate how code changes.

## Motivation
Swift's _optional binding_ and common usage often preferable for clarity and style. But `Optional` is a container type for a reason: it preserves specific context. The context is:
* it's OK for `Optional` value to absent
* one doesn't use `Optional` for _error handling_

`guard let` and `if let` force you to unwrap the box and handle the absence of a value. Moreover, so called _optional binding_ is implemented as conditional statement, so it breaks control flow.

## Implementation
`Optional` provides a handful interface for applying functions to such values in a _pipeline_. Using default functions `map` and `flatMap` one can implement robust DSL of just three operators: `<*>` aka _apply_, `??=` aka _bind_ and `<?>` aka _map_. We also introduce _currying_ in order to apply functions with multiple arguments as well as default operators to values wrapped into `Optional`.

### `curry`
Default implementation curries a function of two arguments, but it's not a problem to extend it further
```swift
func curry<A, B, C>(_ function: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { argA in { argB in function(argA, argB) } }
}
```
### apply
Syntax and notation is based on Haskell's `Applicative` type providing the same operator. So type's name is used for operator's `precedencegroup` 
```swift
precedencegroup ApplicativePrecedence {
    associativity: left
    higherThan: NilCoalescingPrecedence
}
```
Operator applies any optional function of type `(Wrapped) -> T` to a value wrapped into `Optional`
```swift
func <*><A, B>(_ transform: ((A) -> B)?, arg: A?) -> B? {
    return transform.flatMap { arg.map($0) }
}
```
### map
Map, alongside with _apply_ allows us non-optional functions application to multiple optional values. Consider a sum or a product of two optional integers. One can implement extensions, but beautiful and robust solution is using operator in `ApplicativePrecedence` group:
```swift
func <?><A, B>(_ function: (A) -> B, arg: A?) -> B? {
    return arg.map(function)
}
```
### bind
`guard let` and `if let` unwraps `Optional` and binds its value to a variable. That's not what functional binding really is. One can think of it like a functional composition for container types, that preserves container's context. In Haskell bind is introduced in `Monad` type  as `>>=` operator. In Swift this name is reserved for a default operator, that's why we name it `??=` since `?` is strongly related to `Optional`.

Operator's behavior motivates `precedencegroup` name
```swift
precedencegroup BindingPrecedence {
    associativity: left
    higherThan: ApplicativePrecedence
}
```

_bind_ operator applies optional function of type `(Wrapped) -> T?` to optional value, so it binds one `Optional` to another.
```swift
func ??=<A, B>(_ transform: ((A) -> B?)?, arg: A?) -> B? {
    return transform.flatMap { arg.flatMap($0) }
}
```

#### Arguments order
You may noticed that `precedencegroup`s have left associativity, but function comes as a first argument. This introduces a prefix application of a function like we regulary do but instead of bracers we have an operator: `f(x)` is replaced with `f <?> x`.

If we apply several operators in with the same precedence we can avoid bracers to let compiler understand what do we want.