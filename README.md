# SYNX
A cute little toy OS.

# BUILD INSTRUCTIONS
Working towards setting up a CMake build system.
For now, only custom commands are allowed.

``` 
$ mkdir build
$ cd build
$ nasm -f bin ../src/bootloader/bootsector.asm -o synx.img
$ qemu-system-x86_64 synx.img
```

# DEV INSTRUCTIONS
You can also analyse the flat binary files produced using xxd or ndisasm.
