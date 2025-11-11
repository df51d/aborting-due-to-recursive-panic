I am trying to make this code work, but getting 'aborting due to recursive panic' error.

You can comment out use_llvm in build.zig (both dl/exe) and it is panicking with same error

This is secondary issue, which I encounter when trying to make a minimal repro of the my 

primal issue which is same as/related to https://github.com/ziglang/zig/issues/25026
