ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}
NULL =

pkgconfig_DATA = libcream.pc
pkgconfigdir = $(libdir)/pkgconfig

SUBDIRS = po libcream src data plugins

virtausdocdir = ${prefix}/doc/virtaus
virtausdoc_DATA = \
	README.md\
	README\
	virtaus.doap\
	COPYING\
	AUTHORS\
	ChangeLog\
	INSTALL\
	NEWS


EXTRA_DIST = \
    config.rpath m4/ChangeLog \
    $(virtausdoc_DATA) \
    libcream.pc.in

CLEANFILES = \
	$(applications_DATA)

MAINTAINERCLEANFILES = \
	ABOUT-NLS \
	aclocal.m4 \
	config.guess \
	config.h.in \
	config.rpath \
	config.sub \
	depcomp \
	install-sh \
	ltmain.sh \
	missing

# Remove doc directory on uninstall
uninstall-local:
	-rm -r $(virtausdocdir)
