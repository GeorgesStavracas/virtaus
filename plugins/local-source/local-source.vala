/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * example-plugin.c
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
namespace Virtaus.Plugin
{

internal class SqliteSource : Peas.ExtensionBase, Virtaus.Core.DataSource, Peas.Activatable
{
	public GLib.Object object { owned get; construct; }
	/**
	 * The database file path. By default, Environment.user_config_dir ().
	 *
	 * See {@link Environment}
	 */
	public string database_path {public get; private set; default = Environment.get_user_config_dir () + "/virtaus/";}

	/**
	 * The database file name.
	 */
	public string database_file {public get; private set; default = "local.db";}

	/**
	 * The database itself.
	 */
	private Sqlite.Database database;

	public SqliteSource ()
	{
		GLib.File dir;
		GLib.File file;

		dir = GLib.File.new_for_path (database_path);
		file = GLib.File.new_for_path (database_path + database_file);

		/* Test directory */
		if (! dir.query_exists () ||
				! (dir.query_file_type (0) == GLib.FileType.DIRECTORY))
		{
			try
			{
				/* Create directory */
				dir.make_directory_with_parents ();
			}
			catch (GLib.Error er)
			{
				warning (_("Could not create database directory"));
			}
		}

		/* Test database file */
		if (! file.query_exists () ||
			  ! (file.query_file_type (0) == GLib.FileType.REGULAR))
	  {
			create_database ();
	  }

		database = null;
	}

	public void activate ()
	{
		Virtaus.Core.ExtensionInfo info;
		Virtaus.Core.PluginManager manager;

		manager = Virtaus.Core.PluginManager.instance;

		/* Information about the plugin */
		info = new Virtaus.Core.ExtensionInfo ();
		info.name = "Local source";
		info.author = "Georges Basile Stavracas Neto <georges.stavracas@gmail.com>";
		info.description = "Local data source using a SQLite database";
		info.instance = new Virtaus.Plugin.SqliteSource ();

		manager.register_data_source ("SqliteSource.local_source@georges", info);
	}

  public void deactivate ()
  {
		Virtaus.Core.PluginManager manager;
		manager = Virtaus.Core.PluginManager.instance;

		manager.unregister_data_source ("SqliteSource.local_source@georges");
  }

	public void update_state ()
	{
		message("update state");
	}

	/**
	 * Creates an empty database where it doesn't exists.
	 */
	private async void create_database ()
	{
		ThreadFunc<void*> run = () =>
		{
			try
			{
				int error_code;
				string schema, tag_out, error_message;
				uint8[] schema_content;
				GLib.File schema_file;

				/* Retrieve Database creation script */
				schema_file = GLib.File.new_for_uri ("resource:///apps/virtaus/local_source/sql/schema.sql");
				schema_file.load_contents (null, out schema_content, out tag_out);
				schema = (string) schema_content;

				/* Create database file */
				error_code = Sqlite.Database.open_v2 (database_path + database_file, out database);

				if (error_code != Sqlite.OK)
				{
					warning ("Database couldn't be opened: (%d) %s", database.errcode (), database.errmsg ());
					database = null;
					return null;
				}

				/* Create Sqlite SCHEMA */
				error_code = database.exec (schema, null, out error_message);

				if (error_code != Sqlite.OK)
				{
					warning ("Database couldn't be opened: (%d) %s", database.errcode (), database.errmsg ());
					database = null;
					return null;
				}
			}
			catch (GLib.Error er)
			{
				warning (_("Could not create database file"));
			}

			return null;
		};

		/* Create thread */
		try
		{
			GLib.Thread.create<void*> (run, false);
		}
		catch (GLib.Error error)
		{
			warning (_("Could not create database file. Error running thread."));
		}

		yield;
	}

	public string get_name ()
  {
		return _("Local data");
  }

  public string get_source_name ()
  {
		return _("Local");
  }

	/**
	 * Open the database when it is closed.
	 */
	private void open_database ()
	{
		int error_code;

		error_code = Sqlite.Database.open (database_path, out database);

		if (error_code != Sqlite.OK)
		{
			warning ("Database couldn't be opened: (%d) %s", database.errcode (), database.errmsg ());
			database = null;
			return;
		}
	}

  public void create_collection (Virtaus.Core.Collection collection)
  {
		string query;

		query = "INSERT INTO Collection (name, directory) VALUES (%s, %s)";
		query.printf (collection.name, collection.info["directory"]);
		stdout.printf (query + "\n");
  }

	/* TODO: implement the methods above */
  public Gee.LinkedList<Virtaus.Core.Collection> get_collections () {return null;}
  public void update_collection (Virtaus.Core.Collection collection) {}
  public void save_collections (Gee.LinkedList<Virtaus.Core.Collection> collections) {}
}

}

[ModuleInit]
public void peas_register_types (GLib.TypeModule module) {
    var obj = module as Peas.ObjectModule;
    obj.register_extension_type (typeof (Peas.Activatable), typeof (Virtaus.Plugin.SqliteSource));
    obj.register_extension_type (typeof (Virtaus.Core.DataSource), typeof (Virtaus.Plugin.SqliteSource));
}
