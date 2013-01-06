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
    Const LENGTH_NONE:Int = 0
    Const LENGTH_SHORT:Int = 25
    Const LENGTH_MEDIUM:Int = 50
    Const LENGTH_LONG:Int = 100
    Const HILL_NONE:Int = 0
    Const HILL_LOW:Int = 20
    Const HILL_MEDIUM:Int = 40
    Const HILL_HIGH:Int = 60
    Const CURVE_NONE:Int = 0
    Const CURVE_EASY:Int = 2
    Const CURVE_MEDIUM:Int = 4
    Const CURVE_HARD:Int = 6
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

        AddStraight(LENGTH_SHORT / 2)
        AddHill(LENGTH_SHORT, HILL_LOW)
        AddLowRollingHills(LENGTH_SHORT, HILL_LOW)
        AddCurve(LENGTH_MEDIUM, CURVE_MEDIUM, HILL_LOW)
        AddLowRollingHills(LENGTH_SHORT, HILL_LOW)
        AddCurve(LENGTH_LONG, CURVE_MEDIUM, HILL_MEDIUM)
        AddStraight(LENGTH_MEDIUM)
        AddCurve(LENGTH_LONG, -CURVE_MEDIUM, HILL_MEDIUM)
        AddHill(LENGTH_LONG, HILL_HIGH)
        AddCurve(LENGTH_LONG, CURVE_MEDIUM, -HILL_LOW)
        AddHill(LENGTH_LONG, -HILL_MEDIUM)
        AddStraight(LENGTH_MEDIUM)
        AddDownhillToEnd(LENGTH_LONG * 2)
    End

    Method AddLowRollingHills:Void(len:Int, height:Int)
        AddRoad(len, len, len, 0, height / 2)
        AddRoad(len, len, len, 0, height * -1)
        AddRoad(len, len, len, 0, height)
        AddRoad(len, len, len, 0, 0)
        AddRoad(len, len, len, 0, height / 2)
        AddRoad(len, len, len, 0, 0)
    End

    Method AddDownhillToEnd:Void(len:Int)
        AddRoad(len, len, len, -CURVE_EASY, -GetLastY() / SEGMENT_LENGTH)
    End

    Method AddStraight:Void(len:Int)
        AddRoad(len, len, len, 0, 0)
    End

    Method AddHill:Void(len:Int, height:Int)
        AddRoad(len, len, len, 0, height)
    End

    Method AddCurve:Void(len:Int, curve:Int, height:Int = 0)
        AddRoad(len, len, len, curve, height)
    End

    Method AddCurveS:Void(len:Int, curve:Int)
        AddCurve(len, curve * -1)
        AddCurve(len, curve + 2)
        AddCurve(len, curve)
        AddCurve(len, curve * -1)
        AddCurve(len, (curve + 2) * -1)
    End

    Method AddRoad:Void(enter:Float, hold:Float, leave:Float, curve:Float, y:Float)
        Local startY:Float = GetLastY()
        Local endY:Float = startY + (y * SEGMENT_LENGTH)
        Local total:Float = enter + hold + leave

        For Local i:Float = 0 To enter
            AddSegment(
                EasyIn(0, curve, i / enter),
                EasyInOut(startY, endY, i / total))
        End
        For Local i:Float = 0 To hold
            AddSegment(
                curve,
                EasyInOut(startY, endY, (i + enter) / total))
        End
        For Local i:Float = 0 To leave
            AddSegment(
                EasyOut(curve, 0, i / leave),
                EasyInOut(startY, endY, (i + enter + hold) / total))
        End
    End

    Method AddSegment:Void(curve:Float = 0.0, y:Float = 0.0)
        Local n:Int = segments.Count()

        Local segment:RoadSegment = New RoadSegment()
        segment.index = n
        segment.curve = curve
        segment.p1.world.y = GetLastY()
        segment.p1.world.z = (n + 0) * SEGMENT_LENGTH
        segment.p2.world.y = y
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
        Local playerPercent:Float = PercentRemaning(player.pos + (cameraHeight * cameraDepth), SEGMENT_LENGTH)
        player.y = Interpolate(
            GetPlayerSegment().p1.world.y,
            GetPlayerSegment().p2.world.y,
            playerPercent)

        Local x:Float = 0
        Local dx:Float = (baseSegment.curve * basePercent) * -1

        For Local n:Int = 0 To DRAW_DISTANCE
            Local segment:RoadSegment = GetSegment(baseSegment.index + n)
            segment.looped = segment.index < baseSegment.index
            segment.fog = CalculateFog(Float(n) / DRAW_DISTANCE, FOG_DENSITY)

            Local projectPosition:Float = player.pos
            If segment.looped Then projectPosition -= Length()

            segment.p1.Project((player.x * WIDTH) - x, player.y + cameraHeight, projectPosition, cameraDepth)
            segment.p2.Project((player.x * WIDTH) - x - dx, player.y + cameraHeight, projectPosition, cameraDepth)

            x += dx
            dx += segment.curve

            If segment.p1.camera.z <= cameraDepth Then Continue
            If segment.p2.screen.y >= segment.p1.screen.y Then Continue
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

    Method GetLastY:Float()
        If segments.Count() = 0 Then Return 0
        Return segments.Last().p2.world.y
    End

    Method EasyIn:Float(a:Float, b:Float, percent:Float)
        Return a + (b - a) * Pow(percent, 2)
    End

    Method EasyOut:Float(a:Float, b:Float, percent:Float)
        Return a + (b - a) * (1.0 - Pow(1.0 - percent, 2))
    End

    Method EasyInOut:Float(a:Float, b:Float, percent:Float)
        Return a + (b - a) * ((-Cosr(percent * MathHelper.PI) / 2) + 0.5)
    End

    Method PercentRemaning:Float(pos:Float, total:Float)
        Return (pos Mod total) / total
    End

    Method CalculateFog:Float(distance:Float, density:Float)
        Return 1.0 / Pow(MathHelper.E, (distance * distance * density))
    End

    Method Interpolate:Float(a:Float, b:Float, percent:Float)
        Return a + (b - a) * percent
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
