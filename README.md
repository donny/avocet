# avocet

A Visualisation Of Collected Enteresting [*sic*] Things (avocet) is a single page web app written in [Elm](http://elm-lang.org) that displays various user-defined information in JSON as cards (like a status board).

### Background

This project is part of [52projects](https://donny.github.io/52projects/) and the new stuff that I learn through this project: [elm-mdl](https://debois.github.io/elm-mdl/),
[elm-decode-pipeline](https://github.com/NoRedInk/elm-decode-pipeline), and better understanding of [Elm](http://elm-lang.org).

### Project

The app accepts a JSON resource URL and displays the information as cards using the [Material Design Lite](https://getmdl.io) design language. The screenshot of the app:

![Screenshot](https://raw.githubusercontent.com/donny/avocet/master/screenshot.png)

The JSON file itself must be of the following structure:

```json
[
  {"title": "Title", "text": "Background is Indigo", "footer": "Icon: error", "icon": "error", "color": "Indigo" },
  {"title": "Title", "text": "Background is Blue", "footer": "Icon: warning", "icon": "warning", "color": "Blue" }
]
```

It's an array of objects where each object has 5 fields: `title`, `text`, `footer`, `icon` (one of the [Material icons](https://material.io/icons/)), and `color` (one of the [Material colors](https://material.io/guidelines/style/color.html)).

This app allows us to provide the *display component* for subsequent projects. In other words, if we build APIs in future projects, we can use [Avocet](https://github.com/donny/avocet) to consume and visualise the data in a human-friendly way. The app can be deployed to Heroku with little or no configuration.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

### Implementation

The `card` data is represented by the following Elm record:

```elm
type alias Card =
    { title : String
    , text : String
    , footer : String
    , icon : String
    , color : String
    }
```

Using [elm-decode-pipeline](https://github.com/NoRedInk/elm-decode-pipeline), we can decode the `card` in a much nicer way:

```elm
cardDecoder : Decoder Card
cardDecoder =
    decode Card
        |> required "title" string
        |> required "text" string
        |> optional "footer" string ""
        |> optional "icon" string ""
        |> optional "color" string "Grey"
```

The JSON decoder code above looks really nice and simpler compared to using the built-in Elm `map` function. And then, using the [elm-mdl](https://debois.github.io/elm-mdl/) library, we display each individual `card` with the following code:

```elm
viewCard : Model -> Card -> Html Msg
viewCard model card =
    Card.view
        [ css "width" "200px"
        , css "margin" "16px 16px 16px 16px"
        , Color.background (Color.color (colorHue card.color) Color.S400)
        ]
        [ Card.title [] [ Card.head [ Color.text Color.white ] [ text card.title ] ]
        , Card.text [ Card.expand ] [ text card.text ]
          -- Filler
        , Card.actions
            [ Card.border
            , Color.text Color.white
              -- Modify flexbox to accomodate small text in action block
            , css "display" "flex"
            , css "justify-content" "space-between"
            , css "align-items" "center"
            , css "padding" "8px 16px 8px 16px"
            ]
            [ Options.span
                [ Typography.body1, Typography.contrast 0.87 ]
                [ text card.footer ]
            , Icon.i card.icon
            ]
        ]
```

We can understand the code above by putting it side by side with the screenshot, and follow the lines. The CSS style is incorporated as Elm code which makes it easier to modify in one single file and we don't need to use CSS preprocessors. I think this is okay for small scale projects. I do find the examples of [elm-mdl](https://github.com/debois/elm-mdl/tree/master/examples) to be really valuable in understanding how it works. Specifically, we can compare how the Elm `Counter` example works [with](https://github.com/debois/elm-mdl/blob/master/examples/Counter.elm) and [without](https://github.com/debois/elm-mdl/blob/master/examples/Counter-no-shorthand.elm) elm-mdl's syntactic sugar.

### Conclusion

In general, I like using [elm-mdl](https://debois.github.io/elm-mdl/) and it feels nicer compared to using Bootstrap 4 (in my previous [Elm project](https://github.com/donny/elmutt)). And definitely, I'll be using [elm-decode-pipeline](https://github.com/NoRedInk/elm-decode-pipeline) to decode JSON in my future Elm projects. So much better!

Elm itself is amazing. I do enjoy writing Elm and the compiler catches many common mistakes. Once it compiles the code successfully, I can be assured that it works, and I can refactor the code confidently. More information about Elm itself:

- [An Introduction to Elm](https://guide.elm-lang.org)
- [Elm in Action](https://www.manning.com/books/elm-in-action)
- [Elm Tutorial](https://www.elm-tutorial.org/en/)
- [Awesome Elm](https://github.com/isRuslan/awesome-elm)
