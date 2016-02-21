module Utils (
  startsWith
) where


startsWith :: Eq a => [a] -> [a] -> Bool
startsWith _ [] = True
startsWith [] _ = False
startsWith a b = and $ zipWith (==) b a

