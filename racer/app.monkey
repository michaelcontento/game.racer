Strict

Private

Import bono
Import racer.scenes.racescene

Public

Class App Extends bono.App
    Method Run:Void()
        GetDirector().AddScene("race", New RaceScene())
        GetDirector().GotoScene("race")
    End
End
