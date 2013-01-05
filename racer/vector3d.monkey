Strict

Private

Import bono

Public

Class Vector3D Extends Vector2D
    Field z:Float

    Method New(x:Float=0, y:Float=0, z:Float=0)
        Super.New(x, y)
        Self.z = z
    End

    Method ToString:String()
        Return Super.ToString().Replace(")", ", " + z + ")")
    End
End
