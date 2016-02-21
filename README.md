# hfit

Fitting of lines, etc
=====================

This is test program for fitting algorithms in Haskell. At the moment is
implemented only line fitting with "Least Squares" algorithm. As UI is
used Tcl/Tk (ran wish.exe interpreter), all commands are sending to Tcl/Tk
interpreter and getting as lines back. Program works in Win32 but must
works (after recompilation sure) in Linux/Mac too.

Known issues
============

It's very simple implementation with some bugs - not all quadrants seems
to work good. Also L.S. is simplest algorithm so there is some error on
noise points.
