libvirtausincdir = $(includedir)/libcream

libvirtausinc_HEADERS = cream.h

lib_LTLIBRARIES = libcream.la

libcream_la_SOURCES = \
    cream-data-source.vala \
    cream-enums.vala \
    cream-exporter.vala \
    cream-extension-info.vala \
    cream-filter.vala \
    cream-plugin.vala \
    cream-plugin-manager.vala \
    cream-types.vala
    
libcream_la_VALAFLAGS = \
    --vapidir=$(srcdir) \
    -H cream.h -C \
    --pkg libpeas-1.0 \
    --pkg gmodule-2.0 \
    --pkg gee-0.8 \
    --library=cream-1.0 \
    @VIRTAUS_PACKAGES@

libcream_la_CFLAGS = \
    -DG_LOG_DOMAIN='"Cream"' \
    -I$(srcdir) \
    -include config.h \
    -Wall \
    -g \
	$(VIRTAUS_CFLAGS)

libcream_la_LIBADD = 
    

CREAM_CORE_VERSION = 1:0:0
libcream_la_LDFLAGS = \
    -version-info $(CREAM_CORE_VERSION)

BUILT_SOURCES = \
    libcream.vapi \
    cream.h

VAPI_FILES = cream.vapi
DEPS_FILE = libcream.deps

vapidir = $(VAPIDIR)
vapi_DATA = $(VAPI_FILES) $(DEPS_FILES)
libcream.vapi cream.h: libcream_la_vala.stamp

MAINTAINERCLEANFILES = $(BUILT_SOURCES)

EXTRA_DIST = \
	$(VAPI_FILES) \
	$(DEPS_FILES) \
	$(BUILT_SOURCES)
