import Browser
import Html exposing (Html, text, pre)
import Http -- << The new module!


-- MAIN

main =
  Browser.element
  { init = init
  , update = update
  , subscriptions = subscriptions -- << This piece is new too! But the func is doing nothing atm.
  , view = view
  }


-- MODEL

-- We're using ADTs to model the state
type Model
  = Failure
  | Loading
  | Success String


-- This sets up the initial state to "Loading" while also issuing a HTTP request
init : () -> (Model, Cmd Msg) -- << This too is really new. Why a func now? << The func is for JS interop
init _ = -- << Why a func as an arg when the arg doesn't matter? << I guess it's mandatory to check for JS interop first?
  ( Loading
  , Http.get
    { url = "https://elm-lang.org/assets/public-opinion.txt"
    , expect = Http.expectString GotText -- << What is this expectString?
    }
  )


-- UPDATE

-- Only one type of message this time around
type Msg
  = GotText (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg) -- << The last arg is now a tuple!
update msg model =
  case msg of
    GotText result ->
      case result of
        Ok fullText -> -- << Ok must be a type from the HTTP module << Nope, Ok is a type created by the Result type
          (Success fullText, Cmd.none) -- << This must be saying "set the state to 'Succ text' and then do nothing"

        Err _ ->
          (Failure, Cmd.none)


-- Subscriptions

-- I guess this is doing nothing.
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- View

-- Conditional renderings based on the model! Brilliant!
view : Model -> Html Msg
view model =
  case model of
    Failure ->
      text "I was unable to load your book."

    Loading ->
      text "Loading..."

    Success fullText ->
      pre [] [ text fullText ]
