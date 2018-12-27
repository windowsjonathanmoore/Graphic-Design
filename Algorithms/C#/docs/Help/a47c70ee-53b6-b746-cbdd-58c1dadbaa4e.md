# CursorList Class
 

Linked list implementation of the list using a header node; cursor version. Access to the list is via CursorListItr.


## Inheritance Hierarchy
<a href="http://msdn2.microsoft.com/en-us/library/e5kfa45b" target="_blank">System.Object</a><br />&nbsp;&nbsp;algorithms.CursorList<br />
**Namespace:**&nbsp;<a href="82f88b43-fdc9-bc99-9558-75fce96d448f">algorithms</a><br />**Assembly:**&nbsp;Algorithms (in Algorithms.dll) Version: 1.0.0.0 (1.0.0.0)

## Syntax

**C#**<br />
``` C#
public class CursorList
```

**VB**<br />
``` VB
Public Class CursorList
```

**VB Usage**<br />
``` VB Usage
Dim instance As CursorList
```

**C++**<br />
``` C++
public ref class CursorList
```

**F#**<br />
``` F#
type CursorList =  class end
```

**JavaScript**<br />
``` JavaScript
algorithms.CursorList = function();

Type.createClass(
	'algorithms.CursorList');
```

The CursorList type exposes the following members.


## Constructors
&nbsp;<table><tr><th></th><th>Name</th><th>Description</th></tr><tr><td>![Public method](media/pubmethod.gif "Public method")</td><td><a href="87b82f74-3b36-877e-5a50-c2dcec844505">CursorList</a></td><td>
Construct the list.</td></tr></table>&nbsp;
<a href="#cursorlist-class">Back to Top</a>

## Properties
&nbsp;<table><tr><th></th><th>Name</th><th>Description</th></tr><tr><td>![Public property](media/pubproperty.gif "Public property")</td><td><a href="75d4cbb1-bc6b-b592-0961-f4a1d66fdfe5">Empty</a></td><td>
Test if the list is logically empty.</td></tr></table>&nbsp;
<a href="#cursorlist-class">Back to Top</a>

## Methods
&nbsp;<table><tr><th></th><th>Name</th><th>Description</th></tr><tr><td>![Public method](media/pubmethod.gif "Public method")</td><td><a href="http://msdn2.microsoft.com/en-us/library/bsc2ak47" target="_blank">Equals</a></td><td>
Determines whether the specified object is equal to the current object.
 (Inherited from <a href="http://msdn2.microsoft.com/en-us/library/e5kfa45b" target="_blank">Object</a>.)</td></tr><tr><td>![Protected method](media/protmethod.gif "Protected method")</td><td><a href="http://msdn2.microsoft.com/en-us/library/4k87zsw7" target="_blank">Finalize</a></td><td>
Allows an object to try to free resources and perform other cleanup operations before it is reclaimed by garbage collection.
 (Inherited from <a href="http://msdn2.microsoft.com/en-us/library/e5kfa45b" target="_blank">Object</a>.)</td></tr><tr><td>![Public method](media/pubmethod.gif "Public method")</td><td><a href="208918ca-a78a-1aad-27d5-9d68675ce262">find</a></td><td>
Return iterator corresponding to the first node containing an item.</td></tr><tr><td>![Public method](media/pubmethod.gif "Public method")</td><td><a href="aa237f20-6366-97fe-b57e-764852f4fa7a">findPrevious</a></td><td>
Return iterator prior to the first node containing an item.</td></tr><tr><td>![Public method](media/pubmethod.gif "Public method")</td><td><a href="ada04ba4-67bb-1526-5a34-cefb1db0055e">first</a></td><td>
Return an iterator representing the first node in the list. This operation is valid for empty lists.</td></tr><tr><td>![Public method](media/pubmethod.gif "Public method")</td><td><a href="http://msdn2.microsoft.com/en-us/library/zdee4b3y" target="_blank">GetHashCode</a></td><td>
Serves as the default hash function.
 (Inherited from <a href="http://msdn2.microsoft.com/en-us/library/e5kfa45b" target="_blank">Object</a>.)</td></tr><tr><td>![Public method](media/pubmethod.gif "Public method")</td><td><a href="http://msdn2.microsoft.com/en-us/library/dfwy45w9" target="_blank">GetType</a></td><td>
Gets the <a href="http://msdn2.microsoft.com/en-us/library/42892f65" target="_blank">Type</a> of the current instance.
 (Inherited from <a href="http://msdn2.microsoft.com/en-us/library/e5kfa45b" target="_blank">Object</a>.)</td></tr><tr><td>![Public method](media/pubmethod.gif "Public method")</td><td><a href="5545019c-cbeb-2234-9a76-20cc434e94c6">insert</a></td><td>
Insert after p.</td></tr><tr><td>![Public method](media/pubmethod.gif "Public method")![Static member](media/static.gif "Static member")</td><td><a href="371fb167-ecbe-3ced-6997-cd78f67c5281">Main</a></td><td /></tr><tr><td>![Public method](media/pubmethod.gif "Public method")</td><td><a href="1953222d-067a-8d60-bab2-96f98399cfd8">makeEmpty</a></td><td>
Make the list logically empty.</td></tr><tr><td>![Protected method](media/protmethod.gif "Protected method")</td><td><a href="http://msdn2.microsoft.com/en-us/library/57ctke0a" target="_blank">MemberwiseClone</a></td><td>
Creates a shallow copy of the current <a href="http://msdn2.microsoft.com/en-us/library/e5kfa45b" target="_blank">Object</a>.
 (Inherited from <a href="http://msdn2.microsoft.com/en-us/library/e5kfa45b" target="_blank">Object</a>.)</td></tr><tr><td>![Public method](media/pubmethod.gif "Public method")![Static member](media/static.gif "Static member")</td><td><a href="03a72c88-fd37-248a-e5b3-74151626a340">printList</a></td><td /></tr><tr><td>![Public method](media/pubmethod.gif "Public method")</td><td><a href="a42c8485-95fe-71d1-ef7d-6bfe49a5d5d1">remove</a></td><td>
Remove the first occurrence of an item.</td></tr><tr><td>![Public method](media/pubmethod.gif "Public method")</td><td><a href="http://msdn2.microsoft.com/en-us/library/7bxwbwt2" target="_blank">ToString</a></td><td>
Returns a string that represents the current object.
 (Inherited from <a href="http://msdn2.microsoft.com/en-us/library/e5kfa45b" target="_blank">Object</a>.)</td></tr><tr><td>![Public method](media/pubmethod.gif "Public method")</td><td><a href="56f4fde1-b269-8595-7d14-621a1c741f6c">zeroth</a></td><td>
Return an iterator representing the header node.</td></tr></table>&nbsp;
<a href="#cursorlist-class">Back to Top</a>

## See Also


#### Reference
<a href="82f88b43-fdc9-bc99-9558-75fce96d448f">algorithms Namespace</a><br /><a href="d528b1d7-822b-ed08-2f56-cb5cdae8dffa">algorithms.CursorListItr</a><br />