/* cream-resource.vala
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

/**
 * An {@link Cream.Resource} is data-only, and has no methods to modify
 * any states (except 'open' and 'valid' states). This should be read and
 * handled by the corresponding {@link Cream.ResourceHandler}.
 */
public abstract class Cream.Resource : GLib.Object
{
  /**
   * The identifier of this resource.
   *
   * The URI is the most important data field from {@link Cream.Resource},
   * and represents a resource of any kind (images, sounds, texts, etc).
   *
   * This field cannot be modified after the construction of the resource.
   */
  public abstract string uri {get; construct;}

  /**
   * Whether the resource is opened or not.
   *
   * Only the corresponding {@link Cream.ResourceHandler} should ever
   * modify this value.
   */
  public bool open {get; set; default = false;}

  /**
   * Whether the resource is valid or not.
   *
   * Only the corresponding {@link Cream.ResourceHandler} should ever
   * modify this value, ideally when opening the resource.
   */
  public bool valid {get; set; default = true;}

  public Resource (string uri)
  {
    Object (uri: uri);
  }
}
