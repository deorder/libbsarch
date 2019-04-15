# BSArchive DLL and C++ bindings
BSArchive Dynamic Link Library and C++ bindings

## How to build

1) Create a `XEditPath` environment variable and set it to the directory containing the XEdit code
2) Build the DLL in Delphi by opening the `libbsarch.dproj` project
3) Build the LIB in Visual Studio by opening the `libbsarch.sln` project

## How to use

Use the `libbsarch.dll` (The one created by Delphi, not Visual Studio), `libbsarch.lib` and `libbsarch.h` in your project.

## Credits

The original BSArchive can be found at: https://github.com/TES5Edit/TES5Edit/tree/dev/Tools/BSArchive
The version in this project had been modified for better compatibility with C/C++ and allow the users to allocate their own memory in some cases.
