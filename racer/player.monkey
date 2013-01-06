Strict

Private

Import bono
Import mojo
Import racer.app
Import racer.road.road

Public

Class Player Implements Updateable, Keyhandler
    Private

    Const SPEED_LIMIT:Float = Road.SEGMENT_LENGTH / (1.0 / 60.0)
    Const SPEED_LIMIT_OFFROAD:Float = SPEED_LIMIT / 4
    Const ACCEL:Float = SPEED_LIMIT / 5
    Const DECEL:Float = ACCEL * -1
    Const DECEL_OFFROAD:Float = (SPEED_LIMIT / 2) * -1
    Const BREAKING:Float = SPEED_LIMIT * -1
    Field speed:Float
    Field keyFaster:Bool
    Field keySlower:Bool
    Field keyLeft:Bool
    Field keyRight:Bool

    Public

    Field x:Float
    Field pos:Float
    Field currentRoad:Road

    Method New()
        Reset()
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

    Method Reset:Void()
        pos = 0
        speed = 0
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
