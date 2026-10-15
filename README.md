# Author Search 

![Swift](https://img.shields.io/badge/Swift-F05138?logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-0D96F6?logo=swift&logoColor=white)
![SwiftData](https://img.shields.io/badge/SwiftData-0D96F6?logo=swift&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?logo=apple&logoColor=white)

> Search for authors, read about them and browse everything they've written.

Author Search is an iOS app built on the [Open Library API](https://openlibrary.org/developers/api). Search for an author, open their details, add your own photos to their gallery, and scroll through their complete list of works.

Built as the exam project for **iOS Programming** (15 ECTS) at Kristiania University College.


## Features

- **Search as you type** with a debounce, so the API isn't hit on every keystroke
- **Author details** with birth and death dates, biography, top work, work count and top subjects
- **Photo gallery** with the author's photos from Open Library, plus your own photos from the camera or the library, saved on the device with SwiftData
- **Works list** with infinite scroll (50 per page) and sorting by title or first publish year
- **Tab navigation** where picking an author in search jumps straight to the details tab
- **Animated splash screen**

## Tech stack

| Area | Tools |
| --- | --- |
| Language & UI | Swift, SwiftUI |
| Persistence | SwiftData |
| Reactive search | Combine (debounced search query) |
| Networking | URLSession with async/await, Codable models |
| UIKit interop | `UIImagePickerController` wrapped in `UIViewControllerRepresentable` |
| Data source | [Open Library API](https://openlibrary.org/developers/api) (no API key needed) |

## Architecture

```
AuthorSearch/
├── Contexts/    AppState (selected author + tab), SearchContext (debounced search), ImagePicker
├── Models/      Author, SearchAuthor, Work, UserPhoto (SwiftData)
├── Services/    AuthorService: search, author details and paginated works
└── Views/
    ├── SearchTab/    Search field and result list
    ├── DetailsTab/   Author details and photo gallery
    ├── WorksTab/     Paginated, sortable works list
    └── SplashView    Animated intro
```

Two shared objects drive the app. `AppState` holds the selected author and the current tab, and is passed down as an environment object so every tab can react when you pick an author. `SearchContext` owns the query and debounces it before calling `AuthorService`, which keeps all networking out of the views. The author endpoint returns the biography either as a plain string or as an object, so `Bio` is a custom `Codable` enum that handles both.

## Getting started

### Prerequisites

- Xcode 15 or newer
- A simulator or device running iOS 17 or newer (the app uses SwiftData)

No API keys or other setup needed. Open Library is open, but you need an internet connection.

### Run it

```bash
git clone https://github.com/breadbakerlevi/author-search.git
cd author-search
open AuthorSearch.xcodeproj
```

Pick a simulator and hit **Run** (⌘R). The **Take Photo** option needs a real device, since the simulator has no camera. **Choose from Library** works in the simulator.

## Credits

Open Library for the data. The sources that helped with the debounced search, the image picker and the Codable handling are listed in the comments at the top of the files that use them.
