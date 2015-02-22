/* cream-settings.vala
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

public class Cream.Settings : GLib.Object
{
  public unowned Cream.Context context {get; construct set;}

  /**
   * The fallback schema when no schema is given.
   */
  public string default_schema {get; construct set;}

  /**
   * A map between the schema ids and the reference {@link GLib.Settings}.
   */
  GLib.HashTable<string, GLib.Settings> map;

  public Settings (Cream.Context ctx, string default_schema)
  {
    Object (context: ctx, default_schema: default_schema);

    map = new GLib.HashTable<string, GLib.Settings> (GLib.str_hash, GLib.str_equal);
  }

  /**
   * Applies any changes that have been made to the settings.
   *
   * This function does nothing unless this is in 'delay-apply' mode; see delay. In
   * the normal case settings are always applied immediately.
   */
  public void apply (string? schema_id = default_schema)
  {
    if (!map.contains (schema_id))
      create_schema (schema_id);

    map.lookup (schema_id).apply ();
  }

  /**
   * Create a binding between the key in the this object and the property property of object.
   *
   * The binding uses the default GIO mapping functions to map between the settings and
   * property values. These functions handle booleans, numeric types and string types in
   * a straightforward way. Use bind_with_mapping  if you need a custom mapping, or map
   * between types that are not supported by the default mapping functions.
   *
   * Unless the flags include g_settings_bind_no_sensitivity, this function also establishes
   * a binding between the writability of key and the "sensitive" property of object (if
   * object has a boolean property by that name). See bind_writable for more details about
   * writable bindings.
   *
   * Note that the lifecycle of the binding is tied to the object, and that you can have only
   * one binding per object property. If you bind the same property twice on the same object,
   * the second binding overrides the first one.
   */
  public void bind (string key, GLib.Object object, string property, GLib.SettingsBindFlags flags,
                    string? schema_id = default_schema)
  {
    if (!map.contains (schema_id))
      create_schema (schema_id);

    map.lookup (schema_id).bind (key, object, property, flags);
  }

  /**
   * Gets the value that is stored at key in this.
   *
   * A convenience variant of @get for booleans.
   *
   * It is a programmer error to give a key that isn't specified as having a boolean type in the
   * schema for this.
   */
  public bool get_boolean (string key, string? schema_id = default_schema)
  {
    if (!map.contains (schema_id))
      create_schema (schema_id);

    return map.lookup (schema_id).get_boolean (key);
  }

  /**
   * Gets the value that is stored at key in this.
   *
   * A convenience variant of @get for 32-bit integers.
   *
   * It is a programmer error to give a key that isn't specified as having a int32 type type in
   * the schema for this.
   */
  public int get_int (string key, string? schema_id = default_schema)
  {
    if (!map.contains (schema_id))
      create_schema (schema_id);

    return map.lookup (schema_id).get_int (key);
  }

  /**
   * Gets the value that is stored at key in this.
   *
   * A convenience variant of @get for strings.
   *
   * It is a programmer error to give a key that isn't specified as having a string type type in
   * the schema for this.
   */
  public string get_string (string key, string? schema_id = default_schema)
  {
    if (!map.contains (schema_id))
      create_schema (schema_id);

    return map.lookup (schema_id).get_string (key);
  }

  /**
   * Gets the reference {@link GLib.Settings} related to the given schema.
   *
   * If none exists, a new one will be created and returned.
   */
  public GLib.Settings get_settings (string? schema_id = default_schema)
  {
    if (!map.contains (schema_id))
      create_schema (schema_id);

    return map.lookup (schema_id);
  }

  /**
   * Create a schema where none exists.
   */
  private void create_schema (string schema_id)
  {
    map.insert (schema_id, new GLib.Settings (schema_id));
  }
}
