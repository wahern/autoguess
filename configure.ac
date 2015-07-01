# Redefine AH_TEMPLATE so that feature macros can be overridden from CPPFLAGS
m4_define([AH_TEMPLATE],
[AH_VERBATIM([$1],
	m4_text_wrap([$2 */], [   ], [/* ])[
@%:@ifndef ]_m4_expand([$1])[
@%:@undef ]_m4_expand([$1])[
@%:@endif])])

# Initialize autoconf
AC_PREREQ([2.69])
AC_INIT([autoguess], m4_esyscmd_s([grep AG_VERSION config.h.guess | cut -d' ' -f3]), [william+autoguess@25thandClement.com])
AC_CONFIG_SRCDIR([config.h.guess])
AC_CONFIG_HEADERS([config.h.auto])

# Checks for programs.
AC_PROG_CC

# Define _GNU_SOURCE, __EXTENSIONS__, _POSIX_PTHREAD_SEMANTICS, etc.
AC_USE_SYSTEM_EXTENSIONS

# Largefile support
AC_SYS_LARGEFILE

# Checks for libraries.
AC_SEARCH_LIBS([clock_gettime], [rt])
AC_SEARCH_LIBS([sigtimedwait], [rt])
AC_SEARCH_LIBS([posix_fadvise], [rt])
AC_SEARCH_LIBS([posix_fallocate], [rt])
AC_SEARCH_LIBS([dlopen], [dl])

# Checks for header files.
AC_CHECK_HEADERS([ \
	dlfcn.h ifaddrs.h mach/mach.h mach/clock.h mach/mach_time.h \
	netinet/in6_var.h sys/event.h sys/feature_tests.h sys/param.h \
	sys/sockio.h sys/sysctl.h \
])

# Checks for structure members
AC_CHECK_MEMBERS([struct stat.st_rdev, struct stat.st_blksize, struct stat.st_blocks])
AC_CHECK_MEMBERS([struct stat.st_atim, struct stat.st_mtim, struct stat.st_ctim])
AC_CHECK_MEMBERS([struct stat.st_atimespec, struct stat.st_mtimespec, struct stat.st_ctimespec])

# Checks for library objects.
AC_CHECK_DECLS([sys_siglist], [], [], [[#include <signal.h>]])
AC_CHECK_DECLS([__libc_enable_secure])
AC_CHECK_DECLS([program_invocation_short_name])

# Checks for library functions.
AC_CHECK_FUNCS([ \
	arc4random arc4random_addrandom arc4random_stir clock_gettime dladdr \
	dlsym dlopen dup2 dup3 fdopendir dup2 dup3 getauxval getenv_r \
	getexecname getifaddrs getprogname issetugid kevent kqueue kqueue1 \
	pipe2 posix_fadvise posix_fallocate sigtimedwait sigwait sysctl \
])

# Check for strerror_r and variant
AC_FUNC_STRERROR_R

AC_MSG_CHECKING([for __attribute__((unused)) support])
AC_LINK_IFELSE([AC_LANG_PROGRAM([],[int i __attribute__((unused));])], [
	AC_DEFINE([HAVE_C___ATTRIBUTE___UNUSED], [1], [Define to 1 if compiler supports __attribute__((unused))])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_MSG_CHECKING([for __attribute__((visibility)) support])
AC_LINK_IFELSE([AC_LANG_PROGRAM([int i __attribute__((visibility("hidden")));], [])], [
	AC_DEFINE([HAVE_C___ATTRIBUTE___VISIBILITY], [1], [Define to 1 if compiler supports __attribute__((visibility))])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_MSG_CHECKING([for __extension__ annotation support])
AC_LINK_IFELSE([AC_LANG_PROGRAM([],[return __extension__ 0;])], [
	AC_DEFINE([HAVE_C___EXTENSION__], [1], [Define to 1 if compiler supports __extension__ annotation])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_MSG_CHECKING([for __has_extension support])
AC_LINK_IFELSE([
	AC_LANG_PROGRAM([],[
		#if !__has_extension(c_alignas)
		#error nope
		#endif
	])
], [
	AC_DEFINE([HAVE_C___HAS_EXTENSION], [1], [Define to 1 if compiler supports __has_extension])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_MSG_CHECKING([for __has_include support])
AC_LINK_IFELSE([
	AC_LANG_PROGRAM([],[
		#if !__has_include(<stdint.h>)
		#error nope
		#endif
	])
], [
	AC_DEFINE([HAVE_C___HAS_INCLUDE], [1], [Define to 1 if compiler supports __has_include])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_MSG_CHECKING([for C11 _Generic expression support])
AC_LINK_IFELSE([
	AC_LANG_PROGRAM([],[
		long T = -1;
		int a@<:@_Generic(T, default: -1, long: 1)@:>@ = { 0 }; 
		return a@<:@0@:>@;
	])
], [
	AC_DEFINE([HAVE_C__GENERIC], [1], [Define to 1 if compiler supports C11 _Generic expressions])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_MSG_CHECKING([for statement expression support])
AC_LINK_IFELSE([AC_LANG_PROGRAM([],[return ({ 1; });])], [
	AC_DEFINE([HAVE_C_STATEMENT_EXPRESSION], [1], [Define to 1 if compiler supports statement expressions])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_MSG_CHECKING([for __builtin_trap])
AC_LINK_IFELSE([AC_LANG_PROGRAM([],[__builtin_trap()])], [
	AC_DEFINE([HAVE___BUILTIN_TRAP], [1], [Define to 1 if compiler supports __builtin_trap])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_MSG_CHECKING([for __builtin_unreachable])
AC_LINK_IFELSE([AC_LANG_PROGRAM([],[__builtin_unreachable()])], [
	AC_DEFINE([HAVE___BUILTIN_UNREACHABLE], [1], [Define to 1 if compiler supports __builtin_unreachable])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_MSG_CHECKING([for _Static_assert])
AC_LINK_IFELSE([AC_LANG_PROGRAM([],[_Static_assert(1, "OK")])], [
	AC_DEFINE([HAVE__STATIC_ASSERT], [1], [Define to 1 if compiler supports _Static_assert])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_OUTPUT
