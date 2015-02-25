/* cream-base-object.vala
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

public class Cream.BaseObject : GLib.Object
{
  /**
   * Unique identifier of the object
   */
  public string uid {get; set; default = "(null)";}

  /**
   * User visible name of the object.
   */
  public string name {public get; public set; default = "";}

  /**
   * The {@link Cream.DataSource} that generated this object.
   */
  public DataSource source {public get; construct set;}
}
