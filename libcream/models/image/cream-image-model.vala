/* cream-image-model.vala
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

public class Cream.ImageModel : GLib.Object, Cream.Model
{
  public string uid {get {return "image-project@virtaus.built-in";}}
  public string name {get {return _("Image project");}}
  public string author {get {return _("The Virtaus team");}}

  /**
   * The model's icon
   */
  private Gdk.Pixbuf? icon_;
  public Gdk.Pixbuf? icon
  {
    get {return icon_;}
  }

  /**
   * Renderer
   */
  public GLib.Type renderer {get {return typeof (Cream.ImageRenderer);}}

  /**
   * List of image types that this model supports.
   */
  private GLib.List<string> accepted_types_;
  public GLib.List<string> accepted_types {get {return accepted_types_;}}

  /**
   * The configuration panel.
   *
   * For now, it's nothing.
   */
  public Gtk.Widget? configuration_panel {get {return null;}}

  construct
  {
    /* List of accepted image types */
    accepted_types_ = new GLib.List<string> ();
    accepted_types_.append ("image/jpg");
    accepted_types_.append ("image/png");

    /* Icon */
    try
    {
      icon_ = new Gdk.Pixbuf.from_resource ("/org/cream/data/icons/image-model-icon.png");
    }
    catch (GLib.Error error)
    {
      icon_ = null;
    }
  }

  public Cream.Renderer create_renderer ()
  {
    return new Cream.ImageRenderer ();
  }
}
