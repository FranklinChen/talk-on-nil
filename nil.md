# `nil`: historical, theoretical, comparative, philosophical, and practical perspectives <br> <i>Franklin Chen</i> <br> <i>[http://franklinchen.com/](http://franklinchen.com/)</i> <br> Pittsburgh Ruby <br> September 6, 2012

---

# About me

- my first Pittsburgh Ruby meeting: November 2010
- programmer at CMU, psychology department

## Approach to programming

- be pragmatic
- improve
- apply theory to practice
- understand we are human

---

# Polyglot

- Ruby
- Java
- Python
- Perl
- Lisp
- ML
- Haskell
- Scala
- C++
- JavaScript
- XSLT
- etc.

---

# Why I'm giving this talk

*Steel City Ruby Conf* in August 2012: my first Ruby conference

## Josh Susser, *Thinking in Objects*

Josh advocated [monkey-patching](http://en.wikipedia.org/wiki/Monkey_patch) of `nil` to remove a `nil` check in an `if`/`else`.

![Monkey patching cartoon](http://i.qkme.me/353lnj.jpg)

Hated!

## Many lightning talks at conference

Inspired!

---

# History: "My billion-dollar mistake"

> I call it my billion-dollar mistake. It was the invention of the **null reference** in 1965. At that time, I was designing the first comprehensive type system for references in an object oriented language (ALGOL W). My goal was to ensure that all use of references should be absolutely **safe**, with checking performed automatically by the compiler. But I couldn't resist the temptation to put in a null reference, **simply because it was so easy to implement**. This has led to innumerable errors, vulnerabilities, and system crashes, which have probably caused **a billion dollars of pain and damage in the last forty years**.

Who [said this in 2009](http://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare)?

---

# [Tony Hoare](http://en.wikipedia.org/wiki/Tony_Hoare)

- invented and implemented `null` (1965)
- invented and implemented Quicksort (1960)
- invented much other important stuff
- won Turing Award (1980):

> *fundamental contributions to the definition and design of programming languages*

![Tony Hoare in 2011](http://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Sir_Tony_Hoare_IMG_5125.jpg/240px-Sir_Tony_Hoare_IMG_5125.jpg)

---

# History: "Pornographic programming"

> The unexpected appearance of an interpreter tended to freeze the form of the language, and some of the decisions made rather lightheartedly for the ... paper later proved unfortunate. These included ... the use of the number zero to denote the empty list NIL and the truth value false. Besides encouraging **pornographic programming**, giving a special interpretation to the address 0 has caused difficulties in all subsequent implementations.

Who [said this in 1979](http://www-formal.stanford.edu/jmc/history/lisp/node3.html#SECTION00030000000000000000)?

---

# [John McCarthy](http://en.wikipedia.org/wiki/John_McCarthy_(computer_scientist))

- invented Lisp in [1960](http://www-formal.stanford.edu/jmc/recursive.html)
- implemented `nil`
- invented the term and field of Artificial Intelligence
- won Turing Award (1971)

![John McCarthy in 2006](http://upload.wikimedia.org/wikipedia/commons/thumb/4/49/John_McCarthy_Stanford.jpg/320px-John_McCarthy_Stanford.jpg)

---

# Our heroes: `null` vs. `nil`

`null`: *billion-dollar mistake*

![Tony Hoare in 2011](http://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Sir_Tony_Hoare_IMG_5125.jpg/240px-Sir_Tony_Hoare_IMG_5125.jpg)

`nil`: *pornographic programming*

![John McCarthy in 2006](http://upload.wikimedia.org/wikipedia/commons/thumb/4/49/John_McCarthy_Stanford.jpg/320px-John_McCarthy_Stanford.jpg)

---

# Topics to discuss

- `nil` and `null` in Ruby and other languages
- the problems
- reasons for the honest mistakes
- solutions to the problems

---

# Starting with basics: Ruby `nil`

Who has *never* seen this output when running a Ruby program?

    !console
    nil.rb:2:in `<main>': undefined method `name' for nil:NilClass (NoMethodError)

Point of failure:

    !ruby
    puts 'Dr. ' + person.name

## *What went wrong?*

(Trick question.)

---

# Not only a Ruby problem

## C++

C++ is *unsafe*: fails catastrophically on `NULL` dereference:

    !console
    Segmentation fault: 11

Point of failure:

    !cpp
    cout << "Dr. " << person->getName() << endl;

## Java

Java (like Ruby) is *safe*: checks for `null` dynamically:

    !console
    Exception in thread "main" java.lang.NullPointerException
            at Null.main(Null.java:10)

Point of failure:

    !java
    System.out.println("Dr. " + person.getName());

---

# Ruby `nil`'s cousins

- `nil` (Smalltalk, Lisp)
- `null` (Java)
- `NULL` (C)
- `nullptr` (C++)
- `undef` (Perl)
- `None` (Python)
- `None` (OCaml, Scala)
- `Nothing` (Haskell)
- etc.

*Most of these engage in some form and extremeness level of pornography.*

Of those, we focus on Ruby's `nil`.

---

# `nil` in Ruby

*Taken from [Smalltalk](http://en.wikipedia.org/wiki/Smalltalk), invented in 1971, inspired by [Lisp](http://en.wikipedia.org/wiki/Lisp_(programming_language)).*

- class [`NilClass`](http://www.ruby-doc.org/core-1.9.3/NilClass.html)
- singleton object `nil` of `NilClass`

Some methods:

- &
- `nil?`
- `to_a`
- `to_s`
- etc.

---

# Philosophy: ethics

## Action

Who does what to whom?

## Intention

Who intends to do what?

## Responsibility

Who should do what?

## Means

How does one do something?

## Trust

How to believe someone has done the right thing?

---

# Ruby `nil` example, revisited

Failure:

    !console
    nil.rb:2:in `<main>': undefined method `name' for nil:NilClass (NoMethodError)

Code that crashed:

    !ruby
    puts 'Dr. ' + person.name

## *"What went wrong?"*

Three cases:

- *unintentionally* uninitialized, left at default value of `nil`
- *deliberately* assigned `nil`
- *deliberately* assigned a reference to some other object, which happened to be `nil`

---

# 1: Unintentionally uninitialized

Problem: forgot to initialize `person` as *intended*.

---

# 1: Initialization solution

Solution:

- track back
- find *responsible* code path
- insert initialization
- initialization logic: *responsible* not to return `nil`
- obtain initial value from a source of *trust*, which never returns `nil`

New code somewhere:

    !ruby
    person = Person.new(:name => 'Smith')

Note: `Person.new` will never return `nil` if it succeeds at all.

---

# 2: Deliberate `nil`

Problem: `person` was *intended* to be `nil`, to indicate there is no longer a person.

Elaboration: there was a person in the room, but the person left, so `person` was set to `nil`, and there should be no greeting.

---

# 2: Deliberate `nil` solution

Solution:

- caller *trusts* that `person` could be `nil`
- caller is *responsible* to check for `nil`
- caller is *responsible* for adding appropriate *action* in case of `nil`

New caller code:

    !ruby
    if person.nil?
      puts 'I see nobody here'
    else
      puts 'Dr. ' + person.name
    end

Note: putting in a `nil` check is not enough; must provide entire code path.

---

# 3: Deliberately assigned reference

Problem: `person` was assigned `some_method(...)` at some point.

    !ruby
    person = room.find_tallest_person
    puts 'Dr. ' + person.name

---

# 3: No solution: problem propagated

New problem: locally, without further context,

- don't know whether `person` is ever *intended* to possibly be `nil`
- don't know whether `some_method` is *responsible* for giving us `nil` or non-`nil`
- don't know whether the caller code has any *responsibility* to check `nil`
- we don't know what *action* to take, and whom to *trust*

The big problem with `nil`: *any assignment other than to `nil` itself or a constructor call might or might not result in `nil`*.

---

# 3: "Defensive" `nil` checks?

Solution (?):

- caller has *trusts* nobody: check every single variable read with `nil?`
- caller always *responsible* for some *action* for any possible `nil` branch

Drawbacks:

- code bloat
- inefficiency
- loss of clear *intention* and *trust*
- loss of incentive for anyone to be *responsible* for guaranteeing non-`nil`, since everyone will check anyway

How many people code in this way?

---

# 3: Give up goal of no `nil` exceptions?

Solution (?):

- use a few defensive `nil` checks
- document (with [YARD](http://yardoc.org/)?) what can or cannot be `nil`
- write unit tests, acceptance tests, etc.
- handle exception at some high level in program

Example:

    !ruby
    begin
      # deeply nested code...
    rescue NoMethodError => e
      # restart the app at some good state
    end

---

# Bad monkey-patching

Ruby allows monkey-patching: modifying a class.

Solution (?):

    !ruby
    class NilClass
      def name
        'Default Name'
      end
    end

    person = nil
    puts 'Dr. ' + person.name

Output:

    !console
    Dr. Default Name

Drawbacks:

- global `nil` *responsible* for a person's name??
- *worse than failing*: produces wrong output!!

---

# Even worse monkey-patching

Not a solution either:

    !ruby
    class NilClass
      def method_missing(*args)
        nil
      end
    end

    person = nil
    puts 'Dr. ' + person.name.junk.nonsense.everywhere

Output:

    !console
    nil-monkey-all.rb:8:in `+': can't convert NilClass to String (NilClass#to_str
                                gives NilClass) (TypeError)
            from nil-monkey-all.rb:8:in `<main>'

Drawbacks:

- silently swallows up a whole series of nonexistent methods
- fails far worse than original code that failed fast at `name`
- `puts person.name.junk.nonsense.everywhere` would have succeeded, unintentionally

---

# Philosophy: what is nothingness?

*absence* of a `Person`

**should not be the same concept as**

*presence* of a `NilClass`

---

# History: why `null` and `nil`?

Tony Hoare and John McCarthy knew how to do things right in the 1960s, but *chose* not to!

- Hoare invented `null` for a statically typed language for *efficiency* and his convenience as a compiler writer
- McCarthy implemented "pornographic" properties of `nil` for a dynamically typed language for *efficiency* and his convenience as an interpreter writer

**"Those who cannot remember the past are condemned to repeat it."** (George Santayana, 1905)

---

# Fixing `null` and `nil`

- `null`: replace with static type system as in *functional* languages
- `nil`: replace with *object-oriented* design pattern

Explore both: duality between functional and object-oriented languages.

Start with functional.

---

# A basic static type system

- computation as a branch of *philosophy*
- static type system: a *language* for understanding programming languages

Examples in Haskell syntax for convenience.

(Note: intended semantics is ML: Haskell's lazy types introduce complications.)

---

# Primitive types

Primitive types:

    !haskell
    example1 :: Int
    example1 = 42

    example2 :: Char
    example2 = 'c'

    example3 :: ()
    example3 = ()

etc.

---

# Product types (records)

Tuples of type `A` *and* type `B` *and* ...

Most languages add syntactic sugar and semantics, as records or structs or classes.

    !haskell
    type Person = (Int, String)

    person :: Person
    person = (42, "Sally")

    example :: (Bool, Person)
    example = (True, (42, "Sally"))

Real Haskell has records:

    !haskell
    data Person = P { id :: Int, name :: String }

    person :: Person
    person = P { id = 42, name = "Sally" }

---

# Sum types ([tagged unions](http://en.wikipedia.org/wiki/Tagged_union))

Type `A` *or* type `B` *or* ..., value tagged with which one it is.

Familiar from ALGOL (1960s), Pascal (1970s), etc.

    !haskell
    data Color = Red | Blue
    example1 = Red
    example2 = Blue

    data Bool = False | True

    data Key = Name String | ID Int
    example1 = Name "Sally"
    example2 = ID 12

    data Login = Guest | User Key
    example1 = Guest
    example2 = User (Name "Sally")
    example3 = User (ID 12)

---

# Function types

Function type from type `A` to type `B`:

    !haskell
    addInts :: Int -> Int -> Int
    addInts x y = x + y

    greeting :: Person -> String
    greeting person = "Dr. " ++ name person

Note: `greeting` never gets a `null` and never fails.

The type system guarantees that `greeting` can only be called on a valid `Person`.

---

# But we need nothingness!

In real life, need a way to express: `x` can be bound to a `Person` *or* to nothing.

Very easy: use a sum type!

    !haskell
    data MaybePerson = Nobody
                     | One Person

    -- OK
    person :: Person
    person = P { id = 42, name = "Sally" }

    -- type error!
    personFAIL = Nobody

    -- OK, nobody
    possiblePerson1 :: MaybePerson
    possiblePerson1 = Nobody

    -- Wrapped person
    possiblePerson2 :: MaybePerson
    possiblePerson2 = One (P { id = 12, name = "Jack" })

---

# Dealing with a possible `Person`

Functions can be defined to require a `Person` or `MaybePerson`:

    !haskell
    greeting :: Person -> String
    greeting person = "Dr. " ++ name person

    -- will not type check
    greetingForMaybePersonFAIL :: MaybePerson -> String
    greetingForMaybePersonFAIL person = "Dr. " ++ name person

    -- type checks
    greetingForMaybePerson :: MaybePerson -> String
    greetingForMaybePerson maybePerson =
      case maybePerson of
        Nobody     -> "I see nobody here"
        One person -> "Dr. " ++ name person

---

# No silver bullet

This technique does *not* prevent buggy code!

    !haskell
    -- type checks, but compiler warns of missing case of Nobody
    greetingForMaybePersonBAD :: MaybePerson -> String
    greetingForMaybePersonBAD maybePerson =
      case maybePerson of
        One person -> "Dr. " ++ name person

    -- run this code
    greetingForMaybePersonBAD Nobody

Failure:

    !console
    Exception: Non-exhaustive patterns in case

But at least the compiler warns you of code branches you were supposed to write.

---

# Wrapping up on types: parameterized

Parameterized types (generics) use type variables such as `a`, `b`.

C++ templates, C# generics, Java generics, etc.

    !haskell
    type NestedTriple a b c = (a, (b, c))

    example1 :: NestedTriple Boolean Int String
    example1 = (True, (42, "Sally"))

---

# `Maybe` as parameterized type

The static typing way to mitigate the `nil` problem:

    !haskell
    data Maybe a = Nothing | Just a
    
Avoid having to create a special `MaybeX` wrapper type for every type we want to have a `nil` possibility for.

    !haskell
    possiblePerson:: Maybe Person
    possiblePerson = Maybe (P { id = 12, name = "Jack" })

[Standard ML](http://www.standardml.org/Basis/option.html), [OCaml](http://ocaml-lib.sourceforge.net/doc/Option.html), [Scala](http://www.scala-lang.org/api/current/scala/Option.html) also have this parameterized type, except that they use different words: `Option` instead of `Maybe`, `None` instead of `Nothing`, and `Some` instead of `Just`.

---

# `Maybe` example: intention

(Back to ethics.)

Every variable has a static type.

*A type is an intention.*

---

# `Maybe` example: responsibility

Every variable, because it has a declared type, forces an accessor to take responsibility for how to use it.

A variable not of a `Maybe` type can never be bound to `Nothing`.

*The type checker of the compiler enforces everyone's responsibility.*

---

# `Maybe` example: means

Means: static type checker of compiler.

---

# `Maybe` example: trust

Trust (for type correctness) is delegated to the compiler.

(But type correctness does not guarantee code correctness.)

---

# `Maybe` example: action

Type forces us to take action: unwrap a `Maybe` value to treat both cases.

But

- no guarantees that you will write the correct code for each case
- no guarantee that you won't just defeat the type system by declaring everything to be of `Maybe` type

`Maybe` is a *tool*, not a *solution* to programming.

Java and similar so-called statically typed languages: really duck typed languages!

- every reference can quack like its declared type or quack like `null`
- `null` quacks unconditionally by either a segmentation fault or an exception

---

# `Maybe`, conclusion

Observations:

- static type system: tool to distinguish between nothing and something
- for each type `a`, the type `Maybe a` generates its own unique `Nothing`: no global `nil`
- helps with: intention, responsibility, means, trust
- we still have to act for ourselves: think and code

---

# `Maybe`: back to history

- Hoare knew how to do `null` right in the 1960s
- Hoare weakened his static type system for efficiency and convenience
- ML had `Maybe` in the 1970s and 1980s
- C++, Java and similar languages give static type systems a bad name

Reminder: purpose of static type system is to aid human reasoning; *not* primarily for efficiency!

---

# Back to Ruby and `nil`

- Ruby: not statically typed
- How apply the lessons from types?

Possibilities:

- Use Ruby-oriented `Maybe` wrapper
- Use "null object" object-oriented design pattern

---

# `Maybe` for Ruby

- many `Maybe`-inspired Ruby libraries

I have not used any of these examples, but should examine for correctness and usefulness

- [rumonade](http://github.com/ms-ati/rumonade)
- [monadic](http://github.com/pzol/monadic)
- [maybelline](http://blatyo.github.com/maybelline/)
- [maybe](http://github.com/bhb/maybe)

---

# [Null object design pattern](http://en.wikipedia.org/wiki/Null_Object_pattern)

Exploit duality of functional and object-oriented design:

- each part of a sum type becomes its own class
- each function that does a case analysis becomes a method

Original code:

    !ruby
    def greeting(person)
      if person.nil?
        puts 'I see nobody here'
      else
        puts 'Dr. ' + person.name
      end
    end

    person = nil
    greeting person

---

# Transform functional to OO

New code:

    !ruby
    class Person
      # ...

      def greeting
        puts 'Dr. ' + @name
      end
    end

    class NoPerson
      def greeting
        puts 'I see nobody here'
      end
    end

    person = NoPerson.new
    person.greeting

---

# Drawbacks of null object pattern

- inversion of design may not be natural
- works with simple examples with limited case switching to extract
- not possible when switching on more than one value

Workarounds:

- [visitor pattern](http://en.wikipedia.org/wiki/Visitor_pattern)
- [multimethod object-oriented language such as Clojure](http://clojure.org/multimethods)

---

# History continues

- Efficiency still matters: [Scala debate](https://groups.google.com/forum/?fromgroups=#!forum/scala-debate) *at this very moment* (September 2012) about whether to optimize away the indirection of `Option` at compile time: Hoare's concern in 1960s!
- Still much discussion in Ruby community about `nil`-handling patterns

---

# Conclusion

- `nil` handling is a real problem
- think in terms of ethics
- static type systems give one approach
- Ruby can be used in functional or object-oriented style
- we should know and learn from history
- it's not over
- we still have to write correct code

*Franklin Chen*

[`http://franklinchen.com/`](http://franklinchen.com/)

[`franklinchen@franklinchen.com`](mailto:franklinchen@franklinchen.com)
