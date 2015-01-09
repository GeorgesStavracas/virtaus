/* -*- Mode: Vala; indent-tabs-mode: t; c-basic-offset: 2; tab-width: 2 -*-  */
/*
 * virtaus-core-enums.c
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

public enum DataType
{
	ATTRIBUTE,
	CATEGORY,
	COLLECTION,
	COLLECTION_INFO,
	ITEM,
	NONE,
	PRODUCT,
	SET;
}

/**
 * The interface location. This is 
 */
public enum InterfaceLocation
{
  ACTIONBAR,
  HEADERBAR,
  VIEW;
}

public enum PluginType
{
	EXPORTER,
	EXTENSION,
	DATA_SOURCE,
	FILTER,
	PLUGIN;
}

public enum SyncStatus
{
	END,
	ERROR,
	START,
	SUCCESS;
}

}
