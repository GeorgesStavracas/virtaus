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

public Gdk.Pixbuf? get_pixbuf_from_icon_name (string name, int size)
{
  Gtk.IconTheme theme;
  Gdk.Pixbuf pixbuf;

  theme = new Gtk.IconTheme ();

  try
  {
    pixbuf = theme.load_icon (name, size, Gtk.IconLookupFlags.FORCE_SIZE);
  }
  catch (GLib.Error error)
  {
    pixbuf = null;
  }

  return pixbuf;
}

public class CollectionRenderer : Gtk.Widget
{
  Gdk.Pixbuf? icon = null;

  public Gdk.Pixbuf? render (CollectionIconItem? item)
  {
    const int ICON_SIZE = 96;

    Gtk.StyleContext context;
    Cairo.ImageSurface surface;
    Cairo.Context cr;
    Pango.Layout layout;
    Gdk.Pixbuf pixbuf;
    double stripe_height;
    int font_width, font_height;

    if (item == null || item.collection == null)
      return null;

    context = this.get_style_context ();
    surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, DEFAULT_SIZE, DEFAULT_SIZE);
    cr = new Cairo.Context (surface);

    if (icon == null)
      icon = Virtaus.get_pixbuf_from_icon_name ("image-x-generic-symbolic", ICON_SIZE);

    context.render_background (cr, 0, 0, DEFAULT_SIZE, DEFAULT_SIZE);
    context.render_icon (cr, icon, (DEFAULT_SIZE - ICON_SIZE) / 2, (DEFAULT_SIZE - ICON_SIZE) / 2);

    // Bottom rectangle
    context.save ();
    context.add_class ("bottom-stripe");

    stripe_height = DEFAULT_SIZE / 6;

    layout = this.create_pango_layout (item.collection.name);
    layout.set_alignment (Pango.Alignment.CENTER);
    layout.get_pixel_size (out font_width, out font_height);

    context.render_background (cr, 0, DEFAULT_SIZE - stripe_height, DEFAULT_SIZE, stripe_height);
    context.render_layout (cr, (DEFAULT_SIZE - font_width) / 2, DEFAULT_SIZE - stripe_height + (stripe_height - font_height) / 2, layout);

    context.restore ();

    pixbuf = Gdk.pixbuf_get_from_surface (surface, 0, 0, DEFAULT_SIZE, DEFAULT_SIZE);

    return pixbuf;
  }
}

}
