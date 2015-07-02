AC_DEFUN([AG_CHECK_CC], [

AC_MSG_CHECKING([for __attribute__((nonnull)) support])
AC_LINK_IFELSE([AC_LANG_PROGRAM([int f(void *p) __attribute__((nonnull (1)));], [return 0;])], [
	AC_DEFINE([HAVE_C___ATTRIBUTE___NONNULL], [1], [Define to 1 if compiler supports __attribute__((nonnull))])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

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

AC_MSG_CHECKING([for __extension__ annotation support])
AC_LINK_IFELSE([AC_LANG_PROGRAM([],[return __extension__ 0;])], [
	AC_DEFINE([HAVE_C___EXTENSION__], [1], [Define to 1 if compiler supports __extension__ annotation])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_MSG_CHECKING([for __typeof support])
AC_LINK_IFELSE([AC_LANG_PROGRAM([],[int i = -1; __typeof(i) j = -1;])], [
	AC_DEFINE([HAVE_C___TYPEOF], [1], [Define to 1 if compiler supports __typeof])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_MSG_CHECKING([for __typeof__ support])
AC_LINK_IFELSE([AC_LANG_PROGRAM([],[int i = -1; __typeof__(i) j = -1;])], [
	AC_DEFINE([HAVE_C___TYPEOF__], [1], [Define to 1 if compiler supports __typeof__])
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

AC_MSG_CHECKING([for typeof support])
AC_LINK_IFELSE([AC_LANG_PROGRAM([],[int i = -1; typeof(i) j = -1;])], [
	AC_DEFINE([HAVE_C_TYPEOF], [1], [Define to 1 if compiler supports typeof])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_MSG_CHECKING([for __atomic_fetch_add])
AC_LINK_IFELSE([AC_LANG_PROGRAM([],[int i = 0; __atomic_fetch_add(&i, 1, __ATOMIC_RELAXED);])], [
	AC_DEFINE([HAVE___ATOMIC_FETCH_ADD], [1], [Define to 1 if compiler supports __atomic_fetch_add])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_MSG_CHECKING([for __atomic_fetch_sub])
AC_LINK_IFELSE([AC_LANG_PROGRAM([],[int i = 0; __atomic_fetch_sub(&i, 1, __ATOMIC_RELAXED);])], [
	AC_DEFINE([HAVE___ATOMIC_FETCH_SUB], [1], [Define to 1 if compiler supports __atomic_fetch_sub])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_MSG_CHECKING([for __builtin_choose_expr])
AC_LINK_IFELSE([AC_LANG_PROGRAM([],[int i = 1; if (__builtin_choose_expr(1, i, 0)) return 0; return 1;])], [
	AC_DEFINE([HAVE___BUILTIN_CHOOSE_EXPR], [1], [Define to 1 if compiler supports __builtin_choose_expr])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_MSG_CHECKING([for __builtin_expect])
AC_LINK_IFELSE([AC_LANG_PROGRAM([],[int i = 1; if (__builtin_expect(i, 1)) return 0; return 1;])], [
	AC_DEFINE([HAVE___BUILTIN_EXPECT], [1], [Define to 1 if compiler supports __builtin_expect])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

AC_MSG_CHECKING([for __builtin_nan])
AC_LINK_IFELSE([AC_LANG_PROGRAM([],[double f = __builtin_nan(""); return 0;])], [
	AC_DEFINE([HAVE___BUILTIN_NAN], [1], [Define to 1 if compiler supports __builtin_nan])
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

AC_MSG_CHECKING([for __builtin_types_compatible_p])
AC_LINK_IFELSE([AC_LANG_PROGRAM([],[char a@<:@1 - (2 * __builtin_types_compatible_p(int, void *))@:>@; return 0;])], [
	AC_DEFINE([HAVE___BUILTIN_TYPES_COMPATIBLE_P], [1], [Define to 1 if compiler supports __builtin_types_compatible_p])
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

AC_MSG_CHECKING([for static_assert])
AC_LINK_IFELSE([AC_LANG_PROGRAM([#include <assert.h>],[static_assert(1, "OK")])], [
	AC_DEFINE([HAVE_STATIC_ASSERT], [1], [Define to 1 if compiler supports static_assert])
	AC_MSG_RESULT([yes])
], [
	AC_MSG_RESULT([no])
])

])
