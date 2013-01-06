Strict

Private

Import bono
Import racer.colorstore
Import racer.player
Import racer.road.roadsegment

Public

Class Road Implements Renderable
    Private

    Const DRAW_DISTANCE:Int = 300
    Const FIELD_OF_VIEW:Float = 100
    Const RUMBLE_LENGTH:Float = 3
    Const FOG_DENSITY:Float = 5
    Field cameraDepth:Float
    Field cameraHeight:Float = 1000
    Field segments:List<RoadSegment> = New List<RoadSegment>
    Field player:Player

    Public

    Const SEGMENT_LENGTH:Int = 200
    Const WIDTH:Float = 2000
    Const LANES:Int = 3

    Method New(player:Player)
        Self.player = player
        player.currentRoad = Self
        cameraDepth = ATanr((FIELD_OF_VIEW / 2) * PI / 180)
        Reset()
    End

    Method Reset:Void()
        segments.Clear()

        AddStraight(4)
        AddCurveS(50, 4)
        AddStraight(100)
        AddCurve(50, 4)
        AddCurve(100, 4)
        AddStraight(50)
        AddCurve(100, -6)
        AddCurve(100, 6)
        AddStraight(50)
        AddCurveS(50, 4)
        AddCurveS(100, -2)

        For Local s:RoadSegment = EachIn segments
        End
    End

    Method AddStraight:Void(len:Int)
        AddRoad(len, len, len, 0)
    End

    Method AddCurve:Void(len:Int, curve:Int)
        AddRoad(len, len, len, curve)
    End

    Method AddCurveS:Void(len:Int, curve:Int)
        AddCurve(len, curve * -1)
        AddCurve(len, curve + 2)
        AddCurve(len, curve)
        AddCurve(len, curve * -1)
        AddCurve(len, (curve + 2) * -1)
    End

    Method AddRoad:Void(enter:Float, hold:Float, leave:Float, curve:Float)
        For Local i:Float = 0 To enter
            AddSegment(EasyIn(0, curve, i / enter))
        End
        For Local i:Float = 0 To hold
            AddSegment(curve)
        End
        For Local i:Float = 0 To leave
            AddSegment(EasyOut(curve, 0, i / leave))
        End
    End

    Method AddSegment:Void(curve:Float=0.0)
        Local n:Int = segments.Count()

        Local segment:RoadSegment = New RoadSegment()
        segment.index = n
        segment.curve = curve
        segment.p1.world.z = (n + 0) * SEGMENT_LENGTH
        segment.p2.world.z = (n + 1) * SEGMENT_LENGTH

        segment.color = ColorStore.GetLight()
        If (Floor(n / RUMBLE_LENGTH) Mod 2) = 0
            segment.color = ColorStore.GetDark()
        End

        segments.AddLast(segment)
    End

    Method OnRender:Void()
        Local baseSegment:RoadSegment = GetSegmentFromPosition(player.pos)
        Local basePercent:Float = PercentRemaning(player.pos, SEGMENT_LENGTH)
        Local maxY:Float = Device.GetSize().y

        Local x:Float = 0
        Local dx:Float = (baseSegment.curve * basePercent) * -1

        For Local n:Int = 0 To DRAW_DISTANCE
            Local segment:RoadSegment = GetSegment(baseSegment.index + n)
            segment.looped = segment.index < baseSegment.index
            segment.fog = CalculateFog(Float(n) / DRAW_DISTANCE, FOG_DENSITY)

            Local projectPosition:Float = player.pos
            If segment.looped Then projectPosition -= Length()

            segment.p1.Project((player.x * WIDTH) - x, cameraHeight, projectPosition, cameraDepth)
            segment.p2.Project((player.x * WIDTH) - x - dx, cameraHeight, projectPosition, cameraDepth)

            x += dx
            dx += segment.curve

            If segment.p1.camera.z <= cameraDepth Then Continue
            If segment.p2.screen.y >= maxY Then Continue

            segment.Render()

            maxY = segment.p2.screen.y
        End
    End

    Method Length:Float() Property
        Return segments.Count() * SEGMENT_LENGTH
    End

    Method GetPlayerSegment:RoadSegment()
        Return GetSegmentFromPosition(player.pos + (cameraHeight * cameraDepth))
    End

    Private

    Method EasyIn:Float(a:Float, b:Float, percent:Float)
        Return a + (b - a) * Pow(percent, 2)
    End

    Method EasyOut:Float(a:Float, b:Float, percent:Float)
        Return a + (b - a) * (1.0 - Pow(1.0 - percent, 2))
    End

    Method PercentRemaning:Float(pos:Float, total:Float)
        Return (pos Mod total) / total
    End

    Method CalculateFog:Float(distance:Float, density:Float)
        Return 1.0 / Pow(MathHelper.E, (distance * distance * density))
    End

    Method GetSegmentFromPosition:RoadSegment(position:Float)
        Return GetSegment(Floor(position / SEGMENT_LENGTH))
    End

    Field segmentsArray:RoadSegment[]
    Method GetSegment:RoadSegment(idx:Int)
        If segmentsArray.Length() = 0
            segmentsArray = segments.ToArray()
        End

        Return segmentsArray[idx Mod segments.Count()]
    End
End
