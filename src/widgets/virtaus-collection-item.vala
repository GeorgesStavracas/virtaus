/* virtaus-collection-item.vala
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

[GtkTemplate (ui = "/apps/virtaus/resources/collection_child.ui")]
public class CollectionItem : Gtk.Frame
{
  [GtkChild]
  private Gtk.Label name_label;

  /**
   * Delegate the collection setup to the
   * collection item class.
   */
  private Core.Collection collection_;
  public Core.Collection collection
  {
    get {return collection_;}
    set
    {
      collection_ = value;
      name_label.label = value.name;
    }
  }
}

}
