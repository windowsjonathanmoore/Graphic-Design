-- Generic Package Specification for Red_Black_Tree_Package
--
-- Requires:
--     Instantiated with any private type and
--     a "<" function for that type and
--     a Put procedure for that type
--     a meaningful value of negative infinity
-- Types defined:
--     Tree_Ptr            private type
--     Red_Black_Tree      limited private type
-- Exceptions defined:
--     Item_Not_Found      raised when searches or deletions fail
-- Operations defined:
--     (* throws Item_Not_Found)
--     Initialize and Finalize are defined for Red_Black_Tree
--     Find  *             returns Tree_Ptr of item in red black tree
--     Find_Max *          returns Tree_Ptr of maximum item in red black tree
--     Find_Min *          returns Tree_Ptr of minimum item in red black tree
--     Insert              insert item into red black tree
--     Make_Empty          make red black tree empty
--     Print_Tree          print red black tree in sorted order
--     Retrieve *          returns item in Tree_Ptr passed as parameter

with Ada.Finalization;
with Text_IO; use Text_IO;

generic
    type Element_Type is private;
    with function "<" ( Left, Right: Element_Type ) return Boolean;
    with procedure Put( Element: Element_Type );
    Negative_Infinity : in Element_Type;
package Red_Black_Tree_Package is
    type Tree_Ptr is private;
    type Red_Black_Tree is new Ada.Finalization.Limited_Controlled with private;

    procedure Initialize( T: in out Red_Black_Tree );
    procedure Finalize( T: in out Red_Black_Tree );

    function  Find( X: Element_Type; T: Red_Black_Tree ) return Tree_Ptr;
    function  Find_Min( T: Red_Black_Tree ) return Tree_Ptr;
    function  Find_Max( T: Red_Black_Tree ) return Tree_Ptr;
    procedure Insert( X: Element_Type; T: in out Red_Black_Tree );
    procedure Make_Empty( T: in out Red_Black_Tree );
    procedure Print_Tree( T: Red_Black_Tree );
    function  Retrieve( P: Tree_Ptr ) return Element_Type;

    Item_Not_Found : exception;

private
    type Color_Type is ( Red, Black );

    type Tree_Node;
    type Tree_Ptr is access Tree_Node;

    type Red_Black_Tree is new Ada.Finalization.Limited_Controlled with
      record
        Header : Tree_Ptr;
        Null_Node : Tree_Ptr;
      end record;

    type Tree_Node is
      record
        Element : Element_Type;
        Left    : Tree_Ptr;
        Right   : Tree_Ptr;
        Color   : Color_Type := Black;
      end record;

end Red_Black_Tree_Package;
