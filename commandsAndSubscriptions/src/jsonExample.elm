import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)


-- MAIN

-- Main is the same as last time
main =
  Browser.element
  { init = init
  , update = update
  , subscriptions = subscriptions
  , view = view
  }


-- MODEL

-- Model is the same as last time
type Model
  = Loading
  | Failure
  | Success String


init : () -> (Model, Cmd Msg)
init _ =
  (Loading, getRandomCatGif)


-- UPDATE

type Msg
  = MorePlease
  | GotGif (Result Http.Error String)


-- So our update is saying:
--   If the msg is to get more, get more
--   If the msg is the result of the url, issue either success or failure
-- Alright. So it's not anything really new.
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (Loading, getRandomCatGif)

    GotGif result ->
      case result of
        Ok url ->
          (Success url, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)


-- Subscriptions

-- No subscribe, nothing new here
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW

-- View doesn't have anything new
view : Model -> Html Msg
view model =
  div []
    [ h2 [] [ text "Random Cats" ]
    , viewGif model
    ]


-- Nothing new here outside of using an img
viewGif : Model -> Html Msg
viewGif model =
  case model of
    Failure ->
      div []
        [ text "I could not load a random cat for some reason."
        , button [ onClick MorePlease ] [ text "Try again." ]
        ]

    Loading ->
      text "Loading..."

    Success url ->
      div []
        [ button [ onClick MorePlease, style "display" "block" ] [ text "More Please" ]
        , img [ src url ] []
        ]


-- HTTP
-- This section is new

-- This gets data from a url as json
-- `Http.expectJson` must take in a Msg type 
--   Since `GotGif` takes in a result, it gets the error part from HTTP and its success part is a string
--     The string is provided through gifDecoder
-- Upon removing the `Decoder` type from `gifDecoder` I learned `Http.expectJson` takes a second arg
-- which is a function
-- `GotGif` takes in a Result value where the last type constructor is a string
-- The `Http` function already returns the base of the `Result` type so we need to provide the final bit
-- which is the string
-- So we use GifDecoder to Decode the Json into a string variable
-- The decoding bit must take in a function that returns a Decoder and
-- whatever type the data must be
getRandomCatGif : Cmd Msg
getRandomCatGif =
  Http.get
    { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
    , expect = Http.expectJson GotGif gifDecoder
    }


-- This is new
-- `field` must be a function that returns a value for a given key
-- I guess "string" is how to interpret the value
-- But why is the return type `Decoder`?
-- Ohhh, it's related to `Http.expectJson`, i'll write more above.
gifDecoder : Decoder String
gifDecoder =
  field "data" (field "image_url" string)
