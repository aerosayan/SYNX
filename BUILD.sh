#!/bin/bash

nasm -f bin src/bootloader/bootsector.asm -i src/bootloader/ -o build/synx.bin

