# avocet

A Visualisation Of Collected Enteresting [*sic*] Things (avocet) is a single page web app written in [Elm](http://elm-lang.org) that displays various user-defined information in JSON as cards (like a status board).

### Background

This project is part of [52projects](https://donny.github.io/52projects/) and the new stuff that I learn through this project: [elm-mdl](https://debois.github.io/elm-mdl/),
[elm-decode-pipeline](https://github.com/NoRedInk/elm-decode-pipeline), and better understanding of [Elm](http://elm-lang.org).

### Project

The app accepts a JSON resource URL and displays the information as cards using the [Material Design Lite](https://getmdl.io) design language. The screenshot of the app:

![Screenshot](https://raw.githubusercontent.com/donny/avocet/master/screenshot.png)

The JSON file itself must be of the following structure:

```javascript
[
  {"title": "Title", "text": "Background is Indigo", "footer": "Icon: error", "icon": "error", "color": "Indigo" },
  {"title": "Title", "text": "Background is Blue", "footer": "Icon: warning", "icon": "warning", "color": "Blue" }
]
```

It's an array of objects where each object has 5 fields: `title`, `text`, `footer`, `icon` (one of the [Material icons](https://material.io/icons/)), and `color` (one of the [Material colors](https://material.io/guidelines/style/color.html)).

This app allows us to provide the *display component* for subsequent projects. In other words, if we build APIs in future projects, we can use [Avocet](https://github.com/donny/avocet) to consume and visualise the data in a human-friendly way. The app can be deployed to Heroku with little or no configuration.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

### Implementation

The `card` data structure is represented by the following Elm record:

```elm
type alias Card =
    { title : String
    , text : String
    , footer : String
    , icon : String
    , color : String
    }
```
