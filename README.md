An iOS app for discovering movies, browsing details, and reading user reviews, powered by [The Movie Database (TMDB) API](https://developer.themoviedb.org/docs). Built with UIKit and VIPER architecture for the Binar Academy – Mandiri Technical Test.

## Features

- **Discover movies by genre** — genre chips filter the movie list
- **Movie details** — poster, rating, overview, and a preview of user reviews
- **User reviews** — full review list per movie
- **Infinite scrolling** — paginated loading for both movies and reviews
- **Loading states** — shimmer placeholders while content loads
- **Error handling** — toast messages and inline retry views when requests fail
- **Image loading & caching** via Kingfisher

## Tech Stack

| Layer | Technology |
| --- | --- |
| Language | Swift |
| UI | UIKit (XIB-based views) |
| Architecture | VIPER |
| Concurrency | Swift Concurrency (`async`/`await`) |
| Networking & data | [MovieDBDataLayer](https://github.com/Fostahh/MovieDBDataLayer) — own Swift package built on `URLSession` |
| Image loading | [Kingfisher](https://github.com/onevcat/Kingfisher) |
| Dependencies | Swift Package Manager (resolved automatically on first build) |
| Configuration | `.xcconfig` build settings (API token, base URLs) |

## Architecture

The app follows **VIPER** (View, Interactor, Presenter, Entity, Router), with one module per screen and networking extracted into a separate Swift package.

```
View ──▶ Presenter ──▶ Interactor ──▶ MovieRepository (MovieDBDataLayer)
  ▲          │                              │
  └──────────┘                              ▼
           Router                RemoteDataSource ──▶ TMDB API
```

- **View** — UIKit view controllers, rendering only; forwards events to the Presenter
- **Presenter** — presentation logic and view state (pagination via `Paginator`, display models)
- **Interactor** — business logic; talks to the data layer
- **Router** — navigation between modules, built via `ScreenFactory`
- **[MovieDBDataLayer](https://github.com/Fostahh/MovieDBDataLayer)** — separate Swift package with the repository, remote data source, network layer, and DTO → domain mapping

## Project Structure

```
MovieDB/
├── App/                    # AppDelegate, SceneDelegate, AppNavigator,
│                           # ScreenFactory, AppConfigurator
├── Configs/
│   └── Development.xcconfig  # AUTH_TOKEN, BASE_URL, IMAGE_BASE_URL
└── UI/
    ├── ListMovie/          # Movie list module (VIPER)
    ├── Detail/             # Movie detail module (VIPER)
    ├── ListReview/         # Review list module (VIPER)
    ├── Components/         # ShimmerView, ToastView, ReviewView
    ├── Shared/             # Shared display models
    └── Utils/              # Paginator, ImageURLBuilder, extensions
```

## Requirements

- iOS 15.0+
- Xcode 26+
- A TMDB **API Read Access Token** ([get one here](https://www.themoviedb.org/settings/api))

## Acknowledgements

- Movie data provided by [The Movie Database (TMDB)](https://www.themoviedb.org/). This product uses the TMDB API but is not endorsed or certified by TMDB.
