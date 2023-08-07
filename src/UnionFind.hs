{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE InstanceSigs #-}
-- {-# LANGUAGE UndecidableInstances #-}

module UnionFind where

import Control.Monad.ST
import Data.STRef
import Control.Monad

data Point s a = Pt (STRef s (Chain s a)) 

data Chain s a = Link (Point s a) | Root a 

class StEq m where 
        eq :: (Eq a) => m s a -> m s a -> ST s Bool


instance StEq Point where
        eq (Pt ref1) (Pt ref2) = do
                t1 <- readSTRef ref1 
                t2 <- readSTRef ref2
                eq t1 t2

instance StEq Chain where 
        eq (Link p1) (Link p2) = eq p1 p2 
        eq (Root a) (Root b) = do 
                ref <- newSTRef $ a == b
                readSTRef ref


fresh :: a -> ST s (Point s a)
fresh despr = do 
        pt <- newSTRef (Root despr)
        return (Pt pt)

repr :: Point s a -> ST s (Point s a)
repr point@(Pt ref) = do 
    chain <- readSTRef ref
    case chain of 
        Link npoint -> repr npoint
        Root _ -> return point 

equivalent :: Eq a => Point s a -> Point s a -> ST s Bool
equivalent p1 p2 = do 
        pp1 <- repr p1 
        pp2 <- repr p2 
        eq pp1 pp2

-- register p2 onto p1 
union :: Point s a -> Point s a -> ST s ()
union p1 p2 = do 
        Pt ref1 <- repr p1 
        Pt ref2 <- repr p2 

        -- this works
        writeSTRef ref2 (Link (Pt ref1))

        -- this used to be not working, because of the way to deriving Eq
        -- now this also works!
        -- t1 <- readSTRef ref1 
        -- nref <- newSTRef t1 
        -- writeSTRef ref2 (Link (Pt nref))

tfetch :: Chain s a -> ST s a
tfetch (Root a) = do 
        ref <- newSTRef a
        readSTRef ref

tfetch (Link pt) = fetch pt

fetch :: Point s a -> ST s a
fetch (Pt ref) = do
    r <- readSTRef ref
    tfetch r

