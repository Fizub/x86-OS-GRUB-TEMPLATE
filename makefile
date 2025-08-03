# Corrected Makefile using $(NAME)/boot structure

NAME = MAS
ISO = $(NAME).iso
KERNEL = kernel

all: $(ISO)

boot.o: boot.s
	nasm -f elf32 $< -o $@

kernel.o: kernel.c
	gcc -m32 -fno-stack-protector -fno-builtin -c $< -o $@

$(KERNEL): boot.o kernel.o linker.ld
	ld -m elf_i386 -T linker.ld -o $@ boot.o kernel.o

$(ISO): $(KERNEL)
	cp $(KERNEL) $(NAME)/boot/$(KERNEL)
	grub-mkrescue -o $@ $(NAME)

run: $(ISO)
	qemu-system-i386 -cdrom $(ISO)

clean:
	rm -f *.o $(KERNEL) $(ISO) $(NAME)/boot/$(KERNEL)

.PHONY: all run clean
