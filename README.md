## Introduction

This project maintains a config.h-like header that implements feature
detection solely via the preprocessor. It's regularly tested on recent
versions of AIX, FreeBSD, Linux/glibc, Linux/musl, NetBSD, Minix, OpenBSD,
and Solaris. Although not all feature tests are guaranteed to work on all
tested platforms.

## Usage

The file```config.h.guess``` is intended to be copied and included as
```config.h``` as part of a project build in place of an autoconf-generated
version. I _personally_ prefer using autoconf to generate ```config.h```,
but often autoconf is impractical or inconvenient either for the developer
or at build-time.

All the other files in this repository are principally for regression
testing. ```ag_check_cc.m4``` is suitable for inclusion in autoconf-based
projects if desired, and includes various compiler feature tests not
included with autoconf.

### Selecting APIs

There are two optional defines:

* ```AG_USE_SYSTEM_EXTENSION``` - If defined and non-0 attempts to expose
system extensions in the same manner as AC_USE_SYSTEM_EXTENSIONS.

* ```AG_SYS_LARGEFILE``` - If defined and non-0, attempts to _select_ the
64-bit file API in the same manner as AC_SYS_LARGEFILE.

### Preprocessor Conditionals

Unlike the default style in autoconf the feature macros in
```config.h.guess``` are _always_ defined. This is for two reasons:

* To avoid polluting the namespace unnecessarily some features tests rely on
the application including the relevent header in order for the test to work.
However, ```config.h``` typically must be included _before_ any other system
header so that system extensions and largefile support can be enabled. This
means evaluation of the feature predicates must be delayed until actually
used by the application code when the relevant headers have already been
included.

* So that feature tests may be overriden from compiler flags. For example,
to override a positive feature test one can specify -DHAVE_FOO=0. Specifying
-UHAVE_FOO would not work.

To get the same behavior from autoconf paste the following to your
```configure.ac``` file:

```
	m4_define([AH_TEMPLATE],
	[AH_VERBATIM([$1],
		m4_text_wrap([$2 */], [   ], [/* ])[
	@%:@ifndef ]_m4_expand([$1])[
	@%:@undef ]_m4_expand([$1])[
	@%:@endif])])
```
