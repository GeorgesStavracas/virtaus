/* virtaus-selectable-icon-view.vala
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

public class SelectableIconView : Gtk.IconView
{
  public enum Column
  {
    SELECTED,
    ITEM,
    N_COLUMNS
  }

  /**
   * The current {@link Virtaus.View.Mode}.
   *
   * Only DEFAULT and SELECTION are supported.
   */
  private View.Mode _mode = View.Mode.DEFAULT;
  public View.Mode mode
  {
    get {return _mode;}
    set
    {
      if (_mode != value)
      {
        _mode = value;

        if (value != View.Mode.SELECTION)
          this.unselect_all ();

        renderer.toggle_visible = (_mode == View.Mode.SELECTION);

        this.queue_draw ();

        this.notify_property ("mode");
      }
    }
  }

  /**
   * The internal {@link Virtaus.SelectableCellRenderer}.
   */
  private Virtaus.SelectableCellRenderer renderer;

  public SelectableIconView ()
  {
    int tile_width, tile_height;

    Object (selection_mode: Gtk.SelectionMode.NONE, mode: View.Mode.DEFAULT);

    this.get_style_context ().add_class ("content-view");

    // The internal ListStore
    model = new Gtk.ListStore (Column.N_COLUMNS, typeof (bool), typeof (Virtaus.SelectableItem));

    // Cell renderer
    tile_width = SelectableCellRenderer.TILE_SIZE + 2 * SelectableCellRenderer.TILE_MARGIN;
    tile_height = SelectableCellRenderer.TILE_SIZE + 2 * SelectableCellRenderer.TILE_MARGIN;

    renderer = new Virtaus.SelectableCellRenderer ();
    renderer.set_alignment (0.5f, 0.5f);
    renderer.set_fixed_size (tile_width, tile_height);

    this.pack_start (renderer, false);
    this.add_attribute (renderer, "checked", Column.SELECTED);

    this.set_cell_data_func (renderer, (column, cell, model, iter) =>
    {
      SelectableItem? item;

      model.get (iter, SelectableIconView.Column.ITEM, out item);

      if (item != null)
      {
        SelectableCellRenderer renderer = cell as SelectableCellRenderer;

        renderer.text = item.name;
        renderer.pixbuf = item.pixbuf;
      }
    });
  }

  public override bool button_press_event (Gdk.EventButton event)
  {
    Gtk.TreePath? path;

    path = get_path_at_pos ((int) event.x, (int) event.y);

    if (path != null)
    {
      // On right click, swicth to selection mode automatically
      if (event.button == Gdk.BUTTON_SECONDARY)
        mode = View.Mode.SELECTION;

      if (mode == View.Mode.SELECTION)
      {
        Gtk.ListStore store;
        Gtk.TreeIter i;

        store = model as Gtk.ListStore;

        if (store.get_iter (out i, path))
        {
          bool selected;
          SelectableItem item;

          store.get (i, Column.SELECTED, out selected, Column.ITEM, out item);

          store.set (i, Column.SELECTED, !selected);
          selection_changed ();
        }
      }
      else
      {
        item_activated (path);
      }
    }

    return false;
  }

  public void add_item (Virtaus.SelectableItem item)
  {
      Gtk.ListStore store = model as Gtk.ListStore;
      Gtk.TreeIter i;

      store.append (out i);

      store.set (i, Column.SELECTED, false, Column.ITEM, item);
  }

  public void prepend (Object item) {
      Gtk.ListStore store = model as Gtk.ListStore;
      Gtk.TreeIter i;

      store.insert (out i, 0);

      store.set (i, Column.SELECTED, false, Column.ITEM, item);
  }

  // Redefine selection handling methods since we handle selection manually
  public new List<Gtk.TreePath> get_selected_items ()
  {
    List<Gtk.TreePath> items = new List<Gtk.TreePath> ();

    this.model.foreach ((model, path, iter) =>
    {
      bool selected;
      (model as Gtk.ListStore).get (iter, Column.SELECTED, out selected);

      if (selected)
        items.prepend (path);

      return false;
    });

    items.reverse ();

    return (owned) items;
  }

  public new void select_all ()
  {
    Gtk.ListStore model = get_model() as Gtk.ListStore;

    model.foreach ((model, path, iter) =>
    {
      SelectableItem? item;
      (model as Gtk.ListStore).get (iter, Column.ITEM, out item);

      if (item != null)
        (model as Gtk.ListStore).set (iter, Column.SELECTED, true);

      return false;
    });

    selection_changed ();
  }

  public new void unselect_all ()
  {
    Gtk.ListStore model = get_model() as Gtk.ListStore;

    model.foreach ((model, path, iter) =>
    {
      (model as Gtk.ListStore).set (iter, Column.SELECTED, false);

      return false;
    });

    selection_changed ();
  }

  public void remove_selected () {
    List<Gtk.TreePath> paths = this.get_selected_items ();

    paths.reverse ();

    foreach (Gtk.TreePath path in paths)
    {
      Gtk.TreeIter i;

      if ((model as Gtk.ListStore).get_iter (out i, path))
            (model as Gtk.ListStore).remove (i);
    }

    selection_changed ();
  }

}

public interface SelectableItem : GLib.Object
{
  public abstract string? name {get;}
  public abstract Gdk.Pixbuf? pixbuf {get; default = null;}
}

/**
 * A cell renderer that supports being selected,
 * displaying a check box instead of painting the
 * whole cell area.
 */
private class SelectableCellRenderer : Gtk.CellRendererPixbuf
{
  public const int TILE_SIZE = 196;
  public const int CHECK_ICON_SIZE = 32;
  public const int TILE_MARGIN = CHECK_ICON_SIZE / 4;

  public bool checked {get; set; default = false;}
  public bool toggle_visible {get; set; default = false;}
  public string? text {get; set; default = null;}

  public SelectableCellRenderer () {}

  public override void render (Cairo.Context cr, Gtk.Widget widget, Gdk.Rectangle background_area,
                               Gdk.Rectangle cell_area, Gtk.CellRendererState flags)
  {
    Gtk.StyleContext context;
    Pango.Layout layout;
    int w, text_w, text_h, xpad, ypad;
    double x, y;

    context = widget.get_style_context ();
    context.add_class ("selectable-item-renderer");

    this.get_padding (out xpad, out ypad);

    // Draw the background
    context.render_background (cr, background_area.x, background_area.y, background_area.width, background_area.height);
    context.render_frame (cr, background_area.x, background_area.y, background_area.width, background_area.height);

    Gdk.cairo_rectangle (cr, cell_area);
    cr.clip ();

    cr.translate (cell_area.x, cell_area.y);

    // draw the tile
    if (pixbuf != null)
    {
      Gdk.Rectangle area = {0, 0, TILE_SIZE, TILE_SIZE};
      base.render (cr, widget, area, area, flags);
    }

    // draw text at bottom
    w = cell_area.width - 2 * xpad;

    layout = widget.create_pango_layout (text ?? "");
    layout.set_width (w * Pango.SCALE);
    layout.set_alignment (Pango.Alignment.CENTER);
    layout.get_pixel_size (out text_w, out text_h);

    x = xpad;
    y = cell_area.height - text_h - TILE_MARGIN;

    context.render_layout (cr, x, y, layout);

    // draw the overlayed checkbox
    if (toggle_visible)
    {
      int x_offset, check_x, check_y;

      if (widget.get_direction () == Gtk.TextDirection.RTL)
        x_offset = xpad;
      else
        x_offset = cell_area.width - CHECK_ICON_SIZE - xpad;

      check_x = x_offset;
      check_y = cell_area.height - CHECK_ICON_SIZE - ypad - text_h;

      context.save ();
      context.add_class (Gtk.STYLE_CLASS_CHECK);

      if (checked)
        context.set_state (Gtk.StateFlags.CHECKED);

      context.render_check (cr, check_x, check_y, CHECK_ICON_SIZE, CHECK_ICON_SIZE);
      context.restore ();
    }
  }
}


/**
 * Default implementation for Collections.
 */
public class CollectionIconItem : GLib.Object, Virtaus.SelectableItem
{
  public Core.Collection collection {get; construct set;}
  public string? name {get {return collection.name;}}
  public Gdk.Pixbuf? pixbuf
  {
    get
      {
        Gtk.Image image = new Gtk.Image.from_icon_name ("image-x-generic-symbolic", Gtk.IconSize.DIALOG);
        image.show ();
        return image.get_pixbuf ();
      }
  }

  public CollectionIconItem (Virtaus.Core.Collection collection)
  {
    this.collection = collection;
  }
}
}
