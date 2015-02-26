/* cream-image-renderer.vala
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

public class Cream.ImageRenderer : Gtk.Widget, Cream.Renderer
{
  Gdk.Pixbuf? icon = null;

  private Gdk.Pixbuf? get_pixbuf_from_icon_name (string name, int width, int height)
  {
    Gtk.IconTheme theme;
    Gdk.Pixbuf pixbuf;

    theme = new Gtk.IconTheme ();

    try
    {
      pixbuf = theme.load_icon (name, width < height ? width : height, Gtk.IconLookupFlags.FORCE_SIZE);
    }
    catch (GLib.Error error)
    {
      pixbuf = null;
    }

    return pixbuf;
  }

  public Gdk.Pixbuf? render (Cream.BaseObject? object, int width, int height)
  {
    if (object is Cream.Project)
      return render_project (object as Cream.Project, width, height);

    return null;
  }

  private Gdk.Pixbuf? render_project (Cream.Project? project, int width, int height)
  {
    const int ICON_SIZE = 96;

    Gtk.StyleContext context;
    Cairo.ImageSurface surface;
    Cairo.Context cr;
    Pango.Layout layout;
    Gdk.Pixbuf pixbuf;
    double stripe_height;
    int font_width, font_height;

    if (project == null)
      return null;

    context = this.get_style_context ();
    surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, width, height);
    cr = new Cairo.Context (surface);

    if (icon == null)
      icon = get_pixbuf_from_icon_name ("image-x-generic-symbolic", ICON_SIZE, ICON_SIZE);

    context.render_background (cr, 0, 0, width, height);
    context.render_icon (cr, icon, (width - ICON_SIZE) / 2, (height - ICON_SIZE) / 2);

    // Bottom rectangle
    context.save ();
    context.add_class ("bottom-stripe");

    stripe_height = height / 6;

    layout = this.create_pango_layout (project.name);
    layout.set_alignment (Pango.Alignment.CENTER);
    layout.get_pixel_size (out font_width, out font_height);

    context.render_background (cr, 0, height - stripe_height, width, stripe_height);
    context.render_layout (cr, (height - font_width) / 2, height - stripe_height + (stripe_height - font_height) / 2, layout);

    context.restore ();

    pixbuf = Gdk.pixbuf_get_from_surface (surface, 0, 0, width, height);

    return pixbuf;
  }
}
