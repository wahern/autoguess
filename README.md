## Introduction

This project maintains a config.h-like header that implements feature
detection solely via the preprocessor. It targets recent versions of
DragonFly BSD, FreeBSD, Linux/glibc, Linux/musl, NetBSD, macOS, OpenBSD, and
Solaris; and recent versions of GCC, clang, and Oracle Developer Studio.
(AIX support is frozen at 7.1 and not presently updated since the loss of
Polar Home's AIX environment.) The source should compile on other platforms
and compilers, though with a greater chance of feature false negatives and
false positives.

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

* ```AG_USE_SYSTEM_EXTENSIONS``` - If defined and non-0 attempts to expose
system extensions in the same manner as AC_USE_SYSTEM_EXTENSIONS.

* ```AG_SYS_LARGEFILE``` - If defined and non-0, attempts to _select_ the
64-bit file API in the same manner as AC_SYS_LARGEFILE.

### Preprocessor Conditionals

Unlike the default style in autoconf the feature macros in
```config.h.guess``` are _always_ defined. This is for two reasons:

* To avoid polluting the namespace unnecessarily some feature tests rely on
the application including the relevent header in order for the test to work.
However, ```config.h``` typically must be included _before_ any other system
header so that system extensions and largefile support can be enabled. This
means evaluation of the feature predicates must be delayed until actually
used by the application code when the relevant headers have already been
included. (See [-Wexpansion-to-defined](#-wexpansion-to-defined) below.)

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

### -Wexpansion-to-defined

```config.h``` is traditionally included in a source file _before_ any
system headers so that it may enable/disable API personalities (see
```AG_USE_SYSTEM_EXTENSIONS``` and ```AG_SYS_LARGEFILE``` above). However,
some feature tests test the existence of particular macro definitions. To
resolve this ordering dilemma without implicitly ```include```'ing
unnecessary and unused platform headers, these feature tests inline the
```defined``` operator for lazy evaluation at the point of use, after any
required headers have been explicitly included by the source file.

Technically, macro expansions that generate ```defined``` operator
expressions constitute undefined behavior in ISO C. Support for this usage
as an extension is widespread; universal across Unix compilers. None of
these compilers issued a diganostic for this usage in typical compilation
environments (e.g. GCC requires ```-pedantic``` regardless of ```-std=```);
not until clang 3.9 added ```-Wexpansion-to-defined``` as part of
```-Wall```.
(Microsoft Visual Studio is the exception, at least for object-like macros.
See [this thread](https://bugs.webkit.org/show_bug.cgi?id=167643) discussing
Visual Studio's different behaviors between function-like and object-like
macros.)

Unfortunately, there's no other way around the ordering dilemma between
feature test definition and system header inclusion. Nor is there a way to
silence this diagnostic for feature tests without effecting the entire
compilation unit.

Going forward efforts will be made to minimize reliance on this behavior. In
the meantime, users should either explicitly disable their compiler's
```-Wexpansion-to-defined``` diagnostic, or abstain from using those feature
tests which rely on inline ```defined``` operator expansions. Note that it's
only the expansion which is undefined behavior, not the mere definition of
such a macro.
