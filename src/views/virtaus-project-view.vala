/* virtaus-project-view.vala
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

[GtkTemplate (ui = "/apps/virtaus/resources/project-view.ui")]
public class Virtaus.View.Project : Gtk.Frame, Virtaus.View.AbstractView
{
  public weak Virtaus.Application app {get; construct;}

  [GtkChild]
  private Gtk.SearchBar searchbar;
  [GtkChild]
  private Gtk.StackSwitcher stack_switcher;

  /**
   * Enable the search.
   */
  public bool has_search
  {
    get {return true;}
  }

  /**
   * Enable selection mode.
   */
  public bool has_selection
  {
    get {return true;}
  }

  /**
   * {@link Virtaus.View.Mode} implementation.
   */
  private Mode _mode = Mode.DEFAULT;
  public Mode mode
  {
    get {return _mode;}
    set
    {
      if (_mode != value)
        _mode = value;
    }
  }

  /**
   *.Since we're setting a titlebar_widget, title and
   * subtitle will be ignored.
   */
  public string? title {get {return null;}}
  public string? subtitle {get {return null;}}
  public Gtk.Widget? titlebar_widget {get {return stack_switcher;}}

  public Gtk.SearchBar? search_bar
  {
    get {return this.searchbar;}
  }

  public Project (Virtaus.Application app)
  {
    Object (app: app);
  }

  public void set_object (Cream.BaseObject? object)
  {

  }

  public new void activate ()
  {
  }

  public void deactivate ()
  {
  }
}
