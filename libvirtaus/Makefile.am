libvirtausincdir = $(includedir)/virtaus-1.0

libvirtausinc_HEADERS = virtaus-core.h

lib_LTLIBRARIES = libvirtaus-1.0.la

libvirtaus_1_0_la_SOURCES = \
    virtaus-core-data-source.vala \
    virtaus-core-enums.vala \
    virtaus-core-exporter.vala \
    virtaus-core-extension-info.vala \
    virtaus-core-filter.vala \
    virtaus-core-plugin.vala \
    virtaus-core-plugin-manager.vala \
    virtaus-core-types.vala
    
libvirtaus_1_0_la_VALAFLAGS = \
    --vapidir=$(srcdir) \
    -H virtaus-core.h -C \
    --pkg libpeas-1.0 \
    --pkg gmodule-2.0 \
    --pkg gee-0.8 \
    --library=virtaus-core-1.0 \
    @VIRTAUS_PACKAGES@

libvirtaus_1_0_la_CFLAGS = \
    -DG_LOG_DOMAIN='"Virtaus"' \
    -I$(srcdir) \
    -include config.h \
    -Wall \
    -g \
	$(VIRTAUS_CFLAGS)

libvirtaus_1_0_la_LIBADD = 
    

VIRTAUS_CORE_VERSION = 1:0:0
libvirtaus_1_0_la_LDFLAGS = \
    -version-info $(VIRTAUS_CORE_VERSION)

BUILT_SOURCES = \
    virtaus-core-1.0.vapi \
    virtaus-core.h

VAPI_FILES = virtaus-core-1.0.vapi
DEPS_FILE = virtaus-core-1.0.deps

vapidir = $(VAPIDIR)
vapi_DATA = $(VAPI_FILES) $(DEPS_FILES)
virtaus-core-1.0.vapi virtaus-core.h: libvirtaus_1_0_la_vala.stamp

MAINTAINERCLEANFILES = $(BUILT_SOURCES)

EXTRA_DIST = \
	$(VAPI_FILES) \
	$(DEPS_FILES) \
	$(BUILT_SOURCES)
