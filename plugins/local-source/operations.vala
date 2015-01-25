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

using Gee;

namespace Virtaus.Plugin
{

internal class CollectionOperation
{
  public static bool create (Sqlite.Database db, Virtaus.Core.Collection collection)
  {
    message ("create collection");
    return false;
  }

  public static bool update (Sqlite.Database db, Virtaus.Core.Collection collection)
  {
    message ("update collection");
    return false;
  }

  public static bool remove (Sqlite.Database db, Virtaus.Core.Collection collection)
  {
    message ("remove collection");
    return false;
  }

  public static LinkedList<Virtaus.Core.Collection> load_all (SqliteSource instance, Sqlite.Database db)
  {
    LinkedList<Virtaus.Core.Collection> list;
    Sqlite.Statement stmt;
    string query;
    int rc;

    list = new LinkedList<Virtaus.Core.Collection> ();
    query = "SELECT * FROM 'Collection'";

    /* Perform the selection */
    rc = db.prepare_v2 (query, -1, out stmt);

    if (rc != Sqlite.OK)
    {
      critical (_("Cannot connect to database."));
      return list;
    }

    /* Load each collection from the statement */
    while (stmt.step () == Sqlite.ROW)
    {
      Virtaus.Core.Collection collection;

      collection = new Virtaus.Core.Collection (instance);
      collection.id = stmt.column_int (0);
      collection.name = stmt.column_text (1);
      collection.info["path"] = stmt.column_text (2);

      list.add (collection);
    }

    return list;
  }
}

}
