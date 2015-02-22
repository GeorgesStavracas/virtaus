/* cream-model.vala
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

public abstract class Cream.Model : GLib.Object
{
  /**
   * Name of the model.
   */
  public abstract string name {get;}

  /**
   * Icon of the project.
   */
  public abstract Gdk.Pixbuf? icon {get;}

  /**
   * The renderer of the model.
   */
  public abstract GLib.Type renderer {get;}

  /**
   * A list of accepted resource types.
   */
  public abstract GLib.List<string> accepted_types {get;}

  /**
   * The optional configuration panel.
   */
  public abstract Gtk.Widget? configuration_panel {get;}

  /**
   * Creates a new instance of this model's renderer.
   */
  public abstract Cream.Renderer create_renderer ();
}
