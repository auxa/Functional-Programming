module Paths_lab00 (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/joseph/Desktop/CS3016-1617/Lab00/.stack-work/install/x86_64-linux/lts-6.19/7.10.3/bin"
libdir     = "/home/joseph/Desktop/CS3016-1617/Lab00/.stack-work/install/x86_64-linux/lts-6.19/7.10.3/lib/x86_64-linux-ghc-7.10.3/lab00-0.1.0.0-CCT3Q5Tmz5d5lI5iAcNqTq"
datadir    = "/home/joseph/Desktop/CS3016-1617/Lab00/.stack-work/install/x86_64-linux/lts-6.19/7.10.3/share/x86_64-linux-ghc-7.10.3/lab00-0.1.0.0"
libexecdir = "/home/joseph/Desktop/CS3016-1617/Lab00/.stack-work/install/x86_64-linux/lts-6.19/7.10.3/libexec"
sysconfdir = "/home/joseph/Desktop/CS3016-1617/Lab00/.stack-work/install/x86_64-linux/lts-6.19/7.10.3/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "lab00_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "lab00_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "lab00_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "lab00_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "lab00_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
