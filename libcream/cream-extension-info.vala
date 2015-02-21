/* -*- Mode: Vala; indent-tabs-mode: t; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * cream-extension-info.c
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
 
public class Cream.ExtensionInfo : GLib.Object
{
    public string name {public get; public set; default = "";}
    public string author {public get; public set; default = "";}
    public string description {public get; public set; default = "";}
    public string short_description {public get; public set; default = "";}
    public Gtk.License license {public get; public set; default = Gtk.License.UNKNOWN;}

    public GLib.Object instance {public get; public set; default = null;}
}
