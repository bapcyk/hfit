import Utils
import System.IO
import Control.Monad
import System.Process
import Control.Concurrent
import System.Exit (exitSuccess)
import System.IO.Error (catchIOError)



wish = "wish.exe"


-- 2D point
type Coord = Integer
type Pt = (Coord, Coord)


-- Least squares sums items 
data LSISums = LSISums {
  x_i      :: Coord
, y_i      :: Coord
, x_i_y_i  :: Coord
, x_i_2    :: Coord
} deriving Show


zeroLSISums :: LSISums
zeroLSISums = LSISums 0 0 0 0

-- Combining function (in fold) when iterate over (xi, yi) - calculating sums
nextLSISums :: LSISums -> Pt -> LSISums
nextLSISums s pt =
  s {
    x_i = (x_i s) + x
  , y_i = (y_i s) + y
  , x_i_y_i = (x_i_y_i s) + (x*y)
  , x_i_2 = (x_i_2 s) + (x*x)
  } where x = fst pt; y = snd pt


-- Parse ["12", "34", "56", "78"] to [(12, 34), (56, 78)]
parsePt :: [String] -> [Pt]
parsePt [] = []
parsePt (k:v:t) = (read k, read v) : parsePt t


-- callback on UI call "calc x0 y0 x1 y1 ... xn yn" -> "takeCalc x0 y0 x1 y1", where
-- returned coords describes 2 point of calculated line
calc :: String -> String
calc str =
  let coords = tail $ words str
      points = parsePt coords
      min_x = minimum $ map fst points
      max_x = maximum $ map fst points
      n = toInteger $ length points
      s = foldl nextLSISums zeroLSISums points
      a_n = fromInteger (n * (x_i_y_i s) - (x_i s) * (y_i s)) :: Double
      a_d = fromInteger (n * (x_i_2 s) - (x_i s) * (x_i s)) :: Double
      a = round $ a_n / a_d
      b_n = fromInteger ((y_i s) - a * (x_i s)) :: Double
      b_d = fromInteger n :: Double
      b = round $ b_n / b_d
      line = \x -> a * x + b
      showCoord = \c -> " " ++ (show c) ++ " "
  in
  "takeCalc" ++ (showCoord min_x) ++ (showCoord $ line min_x)
             ++ (showCoord max_x) ++ (showCoord $ line max_x)


---------------------- MAIN ---------------------------
main = do
  mainTcl <- readFile "ui.tcl"
  (Just si, Just so, Just sx, ph) <- createProcess (proc wish []) {
    std_in=CreatePipe, std_out=CreatePipe, std_err=CreatePipe, close_fds=False}
  hSetBuffering si NoBuffering
  hSetBuffering so NoBuffering
  hPutStrLn si mainTcl
  forkIO $ ioLoop si so
  waitForProcess ph
  putStrLn "bye."
  where
    ioLoop si so = forever $ do
        resp <- (hGetLine so) `catchIOError` (\_ -> return "eof")
        case resp of
          "eof" -> exitSuccess
          _|resp `startsWith` "calc " ->
            putStrLn ("-> " ++ resp) >> 
            let res = calc resp in
            putStrLn ("<- " ++ res) >> hPutStrLn si res
          _ -> putStrLn resp >> return ()
