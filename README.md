# Optional
This simple playground introduces the functional approach to Swift `Optional`. Run through commits to investigate how code changes.

## Motivation
Swift's _optional binding_ and common usage often preferable for clarity and style. But `Optional` is a container type for a reason: it preserves specific context. The context is:
* it's OK for `Optional` value to absent
* one doesn't use `Optional` for _error handling_

`guard let` and `if let` force you to unwrap the box and handle the absence of a value. Moreover, so called _optional binding_ is implemented as conditional statement, so it breaks control flow.

## Implementation
`Optional` provides a handful interface for applying functions to such values in a _pipeline_. Using default functions `map` and `flatMap` one can implement robust DSL of just two operators: `<*>` aka _apply_ and `??=` aka _bind_. We also introduce _currying_ in order to apply functions with multiple arguments as well as default operators to values wrapped into `Optional`.

### `curry`
Default implementation curries a function of two arguments, but it's not a problem to extend it further
```swift
func curry<A, B, C>(_ function: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { argA in { argB in function(argA, argB) } }
}
```
### `apply`
Syntax and notation is based on Haskell's `Applicative` type providing the same operator. So type's name is used for operator's `precedencegroup` 
```swift
precedencegroup ApplicativePrecedence {
    associativity: left
    higherThan: NilCoalescingPrecedence
}
```
Operator applies any optional function of type `(Wrapped) -> T` to a value wrapped into `Optional`
```swift
func <*><A, B>(_ arg: A?, transform: ((A) -> B)?) -> B? {
    return arg.map { value in transform.map { $0(value) } }?.flatten()
}
```
#### `flatten`
A helper function for `Optional` flattens the value if `Optional` wraps another `Optional`
```swift
extension Optional {
    func flatten<U>() -> U? where Wrapped == U? {
        return self.flatMap { $0.flatMap { $0 } }
    }
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
func ??=<A, B>(_ arg: A?, transform: ((A) -> B?)?) -> B? {
    return arg.flatMap { value in transform.flatMap { $0(value) } }
}
```
## Further steps
There is one main concern here: why do we apply optional functions in our operators? The answer is pretty simple: since operators perform partial application of a curried function, resulting function is `Optional`. In Haskell `Applicative` type provides `pure` function that allows user apply functions in a pipeline without thinking of container's context.

Accordingly, next steps are implementing the function like `pure`.