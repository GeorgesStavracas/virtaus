/* -*- Mode: Vala; indent-tabs-mode: t; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * virtaus-core-types.c
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

namespace Virtaus.Core
{

public class BaseObject : GLib.Object
{
	protected int id {get; set; default = -1;}
	public string name {public get; public set; default = "";}
}

public class Attribute : BaseObject
{
	public Gee.HashMap <string, Item> item_map {public get; construct set;}
	public Category parent {public get; construct set;}
  public int z_index {public get; public set;}

  public Attribute (Category parent)
  {
		this.parent = parent;
		this.item_map = new Gee.HashMap <string, Item> ();
		this.z_index = 0;
  }
}

public class Category : BaseObject
{
	public Gdk.Rectangle rect {public get; public set;}
	public Collection parent {public get; construct set;}
	public Gee.HashMap <string, Attribute> attributes {public get; construct set;}
	public Gee.HashMap <string, Product> products {public get; construct set;}

	public Category (Collection parent)
  {
		this.parent = parent;
		this.attributes = new Gee.HashMap <string, Attribute> ();
		this.products = new Gee.HashMap <string, Product> ();
  }
}

public class Collection : BaseObject
{
	public Gee.HashMap <string, string> info {public get; construct set;}
	public Gee.HashMap <string, Category> categories {public get; construct set;}
	public Gee.HashMap <string, Set> sets {public get; construct set;}

	public Collection ()
  {
		this.sets = new Gee.HashMap <string, Set> ();
		this.info = new Gee.HashMap <string, string> ();
		this.categories = new Gee.HashMap <string, Category> ();
  }
}

public class Item : BaseObject
{
	public string filename {public get; public set;}
	public Gdk.Pixbuf image {public get; public set;}
	public string image_path {public get; public set;}
	public Attribute parent {public get; construct set;}

	public Item (Attribute parent)
  {
		this.parent = parent;
		this.filename = "";
  }
}

public class Product : BaseObject
{
	public Gee.HashMap <string, Item> items {public get; construct set;}
	public Category parent {public get; construct set;}

	public Product (Category parent)
  {
		this.parent = parent;
		this.items =  new Gee.HashMap <string, Item> ();
  }
}

public class Set : BaseObject
{
	public Gee.HashMap <string, Product> products {public get; construct set;}
	public Collection parent {public get; construct set;}

	public Set (Collection parent)
  {
		this.parent = parent;
		this.products =  new Gee.HashMap <string, Product> ();
  }
}

}
