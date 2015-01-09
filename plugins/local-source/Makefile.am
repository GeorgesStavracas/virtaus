include $(top_srcdir)/common.am

plugin_LTLIBRARIES = liblocal_source.la
plugin_DATA = local-source.plugin

BUILT_SOURCES = \
    local-source-resources.c

liblocal_source_la_SOURCES = \
    local-source.vala \
    $(BUILT_SOURCES)

liblocal_source_la_VALAFLAGS = \
	$(VIRTAUS_COMMON_LIBVIRTAUS_CORE_VALAFLAGS) \
	--target-glib=2.38 \
    --gresources=local-source.gresource.xml

liblocal_source_la_CFLAGS = \
	$(VIRTAUS_COMMON_LIBVIRTAUS_CORE_CFLAGS) \
	-I$(srcdir) \
    -DG_LOG_DOMAIN='"Local Source"'

liblocal_source_la_LIBADD = \
    $(VIRTAUS_COMMON_LIBVIRTAUS_CORE_LIBS)

liblocal_source_la_LDFLAGS = \
    $(VIRTAUS_PLUGIN_LINKER_FLAGS) \
    -lm

# generate binary-bundle resources
resource_files = $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies \
                --sourcedir=$(top_srcdir)/plugins/local-source $(top_srcdir)/plugins/local-source/local-source.gresource.xml)

local-source-resources.c: local-source.gresource.xml $(resource_files)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(top_srcdir)/plugins/local-source --generate-source $<



EXTRA_DIST = local-source.plugin.in local-source.gresource.xml
