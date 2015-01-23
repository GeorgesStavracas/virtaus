/* -*- Mode: Vala; indent-tabs-mode: t; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * virtaus-core-data-source.c
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

/**
 * An interface to define data sources. The whole management is up to the implementing source.
 */
public interface DataSource : GLib.Object
{
	public signal void register_source (GLib.Type source);
	public signal void sync (Virtaus.Core.SyncStatus status);

	public abstract string get_name ();
  public abstract string get_source_name ();

  public abstract Gee.LinkedList<Collection> get_collections ();

  public abstract bool save (BaseObject object);
  public abstract bool remove (BaseObject object);
}

}
