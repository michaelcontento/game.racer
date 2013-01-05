Strict

Private

Import bono
Import racer.road.road
Import racer.vector3d

Public

Class RoadSegmentPosition
    Field world:Vector3D = New Vector3D()
    Field camera:Vector3D = New Vector3D()
    Field screen:Vector3D = New Vector3D()
    Field screenScale:Float

    Method Project:Void(playerX:Float, cameraHeight:Float, position:Float, cameraDepth:Float)
        camera.x = world.x - (playerX * Road.WIDTH)
        camera.y = world.y - cameraHeight
        camera.z = world.z - position

        screenScale = cameraDepth / camera.z

        Local device:Vector2D = Device.GetSize()
        screen.x = MathHelper.Round((device.x / 2) + (screenScale * camera.x   * device.x / 2))
        screen.y = MathHelper.Round((device.y / 2) - (screenScale * camera.y   * device.y / 2))
        screen.z = MathHelper.Round(                 (screenScale * Road.WIDTH * device.x / 2))
    End

    Method ToString:String()
        Return "Camera: " + camera + " Screen: " + screen + " World: " + world + " Scale: " + screenScale
    End
End
