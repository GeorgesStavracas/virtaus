/* virtaus-base-renderer.vala
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

namespace Virtaus
{

protected const int DEFAULT_SIZE = 256;
protected const int MAX_BLUR_ITERATIONS = 3;

void _blur_surface (Cairo.Surface surface, Cairo.Context cr)
{
  Cairo.Pattern pattern;

  pattern = new Cairo.Pattern.for_surface (surface);
  pattern.set_filter (Cairo.Filter.GOOD);

  cr.set_source (pattern);
}

public class CollectionRenderer : Gtk.Widget
{
  public static Gdk.Pixbuf? render (CollectionIconItem? item)
  {
    Gtk.StyleContext context;
    Cairo.ImageSurface surface;
    Cairo.Context cr;
    Gdk.Pixbuf pixbuf;

    if (item == null || item.collection == null)
      return null;

    //context = this.get_style_context ();
    surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, DEFAULT_SIZE, DEFAULT_SIZE);
    cr = new Cairo.Context (surface);

    cr.set_source_rgba (0.5, 0.5, 1.0, 1.0);

    cr.rectangle (0.0, 0.0, (double) DEFAULT_SIZE, (double) DEFAULT_SIZE);

    // Bottom rectangle


    cr.fill ();

    _blur_surface (surface, cr);

    pixbuf = Gdk.pixbuf_get_from_surface (surface, 0, 0, DEFAULT_SIZE, DEFAULT_SIZE);

    return pixbuf;
  }
}

}
