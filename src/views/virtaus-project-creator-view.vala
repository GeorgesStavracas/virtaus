/* -*- Mode: Vala; indent-tabs-mode: c; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * virtaus-project-creator-view.c
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

 using Gee;

namespace Virtaus.View
{

[GtkTemplate (ui = "/apps/virtaus/resources/project-creator.ui")]
public class ProjectCreatorView : Gtk.Frame, Virtaus.View.AbstractView
{
  private Virtaus.Application app;

  /**
   * Text buffers and entries.
   */
  [GtkChild]
  private Gtk.Entry age_entry;
  [GtkChild]
  private Gtk.Entry genre_entry;
  [GtkChild]
  private Gtk.TextBuffer audience_requirements_buffer;
  [GtkChild]
  private Gtk.TextBuffer consumption_power_buffer;
  [GtkChild]
  private Gtk.TextBuffer craft_proccess_buffer;
  [GtkChild]
  private Gtk.TextBuffer daily_activities_buffer;
  [GtkChild]
  private Gtk.TextBuffer features_buffer;
  [GtkChild]
  private Gtk.TextBuffer finishing_buffer;
  [GtkChild]
  private Gtk.TextBuffer frequented_places_buffer;
  [GtkChild]
  private Gtk.TextBuffer functional_configuration_buffer;
  [GtkChild]
  private Gtk.TextBuffer lifestyle_buffer;
  [GtkChild]
  private Gtk.TextBuffer materials_buffer;
  [GtkChild]
  private Gtk.TextBuffer needs_desires_buffer;
  [GtkChild]
  private Gtk.TextBuffer physical_features_buffer;
  [GtkChild]
  private Gtk.TextBuffer products_buffer;
  [GtkChild]
  private Gtk.TextBuffer providers_buffer;
  [GtkChild]
  private Gtk.TextBuffer qualities_buffer;
  [GtkChild]
  private Gtk.TextBuffer requirements_buffer;
  [GtkChild]
  private Gtk.TextBuffer structure_buffer;
  [GtkChild]
  private Gtk.TextBuffer style_elements_buffer;
  [GtkChild]
  private Gtk.TextBuffer use_cases_buffer;
  [GtkChild]
  private Gtk.TextBuffer viability_analisys_buffer;
  [GtkChild]
  private Gtk.TextBuffer virtues_buffer;

  [GtkChild]
  private Gtk.Entry author_entry;
  [GtkChild]
  private Gtk.Entry email_entry;
  [GtkChild]
  private Gtk.Entry project_name_entry;
  [GtkChild]
  private Gtk.Box location_box;
  [GtkChild]
  private Gtk.Stack stack;
  [GtkChild]
  private Gtk.Label review_location_label;
  [GtkChild]
  private Gtk.ListBox sources_listbox;
  [GtkChild]
  private Gtk.ListBox models_listbox;
  [GtkChild]
  private Gtk.Image model_image;

  /* Binding between location selector & location label */
  GLib.Binding location_bind = null;

  /**
   * Disable the search.
   */
  public bool has_search
  {
    get {return false;}
  }

  /**
   * Disable selection mode.
   */
  public bool has_selection
  {
    get {return false;}
  }

  public Gtk.SearchBar? search_bar
  {
    get {return null;}
  }

  /**
   * Title and subtitle.
   */
  public string? title {get {return _("New Project");}}
  public string? subtitle {get {return null;}}
  public Gtk.Widget? titlebar_widget {get {return null;}}

  /**
   * A map of uid -> data source
   */
  private HashMap<string, Cream.DataSource> uid_to_source = new HashMap<string, Cream.DataSource> ();

  /**
   * {@link Virtaus.View.Mode} implementation.
   */
  public Mode mode
  {
    get {return Mode.DEFAULT;}
    set {}
  }

  private string[] pages = {"source_selection", "project_info", "additional_info", "review"};
  private int active_page = 0;

  private Gtk.Button cancel_button;
  private Gtk.Button back_button;
  private Gtk.Button continue_button;
  private Gtk.Box button_box;

  public ProjectCreatorView (Virtaus.Application app)
  {
    this.app = app;

    /* buttons */
    this.cancel_button = new Gtk.Button.with_label (_("Cancel"));
    this.cancel_button.clicked.connect (cancel_button_clicked_cb);

    this.button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);

    this.back_button = new Gtk.Button.with_label (_("Back"));
    this.back_button.clicked.connect (page_button_clicked_cb);
    this.back_button.sensitive = false;

    this.continue_button = new Gtk.Button.with_label (_("Continue"));
    this.continue_button.clicked.connect (page_button_clicked_cb);
    this.continue_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

    this.button_box.add (this.back_button);
    this.button_box.add (this.continue_button);
    this.button_box.show_all ();

    /* load data sources */
    app.context.plugin_manager.data_source_registered.connect (add_source);
    app.context.plugin_manager.data_source_unregistered.connect (remove_source);

    foreach (string key in app.context.plugin_manager.data_sources.keys)
      add_source (app.context.plugin_manager.data_sources.get (key), key);

    /* load models */
    app.context.model_added.connect (add_model_cb);
    app.context.model_removed.connect (remove_model_cb);

    app.context.models.foreach ((model)=>
    {
      add_model_cb (model);
    });

    this.show_all ();
  }

  public void search (string? query)
  {
    /* TODO: implement search */
  }

  public new void activate ()
  {
    /* wipe out previous data */
    clear_pages ();

    /* return to the first page */
    active_page = 0;
    update_page ();

    register_widget (Virtaus.WindowLocation.HEADERBAR, this.cancel_button, Gtk.Align.START, Gtk.Align.START);
    register_widget (Virtaus.WindowLocation.HEADERBAR, this.button_box, Gtk.Align.END, Gtk.Align.START);
  }

  public void deactivate ()
  {
    /* TODO: something to implement here? */
  }

  private void add_source (Cream.ExtensionInfo source, string uid)
  {
    Cream.DataSource data_source;
    Gtk.ListBoxRow row;

    /* FIXME: it should support source images */
    data_source = app.context.plugin_manager.data_sources[uid].instance as Cream.DataSource;
    row = new Gtk.ListBoxRow ();
    row.height_request = 40;

    row.add (new Gtk.Label (data_source.name));
    row.set_data ("source", source.instance);

    uid_to_source[uid] = data_source;

    row.show_all ();
    sources_listbox.add (row);
  }

  private void remove_source (string uid)
  {
    GLib.List<Gtk.Widget> children;
    Cream.DataSource data_source;
    Gtk.ListBoxRow? row;

    data_source = uid_to_source[uid] as Cream.DataSource;
    children = sources_listbox.get_children ();

    /* Search for the correct row */
    row = null;

    children.foreach ((entry)=>
    {
      if (entry.get_data<Cream.DataSource> ("source") == data_source)
      {
        row = entry as Gtk.ListBoxRow;
        return;
      }
    });

    if (row == null)
      return;

    /* Remove things */
    row.destroy ();
    uid_to_source.unset (uid);
  }

  /**
   * Revalidate the first page when
   * the selected source changes.
   */
  [GtkCallback]
  private void row_selected_cb (Gtk.ListBoxRow? row)
  {
    Cream.DataSource source;
    GLib.List<weak Gtk.Widget> children;
    Gtk.Widget old_selector;

    children = location_box.get_children ();
    old_selector = (children != null ? children.data : null);

    /* Remove old selectors */
    if (old_selector != null)
    {
      location_box.remove (old_selector);

      // Clear the old binding
      if (location_bind != null)
      {
        location_bind.unbind ();
        location_bind = null;
      }
    }

    if (row == null)
      return;

    /* Retrieve the data source */
    source = row.get_data ("source");

    /* Add the selector */
    location_box.add (source.location_selector);
    location_bind = source.location_selector.bind_property ("location", review_location_label, "label");

    source.location_selector.show ();

    /* Revalidate the page */
    validate_page (active_page);
  }

  /**
   * Updates the current selected model
   */
  [GtkCallback]
  private void model_listbox_row_selected_cb (Gtk.ListBoxRow? row)
  {
    Cream.Model model;

    if (row == null)
      return;

    model = row.get_data ("model");
    model_image.pixbuf = model.icon;

    validate_page (active_page);
  }

  /**
   * Revalidate the page every time
   * the name or author changes.
   */
  [GtkCallback]
  private void entry_changed_cb ()
  {
    validate_page (active_page);
  }

  private void cancel_button_clicked_cb ()
  {
    show_view ("project-selector");
  }

  private void add_model_cb (Cream.Model model)
  {
    Gtk.ListBoxRow row;
    Gtk.Label name, author;
    Gtk.Box box;

    name = new Gtk.Label (model.name);
    name.xalign = 0;

    author = new Gtk.Label (null);
    author.set_markup ("<span size='small'>%s</span>".printf (model.author));
    author.get_style_context ().add_class ("dim-label");
    author.xalign = 0;

    row = new Gtk.ListBoxRow ();

    box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
    box.border_width = 12;

    box.add (name);
    box.add (author);
    row.add (box);

    row.show_all ();
    row.set_data ("model", model);

    models_listbox.add (row);
  }

  private void remove_model_cb (Cream.Model model)
  {
    GLib.List<weak Gtk.Widget> children;

    children = models_listbox.get_children ();

    children.foreach ((child)=>
    {
      if (child.get_data<Cream.Model> ("model") == model)
        models_listbox.remove (child);
    });
  }

  private void page_button_clicked_cb (Gtk.Button button)
  {
    if (button == this.back_button)
      active_page--;
    else
      active_page++;

    /* TODO: validate and sensitivilize create button */

    update_page ();
  }

  private void update_page ()
  {
    if (active_page < pages.length)
    {
      stack.visible_child_name = pages[active_page];
      back_button.sensitive = (active_page != 0);
      continue_button.label = (active_page == pages.length - 1 ? _("Create") : _("Continue"));
    }
    else
    {
      create_project ();
      active_page--;
    }

    validate_page (active_page);
  }

  /**
   * Mainly set the continue_button sensitivity.
   * Also, it updates the location_box child.
   */
  private void validate_page (int page)
  {
    bool valid;

    switch (page)
    {
      case 0:
        valid = (sources_listbox.get_selected_row () != null);
        break;

      case 1:
        valid = (project_name_entry.text != "" && author_entry.text != "" &&
                 models_listbox.get_selected_row () != null);
        break;

      /* The last two pages has no required fields */
      case 2:
      case 3:
        valid = true;
        break;

      default:
        valid = true;
        break;
    }

    continue_button.sensitive = valid;
  }

  private void create_project ()
  {
    Cream.Project project;
    Cream.DataSource source;

    /* Selected source */
    source = sources_listbox.get_selected_row ().get_data ("source");

    /* Build up project */
    project = new Cream.Project (source);
    project.name = project_name_entry.text;
    project["author"] = author_entry.text;
    project["email"] = email_entry.text;
    project["path"] = source.location_selector.location;

    project["audience-age"] = age_entry.text;
    project["audience-consumption-power"] = consumption_power_buffer.text;
    project["audience-daily-activities"] = daily_activities_buffer.text;
    project["audience-frequented-places"] = frequented_places_buffer.text;
    project["audience-genre"] = genre_entry.text;
    project["audience-lifestyle"] = lifestyle_buffer.text;
    project["audience-needs-desires"] = needs_desires_buffer.text;
    project["audience-physical-features"] = physical_features_buffer.text;
    project["audience-requirements"] = audience_requirements_buffer.text;
    project["audience-virtues"] = virtues_buffer.text;

    project["competitors-products"] = products_buffer.text;
    project["competitors-qualities"] = qualities_buffer.text;
    project["competitors-structure"] = structure_buffer.text;

    project["product-craft-proccess"] = craft_proccess_buffer.text;
    project["product-features"] = features_buffer.text;
    project["product-finishing"] = finishing_buffer.text;
    project["product-functional-configuration"] = functional_configuration_buffer.text;
    project["product-materials"] = materials_buffer.text;
    project["product-providers"] = providers_buffer.text;
    project["product-requirements"] = requirements_buffer.text;
    project["product-style-elements"] = style_elements_buffer.text;
    project["product-use-cases"] = use_cases_buffer.text;
    project["product-viability-analisys"] = viability_analisys_buffer.text;

    project["model"] = models_listbox.get_selected_row ().get_data<Cream.Model> ("model").uid;

    /* Save the project */
    message ("project id: %d", project.id);
    source.save (project as Cream.BaseObject);

    /* Return to the Project view */
    show_view ("project-selector");
  }

  private void clear_pages ()
  {
    author_entry.text = "";
    age_entry.text = "";
    audience_requirements_buffer.text = "";
    project_name_entry.text = "";
    consumption_power_buffer.text = "";
    craft_proccess_buffer.text = "";
    daily_activities_buffer.text = "";
    email_entry.text = "";
    features_buffer.text = "";
    finishing_buffer.text = "";
    frequented_places_buffer.text = "";
    functional_configuration_buffer.text = "";
    genre_entry.text = "";
    lifestyle_buffer.text = "";
    materials_buffer.text = "";
    needs_desires_buffer.text = "";
    physical_features_buffer.text = "";
    products_buffer.text = "";
    providers_buffer.text = "";
    qualities_buffer.text = "";
    requirements_buffer.text = "";
    structure_buffer.text = "";
    style_elements_buffer.text = "";
    use_cases_buffer.text = "";
    viability_analisys_buffer.text = "";
    virtues_buffer.text = "";
  }
}
}
