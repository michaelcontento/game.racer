Strict

Private

Import bono
Import mojo
Import racer.app
Import racer.road.road
Import racer.road.roadsegment

Public

Class Player Implements Updateable, Keyhandler, Renderable
    Private

    Const SPEED_LIMIT:Float = Road.SEGMENT_LENGTH / (1.0 / 60.0)
    Const SPEED_LIMIT_OFFROAD:Float = SPEED_LIMIT / 4
    Const ACCEL:Float = SPEED_LIMIT / 5
    Const DECEL:Float = ACCEL * -1
    Const DECEL_OFFROAD:Float = (SPEED_LIMIT / 2) * -1
    Const BREAKING:Float = SPEED_LIMIT * -1
    Const CENTRIFUGAL:Float = 0.3
    Field speed:Float
    Field keyFaster:Bool
    Field keySlower:Bool
    Field keyLeft:Bool
    Field keyRight:Bool
    Field carStraight:Sprite
    Field carLeft:Sprite
    Field carRight:Sprite
    Field carUpStraight:Sprite
    Field carUpLeft:Sprite
    Field carUpRight:Sprite

    Public

    Field x:Float
    Field y:Float
    Field pos:Float
    Field currentRoad:Road
    Field uphill:Bool

    Method New()
        Reset()

        carStraight = New Sprite("images/player/straight.png")
        AlignCar(carStraight)

        carLeft = New Sprite("images/player/left.png")
        AlignCar(carLeft)

        carRight = New Sprite("images/player/right.png")
        AlignCar(carRight)

        carUpStraight = New Sprite("images/player/up-straight.png")
        AlignCar(carUpStraight)

        carUpLeft = New Sprite("images/player/up-left.png")
        AlignCar(carUpLeft)

        carUpRight = New Sprite("images/player/up-right.png")
        AlignCar(carUpRight)
    End

    Method AlignCar:Void(car:Sprite)
        car.GetPosition().x = Director.Shared().GetApp().GetVirtualSize().x / 2
        car.GetPosition().y = Director.Shared().GetApp().GetVirtualSize().y

        car.scale.x = 3
        car.scale.y = 3

        Align.Horizontal(car, Align.CENTER)
        Align.Vertical(car, Align.BOTTOM)
    End

    Method OnKeyDown:Void(event:KeyEvent)
        Select event.code
        Case KEY_W
            keyFaster = True
        Case KEY_S
            keySlower = True
        Case KEY_A
            keyLeft = True
        Case KEY_D
            keyRight = True
        End
    End

    Method OnKeyPress:Void(event:KeyEvent)
    End

    Method OnKeyUp:Void(event:KeyEvent)
        Select event.code
        Case KEY_W
            keyFaster = False
        Case KEY_S
            keySlower = False
        Case KEY_A
            keyLeft = False
        Case KEY_D
            keyRight = False
        End
    End

    Method OnUpdate:Void(timer:DeltaTimer)
        If Not currentRoad
            Reset()
            Return
        End

        Local dt:Float = timer.frameTime / 1000

        UpdatePosition(dt)
        HandleSteering(dt)
        HandleThrottle(dt)

        x = Clamp(x, -2.0, 2.0)
        speed = Clamp(speed, 0.0, SPEED_LIMIT)
    End

    Method OnRender:Void()
        If keyLeft And speed > 0
            If uphill
                carUpLeft.OnRender()
            Else
                carLeft.OnRender()
            End
        ElseIf keyRight And speed > 0
            If uphill
                carUpRight.OnRender()
            Else
                carRight.OnRender()
            End
        Else
            If uphill
                carUpStraight.OnRender()
            Else
                carStraight.OnRender()
            End
        End
    End

    Method Reset:Void()
        pos = 0
        speed = 0
    End

    Method GetCurrentCurvePower:Float()
        Local segment:RoadSegment = currentRoad.GetPlayerSegment()
        Return (speed / SPEED_LIMIT) * segment.curve
    End

    Private

    Method UpdatePosition:Void(dt:Float)
        pos += speed * dt
        If pos >= currentRoad.Length() Then pos -= currentRoad.Length()
    End

    Method HandleSteering:Void(dt:Float)
        Local dx:Float = dt * 2 * (speed / SPEED_LIMIT)

        If keyLeft
            x -= dx
        ElseIf keyRight
            x += dx
        End

        x -= (dx * GetCurrentCurvePower() * CENTRIFUGAL)
    End

    Method HandleThrottle:Void(dt:Float)
        If keyFaster
            speed += ACCEL * dt
        ElseIf keySlower
            speed += BREAKING * dt
        Else
            speed += DECEL * dt
        End

        If (x <= -1 Or x >= 1) And speed > SPEED_LIMIT_OFFROAD
            speed += DECEL_OFFROAD * dt
        End
    End
End
