PREFIX?=/usr
LIBNAME=liblinenoise.a
AR?=ar
RANLIB?=ranlib
CFLAGS?=-Wall -W -Os -g

all: $(LIBNAME) linenoise_example

$(LIBNAME): linenoise.o
	$(AR) rcs $(LIBNAME) linenoise.o
	$(RANLIB) $(LIBNAME) >/dev/null 2>&1 || true

linenoise.o: linenoise.c linenoise.h
	$(CC) $(CFLAGS) -c linenoise.c -o linenoise.o

linenoise_example: linenoise.c example.c linenoise.h $(LIBNAME)
	$(CC) $(CFLAGS) -o linenoise_example linenoise.c example.c

install: $(LIBNAME) linenoise.h
	mkdir -p $(DESTDIR)$(PREFIX)/include
	mkdir -p $(DESTDIR)$(PREFIX)/lib
	install -m 644 linenoise.h $(DESTDIR)$(PREFIX)/include/
	install -m 644 $(LIBNAME) $(DESTDIR)$(PREFIX)/lib/

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/include/linenoise.h
	rm -f $(DESTDIR)$(PREFIX)/lib/$(LIBNAME)

clean:
	rm -f linenoise_example $(LIBNAME) linenoise.o

.PHONY: all clean install uninstall
