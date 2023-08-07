module Main where
import UnionFind
import Control.Monad.ST

main :: IO ()
main = do 
    let compair = runST $ do 
            a <- fresh "a"
            b <- fresh "b"
            union a b 
            equivalent a b

    print compair