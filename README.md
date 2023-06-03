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
```
let subtitles = Subtitles(from: <fileUrl>)
```

#### Into
```
Subtitles {
  entries: [
    Subtitle {
      from: 0.0
      to: 4.0
      text: "In the twilight's gentle glow,"
    }
  ]
}
```

#### Get text at given time
```
subtitles.getText(at: 2) // "In the twilight's gentle glow,"
```
