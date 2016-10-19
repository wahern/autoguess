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
AC_SEARCH_LIBS([sigwait], [pthread])
AC_SEARCH_LIBS([posix_fadvise], [rt])
AC_SEARCH_LIBS([posix_fallocate], [rt])
AC_SEARCH_LIBS([dlopen], [dl])

# Checks for header files.
AC_CHECK_HEADERS([m4_normalize([
	dlfcn.h ifaddrs.h mach/mach.h mach/clock.h mach/mach_time.h
	netinet/in6_var.h port.h pthread.h sys/auxv.h sys/epoll.h
	sys/event.h sys/eventfd.h sys/inotify.h sys/param.h sys/signalfd.h
	sys/sockio.h sys/syscall.h sys/sysctl.h sys/timerfd.h
])])

# Checks for types.
AC_CHECK_TYPES([clockid_t], [], [], [#include <time.h>])

# Checks for structure members.
AC_CHECK_MEMBERS([struct sockaddr.sa_len], [], [], [#include <sys/socket.h>])
AC_CHECK_MEMBERS([struct stat.st_rdev, struct stat.st_blksize, struct stat.st_blocks])
AC_CHECK_MEMBERS([struct stat.st_atim, struct stat.st_mtim, struct stat.st_ctim])
AC_CHECK_MEMBERS([struct stat.st_atimespec, struct stat.st_mtimespec, struct stat.st_ctimespec])

# Checks for symbolic constants.
AC_CHECK_DECLS([CLOCK_MONOTONIC, CLOCK_REALTIME], [], [], [#include <time.h>])
AC_CHECK_DECLS([PTHREAD_MUTEX_ROBUST], [], [], [#include <pthread.h>])
AC_CHECK_DECLS([RANDOM_UUID], [], [], [#include <sys/sysctl.h>])
AC_CHECK_DECLS([SYS_getrandom], [], [], [#include <sys/syscall.h>])

# Checks for library objects.
AC_CHECK_DECLS([__libc_enable_secure])
AC_CHECK_FUNCS([__libc_enable_secure])
AC_CHECK_DECLS([clock_gettime], [], [], [#include <time.h>])
AC_CHECK_FUNCS([clock_gettime])
AC_CHECK_DECLS([program_invocation_short_name], [], [], [#include <errno.h>])
AC_CHECK_FUNCS([program_invocation_short_name])
AC_CHECK_DECLS([sys_siglist], [], [], [#include <signal.h>])
AC_CHECK_FUNCS([sys_siglist])

# Checks for library functions.
AC_CHECK_FUNCS([m4_normalize([
	accept4 arc4random arc4random_addrandom arc4random_buf arc4random_stir
	clock_gettime dladdr dlopen dlsym dup2 dup3 fdopendir epoll_create
	epoll_create1 epoll_ctl epoll_pwait epoll_wait eventfd getauxval
	getenv_r getexecname getifaddrs getprogname inotify_init
	inotify_init1 issetugid kevent kqueue kqueue1 openat paccept pipe2
	port_alert port_associate port_create port_dissociate port_get
	port_getn port_send port_sendn posix_fadvise posix_fallocate
	signalfd sigtimedwait sigwait syscall sysctl timerfd_create
	timerfd_gettime timerfd_settime
])])

# Check for strerror_r and variant.
AC_FUNC_STRERROR_R

AC_OUTPUT
