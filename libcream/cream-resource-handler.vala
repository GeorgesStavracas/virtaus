/* cream-resource-handler.vala
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

public interface Cream.ResourceHandler : GLib.Object
{
  /**
   * The priority of this handler.
   *
   * Read-only value used when registering this {@link GLib.IOExtension}.
   */
  public abstract int priority {get; default = 0;}

  /**
   * List of handled types.
   *
   * A list of managed types. If the resource is a file, this list contains
   * extensions of the possible handled files; if the resource is a special
   * link, this lise should contain the schema of the link; and so it goes.
   */
  public abstract GLib.List<string> types {get;}

  /**
   * Opens the given resource.
   */
  public abstract void open (Cream.Resource resource) throws GLib.Error;

  /**
   * Saves the given resource.
   */
  public abstract void save (Cream.Resource resource) throws GLib.Error;

  /**
   * Closes the given resource.
   */
  public abstract void close (Cream.Resource resource) throws GLib.Error;
}
