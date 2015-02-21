/* -*- Mode: Vala; indent-tabs-mode: s; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * cream-plugin-manager.c
 * Copyright (C) 2014 Georges Basile Stavracas Neto <georges.stavracas@gmail.com>
 * 
 * Virtaus is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Virtaus is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

public class Cream.PluginManager : GLib.Object
{
	/* Signals */
	public signal void data_source_registered (Cream.ExtensionInfo source, string uid);
	public signal void data_source_unregistered (string uid);

	public signal void filter_registered (Cream.ExtensionInfo filter, string uid);
	public signal void filter_unregistered (string uid);

	public signal void plugin_registered (Cream.ExtensionInfo plugin, string uid);
	public signal void plugin_unregistered (string uid);

	/* Peas */
  public Peas.Engine engine {private set; public get;}
  public Peas.ExtensionSet extension_set {private set; public get;}

	/* Registered extensions */
  public Gee.HashMap <string, Cream.ExtensionInfo> data_sources {public get; private set;}
  public Gee.HashMap <string, Cream.ExtensionInfo> filters {public get; private set;}
  public Gee.HashMap <string, Cream.ExtensionInfo> plugins {public get; private set;}

	/* Settings */
	private GLib.Settings settings {public get; private set;}

	public PluginManager ()
	{
		/* Setup plugin engine */
		engine = Peas.Engine.get_default ();
		engine.enable_loader ("python3");

		engine.add_search_path ("./plugins", null);

		/* Load settings */
		settings = new GLib.Settings ("apps.virtaus.plugins");

		/* Bind settings & active plugins */
		settings.bind ("active-plugins", engine, "loaded-plugins", GLib.SettingsBindFlags.DEFAULT);

		/* Instantiate lists */
		data_sources = new Gee.HashMap <string, Cream.ExtensionInfo> ();
		filters = new Gee.HashMap <string, Cream.ExtensionInfo> ();
		plugins = new Gee.HashMap <string, Cream.ExtensionInfo> ();

		/* Setup extension set */
		extension_set = new Peas.ExtensionSet (engine, typeof (Peas.Activatable), null);

    /* Chain (de)activation signal */
    extension_set.extension_added.connect (on_extension_added);
		extension_set.extension_removed.connect (on_extension_removed);

    /**
     * When the signals are connected, we may already
     * have some extensions loaded and active. For these
     * extensions, {@link Peas.ExtensionSet::extension-added}
     * won't be called. Because of it, we must manually
     * call on_extension_added on them.
     */
    extension_set.foreach ((unused_set, info, extension)=>
    {
      on_extension_added (info, extension);
    });
	}

	public void reload_plugins ()
	{
		engine.rescan_plugins ();
	}

	public void add_plugin_search_path (string path, string? data)
	{
		engine.add_search_path (path, data);
		engine.rescan_plugins ();
	}

	/* Activate loaded plugins */
  void on_extension_added (Peas.PluginInfo info, GLib.Object extension)
	{
    (extension as Peas.Activatable).activate ();
    (extension as Cream.Plugin).hook (this);
	}

	/* Deactivate plugin on signal */
	void on_extension_removed (Peas.PluginInfo info, GLib.Object extension)
	{
    (extension as Peas.Activatable).deactivate ();
    (extension as Cream.Plugin).unhook (this);
	}

	/* Register & unregister DataSources */
	public void register_data_source (string uid, Cream.ExtensionInfo info)
	{
		if (data_sources.has_key (uid))
			return;

		/* Trying to add a non datasource type */
		if (! info.instance.get_type ().is_a (typeof (Cream.DataSource)))
		{
			warning (_("Cannot register a non DataSource type into DataSource map"));
			return;
		}

		data_sources.set (uid, info);
		debug ("Data source \"%s\" registered", uid);

		data_source_registered (info, uid);
	}

	public void unregister_data_source (string uid)
	{
		if (! data_sources.has_key (uid))
			return;

		data_sources.unset (uid);
		debug ("Data source \"%s\" unregistered", uid);

		data_source_unregistered (uid);
	}

	/* Register & unregister Plugins */
	public void register_plugin (string uid, Cream.ExtensionInfo info)
	{
		if (plugins.has_key (uid))
			return;

		/* Trying to add a non-plugin type */
		if (! info.instance.get_type ().is_a (typeof (Cream.Plugin)))
		{
			warning (_("Cannot register a non-plugin type into Plugins map"));
			return;
		}

		plugins.set (uid, info);
		debug ("Plugin \"%s\" registered", uid);

		plugin_registered (info, uid);
	}

	public void unregister_plugin (string uid)
	{
		if (! plugins.has_key (uid))
			return;

		plugins.unset (uid);
		debug ("Plugin \"%s\" unregistered", uid);

		plugin_unregistered (uid);
	}

	/* Register & unregister Filters */
	public void register_filter (string uid, Cream.ExtensionInfo info)
	{
		if (filters.has_key (uid))
			return;

		/* Trying to add a non-filter type */
		if (! info.instance.get_type ().is_a (typeof (Cream.Filter)))
		{
			warning (_("Cannot register a non-filter type into Filter map"));
			return;
		}

		filters.set (uid, info);
		debug ("Filter \"%s\" registered", uid);

		filter_registered (info, uid);
	}

	public void unregister_filter (string uid)
	{
		if (! filters.has_key (uid))
			return;

		filters.unset (uid);
		debug ("Filter \"%s\" unregistered", uid);

		filter_unregistered (uid);
	}
}
