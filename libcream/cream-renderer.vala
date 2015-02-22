/* cream-renderer.vala
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

public interface Cream.Renderer : Gtk.Widget
{
  /**
   * Draws a visual representation of the given {@link Cream.BaseObject}.
   *
   * It is completely up to the implementor to check for the @object type,
   * and it must honor the given @width and @height.
   */
  public abstract Gdk.Pixbuf? render (Cream.BaseObject? object, int width, int height);
}
