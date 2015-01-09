SUBDIRS = icons
NULL =

virtausappdir = $(datadir)/applications
virtausapp_in_files = virtaus.desktop.in
virtausapp_DATA = $(virtausapp_in_files:.desktop.in=.desktop)

$(virtausapp_in_files): $(virtausapp_in_files:.desktop.in=.desktop.in.in)
	sed -e "s|\@VERSION\@|@VERSION@|" $< > $@

@INTLTOOL_DESKTOP_RULE@

appdatadir = $(datadir)/appdata
appdata_DATA = virtaus.appdata.xml

gsettingsschema_in_files = apps.virtaus.gschema.xml.in
gsettings_SCHEMAS = $(gsettingsschema_in_files:.xml.in=.xml)
.PRECIOUS: $(gsettings_SCHEMAS)


@INTLTOOL_XML_NOMERGE_RULE@

@GSETTINGS_RULES@

EXTRA_DIST = 				    \
	virtaus.desktop.in.in		\
	$(gsettingsschema_in_files)	\
	virtaus.appdata.xml.in    \
	$(icon_DATA) \
	$(NULL)

CLEANFILES =	 			\
	$(virtausapp_in_files)	\
	$(virtausapp_DATA)		\
	$(gsettings_SCHEMAS)	\
	$(appdata_DATA)			\
	$(NULL)
