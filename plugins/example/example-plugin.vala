/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * example-plugin.c
 * Copyright (C) 2013 Georges Basile Stavracas Neto <georges.stavracas@gmail.com>
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

internal class Example : Peas.ExtensionBase, Virtaus.Core.Plugin, Peas.Activatable
{
	public GLib.Object object { owned get; construct; }

	public Example () { }

	public void activate ()
	{
		Virtaus.Core.ExtensionInfo info;
		Virtaus.Core.PluginManager manager;
		manager = Virtaus.Core.PluginManager.instance;

		/* Information about the plugin */
		info = new Virtaus.Core.ExtensionInfo ();
		info.name = "Example plugin";
		info.author = "Georges Basile Stavracas Neto <georges.stavracas@gmail.com>";
		info.description = "An example plugin";
		info.instance = new Virtaus.Plugin.Example ();

		manager.register_plugin ("example.example@georges", info);
	}

  public void deactivate ()
  {
		Virtaus.Core.PluginManager manager;
		manager = Virtaus.Core.PluginManager.instance;
		manager.unregister_plugin ("example.example@georges");
  }

	public void update_state ()
	{
		message("update state");
	}

  public void run ()
  {
		message("running");
  }
}

}

[ModuleInit]
public void peas_register_types (GLib.TypeModule module) {
    var obj = module as Peas.ObjectModule;
    obj.register_extension_type (typeof (Peas.Activatable), typeof (Virtaus.Plugin.Example));
    obj.register_extension_type (typeof (Virtaus.Core.Plugin), typeof (Virtaus.Plugin.Example));
}
