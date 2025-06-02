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
AC_CHECK_HEADERS(m4_normalize([
	dlfcn.h
	ifaddrs.h
	mach/mach.h
	mach/clock.h
	mach/mach_time.h
	memory.h
	netinet/in6_var.h
	port.h
	pthread.h
	stdio.h
	sys/auxv.h
	sys/epoll.h
	sys/event.h
	sys/eventfd.h
	sys/inotify.h
	sys/param.h
	sys/random.h
	sys/signalfd.h
	sys/sockio.h
	sys/syscall.h
	sys/sysctl.h
	sys/timerfd.h
	wchar.h
]))

# Checks for types.
AC_CHECK_TYPES([clockid_t], [], [], [#include <time.h>])

# Checks for structure members.
AC_CHECK_MEMBERS([struct sockaddr.sa_len], [], [], [#include <sys/socket.h>])
AC_CHECK_MEMBERS([struct stat.st_rdev, struct stat.st_blksize, struct stat.st_blocks])
AC_CHECK_MEMBERS([struct stat.st_atim, struct stat.st_mtim, struct stat.st_ctim])
AC_CHECK_MEMBERS([struct stat.st_atimespec, struct stat.st_mtimespec, struct stat.st_ctimespec])

# Checks for symbolic constants.
AC_CHECK_DECLS([CLOCK_MONOTONIC, CLOCK_REALTIME], [], [], [#include <time.h>])
AC_CHECK_DECLS([EPOLL_CLOEXEC], [], [], [#include <sys/epoll.h>])
AC_CHECK_DECLS([IN_CLOEXEC], [], [], [#include <sys/inotify.h>])
AC_CHECK_DECLS([POSIX_FADV_NORMAL], [], [], [#include <fcntl.h>])
AC_CHECK_DECLS([PTHREAD_MUTEX_ROBUST], [], [], [#include <pthread.h>])
AC_CHECK_DECLS([RANDOM_UUID], [], [], [#include <sys/sysctl.h>])
AC_CHECK_DECLS([SOCK_CLOEXEC], [], [], [#include <sys/socket.h>])
AC_CHECK_DECLS([SYS_getentropy], [], [], [#include <sys/syscall.h>])
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
AC_CHECK_FUNCS(m4_normalize([
	accept4
	arc4random
	arc4random_addrandom
	arc4random_buf
	arc4random_stir
	clock_gettime
	consttime_memequal
	dladdr
	dlopen
	dlsym
	dup2
	dup3
	fdopendir
	epoll_create
	epoll_create1
	epoll_ctl
	epoll_pwait
	epoll_wait
	eventfd
	explicit_bzero
	explicit_memset
	getauxval
	getentropy
	getenv_r
	getexecname
	getifaddrs
	getprogname
	getrandom
	fstatat
	inotify_init
	inotify_init1
	issetugid
	kevent
	kqueue
	kqueue1
	memset_s
	mkdirat
	openat
	paccept
	pipe2
	port_alert
	port_associate
	port_create
	port_dissociate
	port_get
	port_getn
	port_send
	port_sendn
	posix_fadvise
	posix_fallocate
	readlinkat
	renameat
	signalfd
	sigtimedwait
	sigwait
	strlcat
	strlcpy
	symlinkat
	syscall
	sysctl
	timerfd_create
	timerfd_gettime
	timerfd_settime
	timingsafe_bcmp
	timingsafe_memcmp
	unlinkat
]))

# Check for strerror_r and variant.
AC_FUNC_STRERROR_R

# Checks for library functions that require special treatment.
#
# Mostly for handling backward macOS compatibility; avoiding false positives
# when relying on -mmacosx-version-min with SDKs newer than the minimum
# version specific, where SDK linking may succeed despite the version
# request. See https://smallhacks.wordpress.com/2018/11/11/how-to-support-old-osx-version-with-a-recent-xcode/
AC_MSG_CHECKING([for fmemopen])
AC_LINK_IFELSE([AC_LANG_PROGRAM([[#include <stdio.h>]], [[
	#if __APPLE__
	#pragma GCC diagnostic error "-Wpartial-availability"
	#endif
	char buf[100];
	return (0 != fmemopen(buf, sizeof buf, "w"))? 0 : 1;
]])], [
	AC_DEFINE([HAVE_FMEMOPEN], [1], [Define if fmemopen exists.])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_MSG_CHECKING([for mkfifoat])
AC_LINK_IFELSE([AC_LANG_PROGRAM([[#include <sys/stat.h>]], [[
	#if __APPLE__
	#pragma GCC diagnostic error "-Wpartial-availability"
	#endif
	return (0 == mkfifoat(-1, "nonexistent", 0666))? 0 : 1;
]])], [
	AC_DEFINE([HAVE_MKFIFOAT], [1], [Define if mkfifoat exists.])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_MSG_CHECKING([for open_memstream])
AC_LINK_IFELSE([AC_LANG_PROGRAM([[#include <stdio.h>]], [[
	#if __APPLE__
	#pragma GCC diagnostic error "-Wpartial-availability"
	#endif
	char *buf = NULL;
	size_t bufsiz = 0;
	return (0 != open_memstream(&buf, &bufsiz))? 0 : 1;
]])], [
	AC_DEFINE([HAVE_OPEN_MEMSTREAM], [1], [Define if open_memstream exists.])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_OUTPUT
