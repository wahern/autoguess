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
AC_CONFIG_MACRO_DIR([.])
AC_CONFIG_SRCDIR([config.h.guess])
AC_CONFIG_HEADERS([config.h.auto])

# Checks for programs.
AC_PROG_CC

# Define _GNU_SOURCE, __EXTENSIONS__, _POSIX_PTHREAD_SEMANTICS, etc.
AC_ARG_ENABLE([extensions], [  --disable-extensions    expose system extensions])
if test "$enable_extensions" != no; then
	AC_USE_SYSTEM_EXTENSIONS
fi

# Largefile support
AC_SYS_LARGEFILE

# Check for various compiler features.
AG_CHECK_CC

# Checks for libraries.
AC_SEARCH_LIBS([clock_gettime], [rt])
AC_SEARCH_LIBS([sigtimedwait], [rt])
AC_SEARCH_LIBS([posix_fadvise], [rt])
AC_SEARCH_LIBS([posix_fallocate], [rt])
AC_SEARCH_LIBS([dlopen], [dl])

# Checks for header files.
AC_CHECK_HEADERS([m4_normalize([
	dlfcn.h ifaddrs.h mach/mach.h mach/clock.h mach/mach_time.h
	netinet/in6_var.h port.h sys/auxv.h sys/epoll.h sys/event.h
	sys/eventfd.h sys/inotify.h sys/param.h pthread.h sys/signalfd.h
	sys/sockio.h sys/sysctl.h sys/timerfd.h
])])

# Checks for structure members
AC_CHECK_MEMBERS([struct sockaddr.sa_len], [], [], [#include <sys/socket.h>])
AC_CHECK_MEMBERS([struct stat.st_rdev, struct stat.st_blksize, struct stat.st_blocks])
AC_CHECK_MEMBERS([struct stat.st_atim, struct stat.st_mtim, struct stat.st_ctim])
AC_CHECK_MEMBERS([struct stat.st_atimespec, struct stat.st_mtimespec, struct stat.st_ctimespec])

# Checks for library objects.
AC_CHECK_DECLS([__libc_enable_secure])
AC_CHECK_FUNCS([__libc_enable_secure])
AC_CHECK_DECLS([sys_siglist], [], [], [#include <signal.h>])
AC_CHECK_FUNCS([sys_siglist])
AC_CHECK_DECLS([program_invocation_short_name], [], [], [#include <errno.h>])
AC_CHECK_FUNCS([program_invocation_short_name])
AC_CHECK_DECLS([PTHREAD_MUTEX_ROBUST], [], [], [#include <pthread.h>])

# Checks for library functions.
AC_CHECK_FUNCS([m4_normalize([
	accept4 arc4random arc4random_addrandom arc4random_stir
	clock_gettime dladdr dlopen dlsym dup2 dup3 fdopendir epoll_create
	epoll_create1 epoll_ctl epoll_pwait epoll_wait eventfd getauxval
	getenv_r getexecname getifaddrs getprogname inotify_init
	inotify_init1 issetugid kevent kqueue kqueue1 paccept pipe2
	port_alert port_associate port_create port_dissociate port_get
	port_getn port_send port_sendn posix_fadvise posix_fallocate
	signalfd sigtimedwait sigwait sysctl timerfd_create timerfd_gettime
	timerfd_settime
])])

# Check for strerror_r and variant
AC_FUNC_STRERROR_R

# Check for _Static_assert and static_assert
AC_DEFUN([AX_CHECK_STATIC_ASSERT_BODY], [
	AS_VAR_PUSHDEF([ac_Symbol], [AS_TR_SH([ac_cv_$1])])
	AC_CACHE_CHECK([for $1], [ac_Symbol], [
		AC_LINK_IFELSE([
			AC_LANG_PROGRAM([$4],[[
				$1(1, "");
				return 0;
			]])
		], [AS_VAR_SET([ac_Symbol], [yes])], [AS_VAR_SET([ac_Symbol], [no])])
	])
	AS_VAR_IF([ac_Symbol], [yes], [AC_DEFINE(AS_TR_CPP([HAVE_$1]), [1], [Define to 1 if have $1.])])
	AS_VAR_IF([ac_Symbol], [yes], [$2], [$3])
	AS_VAR_POPDEF([ac_Symbol])
])

AC_DEFUN([AX_CHECK_STATIC_ASSERT], [
	AX_CHECK_STATIC_ASSERT_BODY([static_assert],[],[],[#include <assert.h>])
	AX_CHECK_STATIC_ASSERT_BODY([_Static_assert],[],[],[])
])

AX_CHECK_STATIC_ASSERT

AC_OUTPUT
