/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * virtaus-view.c
 * Copyright (C) 2014 Georges Basile Stavracas Neto <georges.stavracas@gmail.com>
 * 
 * Virtaus is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Virtaus is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

namespace Virtaus.View
{

public enum Mode
{
  DEFAULT,
  SEARCH,
  SELECTION
}

public interface AbstractView : GLib.Object
{
  /**
   * Whether the view implements {@link Virtaus.View.Mode.SEARCH} mode.
   *
   * Views that can handle search should set this to {@link true}.
   */
  public abstract bool has_search {get; default = false;}

  /**
   * Whether the view implements {@link Virtaus.View.Mode.SELECTION} mode.
   *
   * Views that can handle selection should set this to {@link true}.
   */
  public abstract bool has_selection  {get; default = false;}

  /**
   * The current view {@link Virtaus.View.Mode}.
   *
   * Views that can handle search should set this to {@link true}.
   *
   * @see Virtaus.View.Mode
   */
  public abstract Mode mode  {get; set; default = Mode.DEFAULT;}

  /**
   * Title for the headerbar.
   *
   * If a title widget is set, this will be ignored.
   */
  public abstract string? title {get;}

  /**
   * Subtitle for the headerbar.
   *
   * If a title widget is set, this will be ignored.
   */
  public abstract string? subtitle {get;}

  /**
   * Titlebar for the headerbar.
   *
   * This is preferred over title.
   */
  public abstract Gtk.Widget? titlebar_widget {get;}

  /**
   * Fired when the view wants the window to register a widget.
   */
	public signal void register_widget (Virtaus.WindowLocation location,
	                                    Gtk.Widget             widget,
	                                    Gtk.Align              halign,
	                                    Gtk.Align              valign);

  /**
   * Fired when the view wants the window to remove a widget.
   */
	public signal void remove_widget   (Gtk.Widget             widget);

	/**
   * Fired when the view wants the window to remove a widget,
   * but has no reference to the widget.
   */
	public signal void remove_widget_by_location (Virtaus.WindowLocation location,
	                                              Gtk.Align              halign,
	                                              Gtk.Align              valign);

  /**
   * Fired when the view wants to change the current view.
   */
  public signal void show_view       (string                        view_name);

  /**
   * When the window receives keyboard input, is must ask
   * the search bar whether it'll handle that or not.
   */
  public abstract Gtk.SearchBar? search_bar {get; default = null;}

  /**
   * Called when the view is set as the current active view.
   */
  public abstract new void activate   ();

  /**
   * Called when the view is not the active view anymore.
   */
  public abstract new void deactivate ();
}

}
