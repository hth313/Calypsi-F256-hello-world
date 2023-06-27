VPATH = src

# Common source files
ASM_SRCS =
C_SRCS = main.c

# Object files
OBJS = $(ASM_SRCS:%.s=obj/%.o) $(C_SRCS:%.c=obj/%.o)
OBJS_DEBUG = $(ASM_SRCS:%.s=obj/%-debug.o) $(C_SRCS:%.c=obj/%-debug.o)

obj/%.o: %.s
	as6502 --core=65c02 --target=foenix --list-file=$(@:%.o=%.lst) -o $@ $<

obj/%.o: %.c
	cc6502 --core=65c02 --target=foenix -O2 --list-file=$(@:%.o=%.lst) -o $@ $<

obj/%-debug.o: %.s
	as6502 --core=65c02 --target=foenix --debug --list-file=$(@:%.o=%.lst) -o $@ $<

obj/%-debug.o: %.c
	cc6502 --core=65c02 --target=foenix --debug --list-file=$(@:%.o=%.lst) -o $@ $<

hello.pgz:  $(OBJS)
	ln6502 -o $@ $^ --target=foenix f256-plain.scm  --output-format=pgz --list-file=hello.lst --rtattr cstartup=tinycore --cstack-size=512 --force-output

hello.elf: $(OBJS_DEBUG)
	ln6502 --debug -o $@ $^ --target=foenix f256-plain.scm --list-file=hello-debug.lst --semi-hosted --rtattr cstartup=tinycore  --cstack-size=512

clean:
	-rm $(OBJS) $(OBJS:%.o=%.lst) $(OBJS_DEBUG) $(OBJS_DEBUG:%.o=%.lst) $(C64_LIB)
	-rm hello.elf hello.pgz hello-debug.lst
