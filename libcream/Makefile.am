libvirtausincdir = $(includedir)/libcream

libvirtausinc_HEADERS = cream.h

noinst_LTLIBRARIES = libcream.la

libcream_la_SOURCES = \
    models/image/cream-image-model.vala \
    models/image/cream-image-renderer.vala \
    resources/cream-image-resource.vala \
    resources/cream-image-resource-handler.vala \
    cream-base-object.vala \
    cream-context.vala \
    cream-data-source.vala \
    cream-enums.vala \
    cream-exporter.vala \
    cream-extension-info.vala \
    cream-filter.vala \
    cream-model.vala \
    cream-plugin.vala \
    cream-plugin-manager.vala \
    cream-project.vala \
    cream-renderer.vala \
    cream-resource.vala \
    cream-resource-handler.vala \
    cream-resource-manager.vala \
    cream-settings.vala \
    cream-types.vala \
    cream-resources.c
    
libcream_la_VALAFLAGS = \
    --vapidir=$(srcdir) \
    -H cream.h -C \
    --pkg libpeas-1.0 \
    --pkg gmodule-2.0 \
    --pkg gee-0.8 \
    --library=cream \
    --gresources=cream.gresource.xml \
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
    cream-resources.c \
    cream.h

VAPI_FILES = cream.vapi
DEPS_FILE = libcream.deps

vapidir = $(VAPIDIR)
vapi_DATA = $(VAPI_FILES) $(DEPS_FILES)
libcream.vapi cream.h: libcream_la_vala.stamp

resource_files = $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies --sourcedir=$(top_srcdir)/libcream $(top_srcdir)/libcream/cream.gresource.xml)

cream-resources.c: cream.gresource.xml $(resource_files)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(top_srcdir)/libcream --generate-source $<

clean-local:
	rm -rf $(libcream_la_SOURCES:.vala=.c) *.stamp $(BUILT_SOURCES)

MAINTAINERCLEANFILES = $(BUILT_SOURCES)

EXTRA_DIST = \
	$(VAPI_FILES) \
	$(DEPS_FILES) \
	$(BUILT_SOURCES)
