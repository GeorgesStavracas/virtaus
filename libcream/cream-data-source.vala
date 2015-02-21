/* -*- Mode: Vala; indent-tabs-mode: t; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * cream-data-source.c
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
 
namespace Cream
{

/**
 * An interface to define data sources. The whole management is up to the implementing source.
 */
public interface DataSource : GLib.Object
{
	public signal void register_source (GLib.Type source);
	public signal void sync (Cream.SyncStatus status);
	public signal void saved (Cream.BaseObject object);
	public signal void removed (Cream.BaseObject object);

  /**
   * Every data source must provide a way
   * to select the location in which the
   * collection will be created.
   */
  public abstract LocationSelector location_selector {get;}

  /**
   * The user-visible name of the source.
   */
	public abstract string name {get;}

	/**
   * The technical name of the source.
   */
  public abstract string source_name {get;}

  /**
   * The unique identifier of the source.
   *
   * Usually 'name.source_name@author'.
   */
  public abstract string uid {get;}

  /**
   * The read-only list of collections.
   *
   * It is completely up to the implementor class
   * to define how this will be retrieved.
   */
  public abstract Gee.LinkedList<Collection>? collections {get;}

  public abstract bool save (BaseObject object);
  public abstract bool remove (BaseObject object);
}

public interface LocationSelector : Gtk.Widget
{
  /**
   * Retrieve the location of the data source.
   *
   * It doesn't have to be a valid directory path,
   * as it can be anything if the implementing
   * source can understand.
   */
  public abstract string? location {owned get; default = null;}
}

}
