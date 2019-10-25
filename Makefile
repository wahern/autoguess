srcdir=.

all: config-auto config-guess

$(srcdir)/config.h.auto.in $(srcdir)/configure: $(srcdir)/configure.ac $(srcdir)/ag_check_cc.m4
	cd $(srcdir) && ./bootstrap

config.h.auto: $(srcdir)/config.h.auto.in $(srcdir)/configure
	$(srcdir)/configure CC="$(CC)" CFLAGS="$(CFLAGS)" CPPFLAGS="$(CPPFLAGS)"

config-auto: config.c config.h.auto
	cp config.h.auto config.h
	$(CC) -o $@ config.c $(CFLAGS) $(CPPFLAGS)

config-guess: config.c $(srcdir)/config.h.guess
	cp $(srcdir)/config.h.guess config.h
	$(CC) -o $@ config.c -DAG_USE_SYSTEM_EXTENSIONS -DAG_SYS_LARGEFILE $(CPPFLAGS) $(CFLAGS)

config.c: config.h.auto
	-@rm -f $@
	@cat config.h.auto $(srcdir)/config.h.guess | \
	sed -ne 's/^.*\(HAVE_[0-9A-Za-z_]*\).*$$/\1/p' | \
	sort -u | \
	grep -v '_H_$$' | grep -v '_H\(_[A-Z][A-Z]*\)_$$' | grep -v 'ARC4RANDOM_.*_$$' | \
	awk '$$1!~/^HAVE_(__EXTENSIONS__|_ALL_SOURCE|_GNU_SOURCE|_MINIX|_POSIX_PTHREAD_SEMANTICS|_REENTRANT)$$/ { print $$1; }' | \
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
	rm -f *.txt config.c config.h config.h.auto config-auto config-guess

