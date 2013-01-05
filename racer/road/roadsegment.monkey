Strict

Private

Import bono
Import mojo
Import racer.colorstore
Import racer.road.road
Import racer.road.roadsegmentposition

Public

Class RoadSegment
    Field index:Int
    Field p1:RoadSegmentPosition = New RoadSegmentPosition()
    Field p2:RoadSegmentPosition = New RoadSegmentPosition()
    Field color:ColorStore
    Field looped:Bool
    Field fog:Float

    Method Render:Void()
        RenderGrass()
        RenderRumbles()
        RenderRoad()
        If color.lane Then RenderLanes()
        RenderFog()
    End

    Private

    Method RenderFog:Void()
        If fog >= 1 Then Return

        color.fog.alphaFloat = 1.0 - fog
        color.fog.Activate()
        DrawRect(0, p1.screen.y, Device.GetSize().x, p2.screen.y - p1.screen.y)
        color.fog.Deactivate()
    End

    Method RenderGrass:Void()
        color.grass.Activate()
        DrawRect(0, p2.screen.y, Device.GetSize().x, p1.screen.y - p2.screen.y)
        color.grass.Deactivate()
    End

    Method RenderRumbles:Void()
        Local rumbleW1:Float = GetRumbleWidth(p1.screen.z)
        Local rumbleW2:Float = GetRumbleWidth(p2.screen.z)

        RenderPolygon(
            p1.screen.x - p1.screen.z - rumbleW1,
            p1.screen.y,
            p1.screen.x - p1.screen.z,
            p1.screen.y,
            p2.screen.x - p2.screen.z,
            p2.screen.y,
            p2.screen.x - p2.screen.z - rumbleW2,
            p2.screen.y,
            color.rumble)
        RenderPolygon(
            p1.screen.x + p1.screen.z + rumbleW1,
            p1.screen.y,
            p1.screen.x + p1.screen.z,
            p1.screen.y,
            p2.screen.x + p2.screen.z,
            p2.screen.y,
            p2.screen.x + p2.screen.z + rumbleW2,
            p2.screen.y,
            color.rumble)
    End

    Method RenderRoad:Void()
        RenderPolygon(
            p1.screen.x - p1.screen.z,
            p1.screen.y,
            p1.screen.x + p1.screen.z,
            p1.screen.y,
            p2.screen.x + p2.screen.z,
            p2.screen.y,
            p2.screen.x - p2.screen.z,
            p2.screen.y,
            color.road)
    End

    Method RenderLanes:Void()
        Local laneZ1:Float = p1.screen.z * 2 / Road.LANES
        Local laneZ2:Float = p2.screen.z * 2 / Road.LANES
        Local laneX1:Float = p1.screen.x - p1.screen.z + laneZ1
        Local laneX2:Float = p2.screen.x - p2.screen.z + laneZ2
        Local laneW1:Float = GetLaneMarkerWidth(p1.screen.z)
        Local laneW2:Float = GetLaneMarkerWidth(p2.screen.z)

        For Local lane:Int = 1 Until Road.LANES
            RenderPolygon(
                laneX1 - laneW1 / 2,
                p1.screen.y,
                laneX1 + laneW1 / 2,
                p1.screen.y,
                laneX2 + laneW2 / 2,
                p2.screen.y,
                laneX2 - laneW2 / 2,
                p2.screen.y,
                color.lane)
            laneX1 += laneZ1
            laneX2 += laneZ2
        End
    End

    Method RenderPolygon:Void(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, x4:Float, y4:Float, color:Color)
        color.Activate()
        DrawPoly([x1, y1, x2, y2, x3, y3, x4, y4])
        color.Deactivate()
    End

    Method GetRumbleWidth:Float(projectedRoadWidth:Float)
        Return projectedRoadWidth / Max(6, 2 * Road.LANES)
    End

    Method GetLaneMarkerWidth:Float(projectedRoadWidth:Float)
        Return projectedRoadWidth / Max(32, 8 * Road.LANES)
    End
End
