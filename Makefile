srcdir=.

all: config-auto config-guess

$(srcdir)/config.h.auto.in: $(srcdir)/configure.ac
	cd $(srcdir) && ./bootstrap

config.h.auto: $(srcdir)/config.h.auto.in
	$(srcdir)/configure

config-auto: config.c config.h.auto
	cp config.h.auto config.h
	$(CC) -o $@ config.c

config-guess: config.c $(srcdir)/config.h.guess
	cp $(srcdir)/config.h.guess config.h
	$(CC) -o $@ config.c

config.c: config.h.auto
	@cat config.h.auto $(srcdir)/config.h.guess | \
	sed -ne 's/^.*\(HAVE_[0-9A-Za-z_]*\).*$$/\1/p' | \
	sort -u | grep -v '_$$' | awk ' \
		BEGIN { print "#include \"config.h\"\n#include <stdio.h>\nint main(void) {"; } \
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

clean:
	$(RM) *.txt config.c config.h config-auto config-guess

