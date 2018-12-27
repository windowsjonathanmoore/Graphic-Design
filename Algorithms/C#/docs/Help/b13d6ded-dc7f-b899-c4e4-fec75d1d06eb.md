# AATree.find Method 
 

Find an item in the tree.

**Namespace:**&nbsp;<a href="82f88b43-fdc9-bc99-9558-75fce96d448f">algorithms</a><br />**Assembly:**&nbsp;Algorithms (in Algorithms.dll) Version: 1.0.0.0 (1.0.0.0)

## Syntax

**C#**<br />
``` C#
public virtual Comparable find(
	Comparable x
)
```

**VB**<br />
``` VB
Public Overridable Function find ( 
	x As Comparable
) As Comparable
```

**VB Usage**<br />
``` VB Usage
Dim instance As AATree
Dim x As Comparable
Dim returnValue As Comparable

returnValue = instance.find(x)
```

**C++**<br />
``` C++
public:
virtual Comparable^ find(
	Comparable^ x
)
```

**F#**<br />
``` F#
abstract find : 
        x : Comparable -> Comparable 
override find : 
        x : Comparable -> Comparable 
```

**JavaScript**<br />
``` JavaScript
function find(x);
```


#### Parameters
&nbsp;<dl><dt>x</dt><dd>Type: <a href="6dcffa06-805a-b637-3ea2-da53324cd88f">algorithms.Comparable</a><br />the item to search for.</dd></dl>

#### Return Value
Type: <a href="6dcffa06-805a-b637-3ea2-da53324cd88f">Comparable</a><br />the matching item of null if not found.

## See Also


#### Reference
<a href="d2b1ddce-1121-f4a3-2427-7103aa27229a">AATree Class</a><br /><a href="82f88b43-fdc9-bc99-9558-75fce96d448f">algorithms Namespace</a><br />