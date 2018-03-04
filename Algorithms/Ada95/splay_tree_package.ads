-- Generic Package Specification for Splay_Tree_Package
--
-- Requires:
--     Instantiated with any private type and
--     a "<" function for that type and
--     a Put procedure for that type
-- Types defined:
--     Tree_Ptr            private type
--     Splay_Tree          limited private type
-- Exceptions defined:
--     Item_Not_Found      raised when searches or deletions fail
-- Operations defined:
--     (* throws Item_Not_Found)
--     Initialize and Finalize are defined for Splay_Tree
--     Delete *            removes item from splay tree
--     Find  *             splays item
--     Insert              insert item into splay tree
--     Make_Empty          make splay tree empty
--     Print_Tree          print splay tree in sorted order
--     Retrieve *          returns item in root of splay tree

with Ada.Finalization;
with Text_IO; use Text_IO;

generic
    type Element_Type is private;
    with function "<" ( Left, Right: Element_Type ) return Boolean;
    with procedure Put( Element: Element_Type );
package Splay_Tree_Package is
    type Tree_Ptr is private;
    type Splay_Tree is new Ada.Finalization.Limited_Controlled with private;

    procedure Initialize( T: in out Splay_Tree );
    procedure Finalize( T: in out Splay_Tree );

    procedure Delete( X: Element_Type; T: in out Splay_Tree );
    procedure Find( X: Element_Type; T: in out Splay_Tree );
    procedure Insert( X: Element_Type; T: in out Splay_Tree );
    procedure Make_Empty( T: in out Splay_Tree );
    procedure Print_Tree( T: Splay_Tree );
    function  Retrieve( T: Splay_Tree ) return Element_Type;

    Item_Not_Found : exception;

private
    type Tree_Node;
    type Tree_Ptr is access Tree_Node;

    type Splay_Tree is new Ada.Finalization.Limited_Controlled with
      record
        Root : Tree_Ptr;
        Null_Node : Tree_Ptr;
      end record;

    type Tree_Node is
      record
        Element : Element_Type;
        Left    : Tree_Ptr;
        Right   : Tree_Ptr;
      end record;

end Splay_Tree_Package;
