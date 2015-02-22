/* cream-project.vala
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

public class Cream.Project : Cream.BaseObject
{
  /**
   * A list of child {@link Cream.Set} of this project.
   */
  private GLib.List<Cream.Set> sets_ = new GLib.List<Cream.Set> ();
  public GLib.List<Cream.Set> sets
  {
    owned get
    {
      return sets_ == null ? null : sets_.copy ();
    }
  }

  /**
   * A list of child {@link Cream.Set} of this project.
   */
  private GLib.List<Cream.Category> categories_ = new GLib.List<Cream.Category> ();
  public GLib.List<Cream.Category> categories
  {
    owned get
    {
      return sets_ == null ? null : categories_.copy ();
    }
  }

  /**
   * Needed to enable the use of foreach operator.
   */
  public int size
  {
    get
    {
      return info != null ? (int) info.length : 0;
    }
  }

  /**
   * The internal hash of info.
   */
  private GLib.HashTable<string, string> info;

  public Project (Cream.DataSource source)
  {
    Object (source: source);

    info = new GLib.HashTable<string, string> (GLib.str_hash, GLib.str_equal);
  }

  /**
   * Add a {@link Cream.Set} to {@link this}.
   */
  public void add_set (Cream.Set @set)
  {
    if (!this.has_set (set))
      sets_.append (set);
  }

  /**
   * Remove the given {@link Cream.Set} from {@link this}.
   */
  public void remove_set (Cream.Set @set)
  {
    if (this.has_set (set))
      sets_.remove (set);
  }

  /**
   * Check whether {@link this} project contains
   * the given {@link Cream.Set}.
   */
  public bool has_set (Cream.Set @set)
  {
    bool contains = false;

    sets_.foreach ((current)=>
    {
      if (current == set)
      {
        contains = true;
        return;
      }
    });

    return contains;
  }


  /**
   * Add a {@link Cream.Category} to {@link this}.
   */
  public void add_category (Cream.Category category)
  {
    if (!this.has_category (category))
      categories_.append (category);
  }

  /**
   * Remove the given {@link Cream.Category} from {@link this}.
   */
  public void remove_category (Cream.Category category)
  {
    if (this.has_category (category))
      categories_.remove (category);
  }

  /**
   * Check whether {@link this} project contains
   * the given {@link Cream.Category}.
   */
  public bool has_category (Cream.Category category)
  {
    bool contains = false;

    categories_.foreach ((current)=>
    {
      if (current == category)
      {
        contains = true;
        return;
      }
    });

    return contains;
  }

  /**
   * Needed to make this class accessable with Vala sugar operator.
   */
  public bool contains (string key)
  {
    return info.contains (key);
  }

  public new string? get (string key)
  {
    return info.lookup (key);
  }

  public new void set (string key, string @value)
  {
    info.insert (key, value);
  }
}
