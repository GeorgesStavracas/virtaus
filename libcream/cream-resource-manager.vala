/* cream-resource-manager.vala
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

public class Cream.ResourceManager : GLib.Object
{
  protected const string RESOURCE_EXTENSION_POINT = "cream-resource-point";
  protected const string RESOURCE_HANDLER_EXTENSION_POINT = "cream-resource-handler-point";

  public unowned Cream.Context context {get; construct;}

  private unowned GLib.IOExtensionPoint resources_point;
  private unowned GLib.IOExtensionPoint handlers_point;

  /**
   * A map of types and the corresponding {@link Cream.ResourceHandler}.
   */
  private GLib.HashTable<string, GLib.Type> handler_for_type;

  public ResourceManager (Cream.Context context)
  {
    Object (context: context);

    resources_point = GLib.IOExtensionPoint.register (RESOURCE_EXTENSION_POINT);
    resources_point.set_required_type (typeof (Cream.Resource));

    handlers_point = GLib.IOExtensionPoint.register (RESOURCE_HANDLER_EXTENSION_POINT);
    handlers_point.set_required_type (typeof (Cream.ResourceHandler));

    handler_for_type = new GLib.HashTable<string, GLib.Type> (GLib.str_hash, GLib.str_equal);
  }

  /**
   * Register a new resource type.
   */
  public void register_resource (GLib.Type type, string extension_name)
    requires (type == typeof (Cream.Resource))
  {
    GLib.IOExtensionPoint.implement (RESOURCE_EXTENSION_POINT, type, extension_name, 0);
  }

  /**
   * Register a new resource handler.
   */
  public void register_handler (GLib.Type type, string extension_name, int priority)
    requires (type == typeof (Cream.ResourceHandler))
  {
    Cream.ResourceHandler handler;

    GLib.IOExtensionPoint.implement (RESOURCE_HANDLER_EXTENSION_POINT, type, extension_name, priority);

    /* register the types */
    handler = GLib.Object.new (type, null) as Cream.ResourceHandler;

    handler.types.foreach ((t)=>
    {
      /* FIXME: should respect the priority field */
      handler_for_type.insert (t, type);
    });
  }

  /**
   * Retrieve the handler for the given resource.
   */
  public Cream.ResourceHandler? get_handler (Cream.Resource resource)
  {
    GLib.Type? type;
    
    type = handler_for_type.lookup (resource.resource_type);
    
    if (type == null)
      return null;
    
    return GLib.Object.new (type, null) as Cream.ResourceHandler;
  }
}
