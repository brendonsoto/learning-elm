-- Import Browser and Html bits for creating markup
import Browser
import Html exposing (Html, Attribute, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN

-- How we actually run/instantiate the app
main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL

-- Our model here is a record with only one field, content.
-- It's a record instead of just a string to demonstrate the ease of adding other stuff
type alias Model =
  { content : String
  }


-- Our initial state, an empty string
init : Model
init =
  { content = "" }


-- UPDATE

-- Only one message, to change the state
type Msg =
  Change String


-- On every new bit of content, update the bit
-- NOTE Question: How to debounce?
update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newContent ->
      { model | content = newContent }


-- VIEW


-- The markup
view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "Text to reverse", value model.content, onInput Change ] []
    , div [] [ text (String.reverse model.content) ]
    ]
