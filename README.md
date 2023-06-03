# SwiftSubRip 💬

Parser for the [SubRip](https://en.wikipedia.org/wiki/SubRip) format written using RegexBuilder in modern Swift.

#### Convert

```
1
00:00:00,000 --> 00:00:04,000
In the twilight's gentle glow,

...
```

#### Using
```swift
let subtitles = Subtitles(from: <fileUrl>)
```

#### Get subtitle at given time
```swift
subtitles.subtitle(at: 2) // { from: 0.0, to: 4.0, text: "In the twilight's gentle glow," }
```

#### Get text at given time
```swift
subtitles.getText(at: 2) // "In the twilight's gentle glow,"
```
