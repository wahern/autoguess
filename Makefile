srcdir=.

# NB: As of 2025-06-10 only macOS 11.0+ targets will be verified (i.e. if
# available in macOS 11.0, then config.h.guess simply tests for __APPLE__)
MACOSX_DEPLOYMENT_TARGET =
CFLAGS.darwin = $(MACOSX_DEPLOYMENT_TARGET:%=-mmacosx-version-min=%)
CFLAGS = $(CFLAGS.$(OS))
CPPFLAGS =

WARN_CFLAGS = -Wno-expansion-to-defined
WARN_CPPFLAGS =

ALL_CFLAGS = $(WARN_CFLAGS) $(CFLAGS) $(MYCFLAGS)
ALL_CPPFLAGS = $(WARN_CPPFLAGS) $(CPPFLAGS) $(MYCPPFLAGS)

all: config-auto config-guess

$(srcdir)/config.h.auto.in $(srcdir)/configure: $(srcdir)/configure.ac $(srcdir)/ag_check_cc.m4
	cd $(srcdir) && ./bootstrap

config.h.auto: $(srcdir)/config.h.auto.in $(srcdir)/configure
	$(srcdir)/configure CC="$(CC)" CFLAGS="$(ALL_CFLAGS)" CPPFLAGS="$(ALL_CPPFLAGS)"

config-auto: config.c config.h.auto
	cp config.h.auto config.h
	$(CC) -o $@ config.c $(ALL_CFLAGS) $(ALL_CPPFLAGS)

config-guess: config.c $(srcdir)/config.h.guess
	cp $(srcdir)/config.h.guess config.h
	$(CC) -o $@ config.c -DAG_USE_SYSTEM_EXTENSIONS -DAG_SYS_LARGEFILE $(ALL_CPPFLAGS) $(ALL_CFLAGS)

config.c: config.h.auto
	-@rm -f $@
	@cat config.h.auto $(srcdir)/config.h.guess | \
	sed -ne 's/^.*\(HAVE_[0-9A-Za-z_]*\).*$$/\1/p' | \
	sed -e " \
		/_H_\$$/d; \
		/_H_[A-Z][A-Z]*_\$$/d; \
		/ARC4RANDOM_.*_\$$/d; \
		/_IFF_\$$/d; \
		/_IFF_[A-Z][A-Z]*_\$$/d; \
	" | \
	sort -u | \
	awk '$$1!~/^HAVE_(__EXTENSIONS__|_ALL_SOURCE|_BSD_SOURCE|_GNU_SOURCE|_MINIX|_POSIX_PTHREAD_SEMANTICS|_REENTRANT)$$/ { print $$1; }' | \
	(cat; printf "STRERROR_R_CHAR_P") | awk ' \
		BEGIN { \
			print "#include \"config.h\""; \
			print ""; \
			print "#include <assert.h>"; \
			print "#include <signal.h>"; \
			print "#include <stdio.h>"; \
			print "#include <time.h>"; \
			print ""; \
			print "#include <fcntl.h>"; \
			print "#if HAVE_PTHREAD_H"; \
			print "#include <pthread.h>"; \
			print "#endif"; \
			print "#if HAVE_SYS_INOTIFY_H"; \
			print "#include <sys/inotify.h>"; \
			print "#endif"; \
			print "#include <sys/socket.h>"; \
			print "#include <sys/stat.h>"; \
			print "#if HAVE_SYS_SYSCALL_H"; \
			print "#include <sys/syscall.h>"; \
			print "#endif"; \
			print "#if HAVE_SYS_SYSCTL_H"; \
			print "#include <sys/sysctl.h>"; \
			print "#endif"; \
			print "#include <unistd.h>"; \
			print "int main(void) {"; } \
		{ \
			print "#if "$$1; \
			print "printf(\""$$1" 1\\n\");"; \
			print "#else"; \
			print "printf(\""$$1" 0\\n\");"; \
			print "#endif"; \
		} \
		END { print "return 0;\n}" } \
	' > $@

config-auto.txt config-guess.txt: config-auto config-guess
	./$(@:.txt=) > $@

check: config-auto.txt config-guess.txt
	@if cmp -s config-auto.txt config-guess.txt; then \
		printf "OK\n"; \
	else \
		diff -u config-auto.txt config-guess.txt; \
		exit 1; \
	fi

clean:
	rm -f config.c config.h config.h.auto config.h.auto.in
	rm -f configure aclocal.m4 config.log config.status
	rm -f config-auto config-auto.txt config-guess config-guess.txt

include $(srcdir)/Makefile.guess.sub
