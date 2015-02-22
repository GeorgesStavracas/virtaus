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

  /**
   * The {@link Cream.Settings} of this instance.
   */
  public Cream.Settings settings {public get; construct set;}

  /**
   * The {@link Cream.PluginManager} of this instance.
   */
  public Cream.PluginManager plugin_manager {public get; construct set;}

  public Context ()
  {
    settings = new Cream.Settings (this, DEFAULT_SCHEMA);
    plugin_manager = new Cream.PluginManager ();
  }

}
