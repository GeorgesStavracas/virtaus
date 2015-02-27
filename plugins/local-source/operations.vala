/* operations.vala
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

namespace Virtaus.Plugin
{

internal class ProjectOperation
{
  public static bool create (Sqlite.Database db, Cream.Project project)
    requires (project.uid == "(null)")
  {
    StringBuilder info_query;
    unowned List<string> aux;
    List<string> keys;
    string query, error;
    int rc, counter, length;

    /* Project query */
    query = "INSERT INTO 'Collection' (name, directory) VALUES ('%s', '%s')";
    query = query.printf (project.name, project["path"] ?? "");

    /* Insert */
    rc = 0;
    rc = db.exec (query, null, out error);

    if (rc != Sqlite.OK)
    {
      critical ("Error: %s", error);
      return false;
    }

    project.uid = "%d".printf ((int) db.last_insert_rowid ());

    /**
     * Build and insert the project optional
     * data after the project itself because
     * it's only after it we have the project
     * ID, needed by CollectionInfo table.
     */
    info_query = new StringBuilder ("INSERT INTO 'CollectionInfo' (collection, field, value) VALUES ");

    /* format info query */
    keys = project.get_keys ();

    counter = 0;
    length = (int) keys.length ();

    for (aux = keys; aux != null; aux = aux.next)
    {
      info_query.append_printf ("(%s, '%s', '%s')", project.uid, aux.data, project[aux.data]);

      if (counter < length - 1)
        info_query.append (",\n");

      counter++;
    }

    /* Insert */
    rc = 0;
    rc = db.exec (info_query.str, null, out error);

    if (rc != Sqlite.OK)
    {
      critical ("Error: %s", error);
      return false;
    }

    return true;
  }

  public static bool update (Sqlite.Database db, Cream.Project project)
    requires (project.uid != "(null)")
  {
    message ("update collection");
    return false;
  }

  public static bool remove (Sqlite.Database db, Cream.Project project)
    requires (project.uid != "(null)")
  {
    string query, error;
    int rc;

    /* Remove from Project */
    query = "DELETE FROM 'Collection' WHERE id=%s".printf (project.uid);

    rc = 0;
    rc = db.exec (query, null, out error);

    if (rc != Sqlite.OK)
    {
      critical ("Error: %s", error);
      return false;
    }

    /* Remove from CollectionInfo */
    query = "DELETE FROM 'CollectionInfo' WHERE collection=%s".printf (project.uid);

    rc = db.exec (query, null, out error);

    if (rc != Sqlite.OK)
    {
      critical ("Error: %s", error);
      return false;
    }

    return true;
  }

  public static GLib.List<Cream.Project> load_all (SqliteSource instance, Sqlite.Database db, Cream.Context context)
  {
    GLib.List<Cream.Project> list;
    Sqlite.Statement stmt;
    string query;
    bool valid;
    int rc;

    list = new GLib.List<Cream.Project> ();
    query = "SELECT * FROM Collection c, CollectionInfo ci WHERE c.id = ci.collection";

    /* Perform the selection */
    rc = db.prepare_v2 (query, -1, out stmt);

    if (rc != Sqlite.OK)
    {
      critical (_("Cannot connect to database."));
      return list;
    }

    /* Load each collection from the statement */
    valid = (stmt.step () == Sqlite.ROW);

    while (valid)
    {
      Cream.Project project;

      project = new Cream.Project (instance);
      project.uid = "%d".printf (stmt.column_int (0));
      project.name = stmt.column_text (1);
      project["path"] = stmt.column_text (2);

      debug ("loaded project uid:'%s', name:'%s'", project.uid, project.name);

      while (stmt.column_int (0) == project.uid.to_int ())
      {
        string key, val;

        key = stmt.column_text (4);
        val = stmt.column_text (5);

        project[key] = val;

        debug ("loaded project info ('%d,'%d') '%s':'%s'", stmt.column_int (0), stmt.column_int (3), key, val);

        valid = (stmt.step () == Sqlite.ROW);

        if (!valid)
          break;
      }

      /**
       * If the project has a model (which is required),
       * load it.
       */
      if (project["model"] != null)
        project.model = context.get_model_for_uid (project["model"]);

      list.append (project);
    }

    return list;
  }
}

}
