-----------------------------------------------------------------------
--               GtkAda - Ada95 binding for Gtk+/Gnome               --
--                                                                   --
--   Copyright (C) 1998-2000 E. Briot, J. Brobecker and A. Charlet   --
--                Copyright (C) 2000-2011, AdaCore                   --
--                                                                   --
-- This library is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This library is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this library; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-- As a special exception, if other files instantiate generics from  --
-- this unit, or you link this unit with other files to produce an   --
-- executable, this  unit  does not  by itself cause  the resulting  --
-- executable to be covered by the GNU General Public License. This  --
-- exception does not however invalidate any other reasons why the   --
-- executable file  might be covered by the  GNU Public License.     --
-----------------------------------------------------------------------

--  <description>
--  This widget serves as separator between menu items. It is represented
--  graphically as a horizontal line between two items, and is used to group
--  items into meaningful groups.
-- 
--  </description>
--  <group>Menus and Toolbars</group>

pragma Warnings (Off, "*is already use-visible*");
with Glib;          use Glib;
with Gtk.Menu_Item; use Gtk.Menu_Item;

package Gtk.Separator_Menu_Item is

   type Gtk_Separator_Menu_Item_Record is new Gtk_Menu_Item_Record with null record;
   type Gtk_Separator_Menu_Item is access all Gtk_Separator_Menu_Item_Record'Class;

   ------------------
   -- Constructors --
   ------------------

   procedure Gtk_New (Widget : out Gtk_Separator_Menu_Item);
   procedure Initialize
      (Widget : access Gtk_Separator_Menu_Item_Record'Class);

   function Get_Type return Glib.GType;
   pragma Import (C, Get_Type, "gtk_separator_menu_item_get_type");

end Gtk.Separator_Menu_Item;
