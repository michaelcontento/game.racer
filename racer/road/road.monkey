Strict

Private

Import bono
Import racer.colorstore
Import racer.road.roadsegment

Public

Class Road Implements Renderable, Updateable
    Private

    Const SEGMENT_LENGTH:Int = 200
    Const DRAW_DISTANCE:Int = 300
    Const FIELD_OF_VIEW:Float = 100
    Const RUMBLE_LENGTH:Float = 3
    Field cameraDepth:Float
    Field cameraHeight:Float = 1000
    Field segments:List<RoadSegment> = New List<RoadSegment>
    Field position:Float
    Field playerX:Float = 0

    Public

    Const WIDTH:Float = 2000
    Const LANES:Int = 3

    Method New()
        cameraDepth = ATanr((FIELD_OF_VIEW / 2) * PI / 180)
        Reset()
    End

    Method Reset:Void()
        segments.Clear()
        For Local n:Int = 0 To 500
            Local segment:RoadSegment = New RoadSegment()
            segment.index = n
            segment.p1.world.z = (n + 0) * SEGMENT_LENGTH
            segment.p2.world.z = (n + 1) * SEGMENT_LENGTH

            segment.color = ColorStore.GetLight()
            If (Floor(n / RUMBLE_LENGTH) Mod 2) = 0
                segment.color = ColorStore.GetDark()
            End

            segments.AddLast(segment)
        End
    End

    Method OnUpdate:Void(timer:DeltaTimer)
        position += 30 * timer.delta
    End

    Method OnRender:Void()
        Local baseSegment:RoadSegment = GetSegmentFromPosition(position)
        Local maxY:Float = Device.GetSize().y

        For Local n:Int = 0 To DRAW_DISTANCE
            Local segment:RoadSegment = GetSegment(baseSegment.index + n)
            segment.looped = segment.index < baseSegment.index

            Local projectPosition:Float = position
            If segment.looped Then projectPosition -= Length()

            segment.p1.Project(playerX, cameraHeight, projectPosition, cameraDepth)
            segment.p2.Project(playerX, cameraHeight, projectPosition, cameraDepth)

            If segment.p1.camera.z <= cameraDepth Then Continue
            If segment.p2.screen.y >= maxY Then Continue

            segment.Render()

            maxY = segment.p2.screen.y
        End
    End

    Method Length:Float() Property
        Return segments.Count() * SEGMENT_LENGTH
    End

    Private

    Method GetSegmentFromPosition:RoadSegment(position:Float)
        Return GetSegment(Floor(position / SEGMENT_LENGTH))
    End

    Method GetSegment:RoadSegment(idx:Int)
        Return segments.ToArray()[idx Mod Length()]
    End
End
