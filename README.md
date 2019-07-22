# SYNX
A cute little toy OS.

# BUILD INSTRUCTIONS
Working towards setting up a CMake build system.
For now, only custom commands are allowed.

```
$ mkdir build
$ cd build
$ nasm -f bin ../src/bootloader/bootsector.asm -i../src/bootloader/ -o synx.bin
$ qemu-system-x86_64 synx.bin
```
Note that -f bin makes the bootsector to be in raw binary form.
And -i is neccessary to make use of %include directive to include seperate
asm files in the project.


# DEV INSTRUCTIONS
You can also analyse the flat binary files produced using xxd or ndisasm.
