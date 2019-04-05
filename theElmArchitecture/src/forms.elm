-- Import modules for making the magic happen
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


-- MAIN

-- Run the app!
main =
  Browser.sandbox { init = init, update = update, view = view }


-- Model


-- Our model is a record with three string properties
type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  }


-- Initializing our state -- NOTE Interesting way of assigning values
init : Model
init =
  Model "" "" ""


-- UPDATE

-- Update ADT
type Msg
  = Name String
  | Password String
  | PasswordAgain String


-- Update func
update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }


-- VIEW

-- Here is where new exciting things are introduced! Functions to return elements!
view : Model ->  Html Msg
view model =
  div []
    [ viewInput "text" "Name" model.name Name
    , viewInput "password" "Password" model.password Password
    , viewInput "password" "Re-enter password" model.passwordAgain PasswordAgain
    , viewValidation model
    ]


viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []


viewValidation : Model -> Html Msg
viewValidation model =
  if model.password == model.passwordAgain then
    div [ style "color" "green" ] [ text "OK" ]
  else
    div [ style "color" "red" ] [ text "Passwords do not match!" ]
