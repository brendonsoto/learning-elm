import Browser
import Html exposing (..)
-- These two modules are new
import Task
import Time


-- MAIN

main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

-- Since we're making a digital clock, the model will probably be either:
-- - A string displaying the time
-- - An int in ms or something
-- - A custom type just for time << probably this one

type alias Model =
  { zone : Time.Zone
  , time : Time.Posix
  }


init : () -> (Model, Cmd Msg)
init _ =
  ( Model Time.utc (Time.millisToPosix 0) -- Idk what utc means, but I guess it's just setting the time to 0, equivalent to 00:00 military time
  , Task.perform AdjustTimeZone Time.here -- This must be setting the timezone to shift the above time?
  )


-- UPDATE

type Msg
  = Tick Time.Posix
  | AdjustTimeZone Time.Zone


-- Nothing new here
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ( { model | time = newTime }
      , Cmd.none
      )

    AdjustTimeZone newZone ->
      ( { model | zone = newZone }
      , Cmd.none
      )


-- SUBSCRIPTIONS

-- This is new!
-- `Time.every` must be setting up a recurring action...
-- The return Type is `Sub Msg`
-- We see the `Msg` part in `Tick`
-- so `Time.every 1000` must be setting up the `Sub` part
subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 1000 Tick


-- VIEW

-- The main new thing is the `let` command, but that's very similar to `let` in Haskell!
-- The time parsing is straight forward
view : Model -> Html Msg
view model =
  let
      hour   = String.fromInt (Time.toHour   model.zone model.time)
      minute = String.fromInt (Time.toMinute model.zone model.time)
      second = String.fromInt (Time.toSecond model.zone model.time)
  in
      h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
