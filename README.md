### introduction:
A `haskell` implementation of union-find data structure based on ST Monad.

It mainly follows this [union-find](https://github.com/nominolo/union-find) repository. More specifically, the `src/Data/UnionFind/ST.hs` file in it. 

However, I do have some modifications:
  1. the `Root a` constructor in `Chain s a` datatype does not depend on `s` state, while in `union-find` repository, the related data type `Link s a` has constructor `Info {-# UNPACK #-} !(STRef s (Info a))` where `STRef s` is actually not necessary.
  2. I create `StEq` typelcass with `eq` function to handle the equality check (`==` symbol) of `Point` and `Chain` datatype, this is because they are always in an `ST s` monad and the normal `(==)` function does not fit in this type signature. In `union-find` repository, such a treatment does not exist, and it has resulted in a weird bug(as I believe). 

### to test:

run `cabal test`

It will run `test/Main.hs` for testing
