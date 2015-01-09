include $(top_srcdir)/common.am

plugin_LTLIBRARIES = libmystudies-task-manager.la
plugin_DATA = task-manager.plugin

BUILT_SOURCES = task-manager-resources.c

libmystudies_task_manager_la_SOURCES = \
    mystudies-task-manager-edit-panel.vala \
    mystudies-task-manager-list-row.vala \
    mystudies-task-manager-plugin.vala \
    mystudies-task-manager-task-row.vala \
    mystudies-task-manager-new-task-dialog.vala \
    mystudies-task-manager-widget.vala \
    $(BUILT_SOURCES)
    
libmystudies_task_manager_la_VALAFLAGS = \
	$(MYSTUDIES_COMMON_LIBMYSTUDIES_CORE_VALAFLAGS) \
	--target-glib=2.38 \
    --gresources=task-manager.gresource.xml
	
libmystudies_task_manager_la_CFLAGS = \
	$(MYSTUDIES_COMMON_LIBMYSTUDIES_CORE_CFLAGS) \
	-I$(srcdir) \
    -DG_LOG_DOMAIN='"TaskManager"'
	
libmystudies_task_manager_la_LIBADD = \
    $(MYSTUDIES_COMMON_LIBMYSTUDIES_CORE_LIBS)

libmystudies_task_manager_la_LDFLAGS = \
    $(MYSTUDIES_PLUGIN_LINKER_FLAGS) \
    -lm


# generate binary-bundle resources
resource_files = $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies \
                --sourcedir=$(top_srcdir)/plugins/task-manager $(top_srcdir)/plugins/task-manager/task-manager.gresource.xml)

task-manager-resources.c: task-manager.gresource.xml $(resource_files)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(top_srcdir)/plugins/task-manager --generate-source $<

EXTRA_DIST = task-manager.plugin.in task-manager.gresource.xml
