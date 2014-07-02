------------------------------------------------------------------------------
--                  GtkAda - Ada95 binding for Gtk+/Gnome                   --
--                                                                          --
--                     Copyright (C) 2014, AdaCore                          --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
------------------------------------------------------------------------------

package body Gtkada.Canvas_View.Models is

   package body Rtree_Models is

      -------------
      -- Gtk_New --
      -------------

      procedure Gtk_New (Self : out Rtree_Model) is
      begin
         Self := new Rtree_Model_Record;
         Rtree_Models.Initialize (Self);
      end Gtk_New;

      ----------------
      -- Initialize --
      ----------------

      procedure Initialize
         (Self : not null access Rtree_Model_Record'Class)
      is
      begin
         Gtkada.Canvas_View.Initialize (Self);
      end Initialize;

      --------------------
      -- Refresh_Layout --
      --------------------

      overriding procedure Refresh_Layout
        (Self   : not null access Rtree_Model_Record)
      is
         procedure On_Item (It : not null access Abstract_Item_Record'Class);
         procedure On_Item (It : not null access Abstract_Item_Record'Class) is
         begin
            Self.Tree.Insert (It);
         end On_Item;
      begin
         Base_Model_Record (Self.all).Refresh_Layout;   --  inherited
         Self.Tree.Clear;
         Self.For_Each_Item (On_Item'Access, In_Area => No_Rectangle);
      end Refresh_Layout;

      -------------------
      -- For_Each_Item --
      -------------------

      overriding procedure For_Each_Item
        (Self     : not null access Rtree_Model_Record;
         Callback : not null access procedure
           (Item : not null access Abstract_Item_Record'Class);
         Selected_Only : Boolean := False;
         Filter        : Item_Kind_Filter := Kind_Any;
         In_Area       : Model_Rectangle := No_Rectangle)
      is
         procedure Local (It : not null access Abstract_Item_Record'Class);
         procedure Local (It : not null access Abstract_Item_Record'Class) is
         begin
            if (Filter = Kind_Any
                or else (Filter = Kind_Item and then not It.Is_Link)
                or else (Filter = Kind_Link and then It.Is_Link))
              and then (not Selected_Only or else Self.Is_Selected (It))
            then
               Callback (It);
            end if;
         end Local;

      begin
         if In_Area = No_Rectangle then
            --  use the base model: this is faster, and more importantly needed
            --  in Refresh_Layout, when the tree has not been filled yet.
            Base_Model_Record (Self.all).For_Each_Item
               (Callback, Selected_Only, Filter, In_Area);
         else
            Self.Tree.For_Each_Object (Local'Access, In_Area);
         end if;
      end For_Each_Item;

      ------------------
      -- Bounding_Box --
      ------------------

      overriding function Bounding_Box
        (Self   : not null access Rtree_Model_Record;
         Margin : Model_Coordinate := 0.0)
         return Model_Rectangle
      is
         M : constant Model_Rectangle := Self.Tree.Bounding_Box;
      begin
         if M.Width = 0.0 then
            return M;
         else
            return (M.X - Margin, M.Y - Margin,
                    M.Width + 2.0 * Margin, M.Height + 2.0 * Margin);
         end if;
      end Bounding_Box;

      ----------------------
      -- Toplevel_Item_At --
      ----------------------

      overriding function Toplevel_Item_At
        (Self    : not null access Rtree_Model_Record;
         Point   : Model_Point;
         Context : Draw_Context) return Abstract_Item
      is
         use Items_Lists;
         R : constant Model_Rectangle :=
            (X => Point.X, Y => Point.Y, Width => 1.0, Height => 1.0);

         --  Compute the list of items whose bounding box contains Point.
         --  We will need to filter this list by checking the actual item
         --  border.
         Items : constant Items_Lists.List := Self.Tree.Find (R);

         C : Items_Lists.Cursor := Items.First;
         It : Abstract_Item;
      begin
         while Has_Element (C) loop
            It := Element (C);
            if It.Contains (Model_To_Item (It, Point), Context) then
               return It;
            end if;
            Next (C);
         end loop;
         return null;
      end Toplevel_Item_At;

   end Rtree_Models;

end Gtkada.Canvas_View.Models;
