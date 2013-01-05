Strict

Private

Import bono

Public

Class ColorStore
    Private

    Global lightInstance:ColorStore
    Global darkInstance:ColorStore

    Public

    Field rumble:Color
    Field road:Color
    Field grass:Color
    Field lane:Color

    Function GetLight:ColorStore()
        If Not lightInstance
            lightInstance = New ColorStore()
            lightInstance.rumble = New Color("#555555")
            lightInstance.road = New Color("#6B6B6B")
            lightInstance.grass = New Color("#10AA10")
            lightInstance.lane = New Color("#CCCCCC")
        End

        Return lightInstance
    End

    Function GetDark:ColorStore()
        If Not darkInstance
            darkInstance = New ColorStore()
            darkInstance.rumble = New Color("#BBBBBB")
            darkInstance.road = New Color("#696969")
            darkInstance.grass = New Color("#009A00")
        End

        Return darkInstance
    End
End
