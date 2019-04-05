-- Imports:
-- Importing the Browser module to have a way to get things onto the screen
-- Html is for html elements and attributes
-- Events is for, html events
import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


-- Our main function, how the app is launched
main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL

-- Here we're saying a "Model" is another name for an Int in this app
type alias Model = Int

-- The init function takes a "Model", which is really an Int, so this is like setting up our initial state
init : Model
init =
  0


-- UPDATE

-- Some ADTs to manage state
type Msg = Increment | Decrement

-- This function takes in an ADT and the current state and returns the updated state
update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1



-- VIEW

-- How we render HTML, our "component"
view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
