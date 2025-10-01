PREFIX?=/usr
MAJOR=1
MINOR=0
PATCH=0
SONAME=liblinenoise.so.$(MAJOR)
FULLVER=liblinenoise.so.$(MAJOR).$(MINOR).$(PATCH)
STATIC=liblinenoise.a
AR?=ar
RANLIB?=ranlib
CFLAGS?=-Wall -W -Os -g -fPIC
LDFLAGS_SO?=-shared -Wl,-soname,$(SONAME)

all: $(FULLVER) symlink

# Object file
linenoise.o: linenoise.c linenoise.h
	$(CC) $(CFLAGS) -c linenoise.c -o linenoise.o

# Shared library
$(FULLVER): linenoise.o
	$(CC) $(LDFLAGS_SO) -o $(FULLVER) linenoise.o

symlink: $(FULLVER)
	ln -sf $(FULLVER) $(SONAME)
	ln -sf $(SONAME) liblinenoise.so

# Optional static library (not built by default) make static
static: linenoise.o
	$(AR) rcs $(STATIC) linenoise.o
	$(RANLIB) $(STATIC) >/dev/null 2>&1 || true

# Optional example build: make example
example: linenoise.c example.c linenoise.h
	$(CC) $(CFLAGS) -o linenoise_example linenoise.c example.c

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/include
	mkdir -p $(DESTDIR)$(PREFIX)/lib
	install -m 644 linenoise.h $(DESTDIR)$(PREFIX)/include/
	install -m 755 $(FULLVER) $(DESTDIR)$(PREFIX)/lib/
	ln -sf $(FULLVER) $(DESTDIR)$(PREFIX)/lib/$(SONAME)
	ln -sf $(SONAME) $(DESTDIR)$(PREFIX)/lib/liblinenoise.so

install-static: static install
	install -m 644 $(STATIC) $(DESTDIR)$(PREFIX)/lib/

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/include/linenoise.h
	rm -f $(DESTDIR)$(PREFIX)/lib/$(FULLVER) \
	       $(DESTDIR)$(PREFIX)/lib/$(SONAME) \
	       $(DESTDIR)$(PREFIX)/lib/liblinenoise.so \
	       $(DESTDIR)$(PREFIX)/lib/$(STATIC)

clean:
	rm -f linenoise_example $(FULLVER) $(SONAME) liblinenoise.so $(STATIC) linenoise.o

.PHONY: all clean install uninstall example static install-static symlink
