-- Generic Package Specification for Search_Tree_Package
--
-- Requires:
--     Instantiated with any private type and
--     a "<" function for that type and
--     a Put procedure for that type
-- Types defined:
--     Tree_Ptr            private type
--     Search_Tree         limited private type
-- Exceptions defined:
--     Item_Not_Found      raised when searches or deletions fail
-- Operations defined:
--     (* throws Item_Not_Found)
--     Initialize and Finalize are defined for Search_Tree
--     Delete *            removes item from search tree
--     Find  *             returns Tree_Ptr of item in search tree
--     Find_Max *          returns Tree_Ptr of maximum item in search tree
--     Find_Min *          returns Tree_Ptr of minimum item in search tree
--     Insert              insert item into search tree
--     Make_Empty          make a search tree empty
--     Print_Tree          print tree in sorted order
--     Retrieve *          returns item in Tree_Ptr passed as parameter

with Ada.Finalization;
with Text_IO; use Text_IO;

generic
    type Element_Type is private;
    with function "<" ( Left, Right: Element_Type ) return Boolean;
    with procedure Put( Element: Element_Type );
package Search_Tree_Package is
    type Tree_Ptr is private;
    type Search_Tree is new Ada.Finalization.Limited_Controlled with private;

    procedure Initialize( T: in out Search_Tree );
    procedure Finalize( T: in out Search_Tree );

    procedure Delete( X: Element_Type; T: in out Search_Tree );
    function  Find( X: Element_Type; T: Search_Tree ) return Tree_Ptr;
    function  Find_Min( T: Search_Tree ) return Tree_Ptr;
    function  Find_Max( T: Search_Tree ) return Tree_Ptr;
    procedure Insert( X: Element_Type; T: in out Search_Tree );
    procedure Make_Empty( T: in out Search_Tree );
    procedure Print_Tree( T: Search_Tree );
    function  Retrieve( P: Tree_Ptr ) return Element_Type;

    Item_Not_Found : exception;

private
    type Tree_Node;
    type Tree_Ptr is access Tree_Node;

    type Search_Tree is new Ada.Finalization.Limited_Controlled with
      record
        Root : Tree_Ptr;
      end record;

    type Tree_Node is
      record
        Element : Element_Type;
        Left    : Tree_Ptr;
        Right   : Tree_Ptr;
      end record;

    -- This function is provided for illustrative purposes
    function Height( T: Search_Tree ) return Integer;
end Search_Tree_Package;
