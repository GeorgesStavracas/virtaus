include $(top_srcdir)/common.am

plugin_LTLIBRARIES = libexample.la
plugin_DATA = example.plugin

libexample_la_SOURCES = \
    example-plugin.vala

libexample_la_VALAFLAGS = \
	$(VIRTAUS_COMMON_LIBVIRTAUS_CORE_VALAFLAGS) \
	--target-glib=2.38

libexample_la_CFLAGS = \
	$(VIRTAUS_COMMON_LIBVIRTAUS_CORE_CFLAGS) \
	-I$(srcdir) \
    -DG_LOG_DOMAIN='"Example"'

libexample_la_LIBADD = \
    $(VIRTAUS_COMMON_LIBVIRTAUS_CORE_LIBS)

libexample_la_LDFLAGS = \
    $(VIRTAUS_PLUGIN_LINKER_FLAGS) \
    -lm

EXTRA_DIST = example.plugin.in
