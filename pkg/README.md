# Packages

This dir contains packages for this projects. Packages are C/C++ or Zig code that contains a `build.zig` file, and hence can be add to dependencies .

It is a good idea to wrap a C/C++ code with zig code here. Instead of using external C/C++ libraries diractly, using some zig code to wrap or bridge C/C++ code can hide complexity, improves readablity, make source code more fit Zig Zen, and most importantly reduce buges.

## Reference 
More example can look at:
ghosty: https://github.com/ghostty-org/ghostty/tree/main/pkg