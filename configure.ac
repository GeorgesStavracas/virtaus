dnl -*- mode: m4 -*-
AC_PREREQ([2.67])
AC_INIT([virtaus],
        [0.0.1],
        [https://github.com/GeorgesStavracas/Virtaus/issues],
        [virtaus])

AM_INIT_AUTOMAKE([1.11 tar-ustar dist-xz no-dist-gzip])

AC_CONFIG_HEADERS(config.h)
AC_CONFIG_SRCDIR(src/main.vala)
AC_CONFIG_MACRO_DIR([m4])

AC_SEARCH_LIBS([strerror],[cposix])
AC_PROG_CC
AC_HEADER_STDC
AC_FUNC_MMAP

AM_MAINTAINER_MODE([enable])
AM_SILENT_RULES([yes])

# Setup gettext (l10n & i18n)
IT_PROG_INTLTOOL(0.40.0)

AM_GNU_GETTEXT([external])
AM_GNU_GETTEXT_VERSION([0.17])

GETTEXT_PACKAGE=virtaus
AC_SUBST([GETTEXT_PACKAGE])
AC_DEFINE_UNQUOTED(GETTEXT_PACKAGE,"$GETTEXT_PACKAGE",[Gettext Package])

# Initialize libtool
LT_PREREQ([2.2])
LT_INIT([dlopen disable-static])

AC_PROG_CC
AC_PROG_INSTALL
AC_PROG_MAKE_SET
dnl Check for vala
AM_PROG_VALAC([0.23.0])


# compile gsettings schemas
GLIB_GSETTINGS

# Resources 
GLIB_COMPILE_RESOURCES=`$PKG_CONFIG --variable glib_compile_resources gio-2.0`
AC_SUBST(GLIB_COMPILE_RESOURCES)


package_modules="
    gee-0.8
    gio-2.0 >= 2.36
    glib-2.0 >= 2.36
    gmodule-2.0
    gobject-2.0
    gtk+-3.0 >= 3.15.1
    libnotify
    libpeas-1.0
    libpeas-gtk-1.0
    sqlite3"

PKG_CHECK_MODULES(VIRTAUS, [$package_modules])

VIRTAUS_PACKAGES=" \
    --pkg gtk+-3.0 \
    --pkg gio-2.0 \
    --pkg gobject-2.0 \
    --pkg gmodule-2.0 \
    --pkg glib-2.0 \
    --pkg libnotify \
    --pkg libpeas-1.0 \
    --pkg libpeas-gtk-1.0 \
    --pkg sqlite3"

AC_SUBST(VIRTAUS_PACKAGES)

dnl Add plugins
VIRTAUS_ADD_PLUGIN([example],[Example],[yes])
VIRTAUS_ADD_PLUGIN([local-source],[Local Source],[yes])

dnl Setup vala stamps
VIRTAUS_ADD_STAMP([libcream/libcream_vala.stamp])
VIRTAUS_ADD_STAMP([src/virtaus_vala.stamp])

# Setup plugin dependencies
PKG_CHECK_MODULES([VIRTAUS_PLUGIN_DEPS], [$package_modules])

# Defining some constant paths
AC_SUBST([VIRTAUS_PLUGIN_DIR], [${libdir}/libcream/plugins])
AC_SUBST([VIRTAUS_PLUGIN_LINKER_FLAGS], ["-module -avoid-version -Wl,-z,defs"])

AC_CONFIG_FILES([
    Makefile
    libcream.pc
    data/Makefile
    data/icons/Makefile
    data/apps.virtaus.gschema.xml.in
    src/Makefile
    libcream/Makefile
    po/Makefile.in
    plugins/Makefile
])

AC_OUTPUT


echo "

    Virtaus $VERSION

    Prefix: ${prefix}
    Vala compiler: ${VALAC}
    C compiler: ${CC}
    Plugin deps: ${VIRTAUS_PLUGIN_DEPS_LIBS}

    Now type 'make' to build $PACKAGE
"
