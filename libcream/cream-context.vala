/* cream-context.vala
 *
 * Copyright (C) 2015 Georges Basile Stavracas Neto <georges.stavracas@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

public class Cream.Context : GLib.Object
{
  public const string DEFAULT_SCHEMA = "apps.virtaus";

  /* Signals */
  public signal void model_added (Cream.Model model);
  public signal void model_removed (Cream.Model model);

  /**
   * The {@link Cream.Settings} of this instance.
   */
  public Cream.Settings settings {public get; private set;}

  /**
   * The {@link Cream.PluginManager} of this instance.
   */
  public Cream.PluginManager plugin_manager {public get; private set;}

  /**
   * the {@link Cream.ResourceManager} of this instance.
   */
  public Cream.ResourceManager resource_manager {get; private set;}

  /**
   * List of models.
   */
  public GLib.List<Cream.Model> _models = new GLib.List<Cream.Model> ();
  public GLib.List<Cream.Model> models
  {
    owned get {return _models.copy ();}
  }

  public Context ()
  {
    settings = new Cream.Settings (this, DEFAULT_SCHEMA);
    plugin_manager = new Cream.PluginManager ();
    resource_manager = new Cream.ResourceManager (this);

    /* Default built-in models */
    add_model (new Cream.ImageModel ());
  }

  /**
   * Add a new model to the list.
   */
  public void add_model (Cream.Model model)
  {
    debug ("registering model '%s'", model.name);

    _models.append (model);

    // send the signal
    model_added (model);
  }

  /**
   * Remove the given model from the list.
   */
  public void remove_model (Cream.Model model)
  {
    debug ("registering model '%s'", model.name);

    _models.remove_all (model);

    // send the signal
    model_removed (model);
  }
}
