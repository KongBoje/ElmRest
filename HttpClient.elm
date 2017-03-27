import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Debug exposing (log)

type Msg
  = NewCount (Result Http.Error Int)
  | GetCount
  | SendPut
  | SetModel String
  | PutResponse (Result Http.Error String)

type alias Model
  = {counter : Int, value : String}

view : Model -> Html Msg
view model =
  div [] [
    div [] [ text ("Welcome to my elm counter") ]
    , button [ onClick GetCount ] [ text "inc count"]
    , div [] [ text (toString model.counter) ]
    , hr [] []
    , input [ placeholder "New value", onInput SetModel ] []
    , button [ onClick SendPut ] [ text "Put it!" ]
    , textarea [] [ text model.value ]
  ]

decodeCounter : Decode.Decoder Int
decodeCounter = Decode.at ["Count"] Decode.int

getRandomCounter : String -> Cmd Msg
getRandomCounter topic =
  let
    url = "http://localhost:3000" ++ topic
  in
    Http.send NewCount (Http.get url decodeCounter)

sendPutToServer : String -> Cmd Msg
sendPutToServer message =
  let
    request = Http.request
      { method = "PUT"
      , headers = []
      , url = "http://localhost:3000/counter/" ++ message
      , body = Http.emptyBody
      , expect = Http.expectString
      , timeout = Nothing
      , withCredentials = False
      }
  in
    Http.send PutResponse request

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    NewCount (Ok foo) -> ({model | counter = foo}, Cmd.none)
    NewCount (Err _) -> (model, Cmd.none)
    GetCount -> (model, getRandomCounter "/counter")
    SetModel s -> ({model | value = s}, Cmd.none)
    SendPut -> (model, sendPutToServer model.value)
    PutResponse (Ok ok) -> ({model | value = ok}, Cmd.none)
    PutResponse (Err error) -> ({model | value = (toString error)}, Cmd.none)

main =
  Html.program
    { init = (Model 0 "Result", Cmd.none)
    , view = view
    , update = update
    , subscriptions = \x -> Sub.none }
