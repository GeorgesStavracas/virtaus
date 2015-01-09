include $(top_srcdir)/common.am

AM_CPPFLAGS = \
  -I$(top_builddir)/libvirtaus \
	-I$(top_srcdir)/libvirtaus \
	-I$(srcdir) \
	-DGNOME_DESKTOP_USE_UNSTABLE_API \
	-DGETTEXT_PACKAGE=\""$(GETTEXT_PACKAGE)"\" \
	-DPLUGINDIR=\""$(VIRTAUS_PLUGIN_DIR)"\" \
	-DGNOMELOCALEDIR=\""$(localedir)"\" \
  -DDATADIR=\""$(pkgdatadir)"\"

AM_CFLAGS = \
    -g \
	$(VIRTAUS_CFLAGS)

bin_PROGRAMS = virtaus

BUILT_SOURCES = virtaus-resources.c

# source code
VALA_SOURCES = \
    application/virtaus-application.vala \
    \
    dialogs/virtaus-preferences-dialog.vala \
    \
    views/virtaus-view.vala \
    views/virtaus-category-view.vala \
    views/virtaus-collection-view.vala \
    \
    virtaus-window.vala \
    main.vala

virtaus_SOURCES = \
    $(VALA_SOURCES) \
    config.vapi \
    $(BUILT_SOURCES)

# compile-time dependencies
virtaus_VALAFLAGS =  \
    @VIRTAUS_PACKAGES@ \
    --vapidir=$(top_srcdir)/libvirtaus \
    --pkg virtaus-core-1.0 \
    --target-glib=2.38 \
    --gresources=virtaus.gresource.xml

virtaus_LDFLAGS = \
	-export-dynamic

virtaus_LDADD = $(VIRTAUS_LIBS) $(VIRTAUS_COMMON_LIBVIRTAUS_CORE_LIBS) -lm

# generate binary-bundle resources
resource_files = $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies --sourcedir=$(srcdir) $(srcdir)/virtaus.gresource.xml)
    
virtaus-resources.c: virtaus.gresource.xml $(resource_files)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(srcdir) --generate-source $<

EXTRA_DIST= \
    $(resource_files) \
    virtaus.gresource.xml

MAINTAINERCLEANFILES = \
    *.stamp	\
    $(VALA_SOURCES:.vala=.c) \
    $(BUILT_SOURCES)
    

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(pkgdatadir)

