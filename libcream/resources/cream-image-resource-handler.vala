/* cream-image-resource-handler.vala
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

public class Cream.ImageResourceHandler : GLib.Object, Cream.ResourceHandler
{
  private Gdk.Pixbuf? cached_image = null;

  /**
   * Priority of this handler.
   */
  public int priority {get {return 0;}}

  /**
   * List of managed types.
   */
  private GLib.List<string> types_;
  public GLib.List<string> types {get {return types_;}}

  construct
  {
    types_ = new GLib.List<string> ();
    types_.append ("image/jpg");
    types_.append ("image/png");
  }

  /**
   * Open a given image.
   */
  public void open (Cream.Resource resource)
      throws GLib.Error
      requires (resource is Cream.ImageResource)
  {
    try
    {
      cached_image = new Gdk.Pixbuf.from_file (resource.uri);
      resource.open = true;
    }
    catch (GLib.Error error)
    {
      resource.open = false;
      resource.valid = false;

      throw error;
    }
  }

  /**
   * Retrieve resource data as pure memory chunks.
   */
  public void* get_resource_data (Cream.Resource resource)
      throws GLib.Error
      requires (resource is Cream.ImageResource)
  {
    if (resource == null)
      throw new ResourceError.NULL (_("No image found for this handler."));

    if (!resource.open)
      throw new ResourceError.NOT_OPEN (_("The image file was not opened."));

    if (!resource.valid)
      throw new ResourceError.INVALID (_("Invalid image."));

    return cached_image;
  }

  /**
   * Save the given resource.
   */
  public void save (Cream.Resource resource, void* data)
      throws GLib.Error
      requires (data == cached_image)
  {
    try
    {
      cached_image.save (resource.uri, "png", null);
    }
    catch (GLib.Error error)
    {
      throw error;
    }
  }

  public void close (Cream.Resource resource)
      throws GLib.Error
  {
    /* XXX: stub method. Gdk.Pixbufs needs no closing */
  }
}
