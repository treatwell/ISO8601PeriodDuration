# ISO8601PeriodDuration

## Usage

Lightweight library to parse [ISO 8601 period-duration](https://en.wikipedia.org/wiki/ISO_8601#Durations) strings into [DateComponents](https://developer.apple.com/documentation/foundation/datecomponents), motivated by the lack of support for this standard in Foundation.

It's a rough equivalent of [Java's PeriodDuration](https://www.threeten.org/threeten-extra/apidocs/org.threeten.extra/org/threeten/extra/PeriodDuration.html), except it only provides the parsing side of its functionality, leaving representation to the built-in [DateComponents](https://developer.apple.com/documentation/foundation/datecomponents).

It leverages Swift 5.1's property wrappers in order to make parsing functionality as unintrusive as possible, optimistic for a seamless drop-in replacement when/if Apple ever introduces a similar solution into Foundation.

### Example

Consider the following struct:

```swift
struct Appointment: Decodable {
    @ISO8601PeriodDuration var duration: DateComponents
}
```

Decoded with the following JSON:

```json
{
    "duration": "PT2H30M"
}
```

It'll yield:

```swift
DateComponents
    .year -> nil
    .month -> nil
    .day -> nil
    .hour -> 2
    .minute -> 30
    .second -> nil
```

*Note:* weeks (`P3W`) are supported, though they end up translated to days.

## Author Information

[David Roman](https://github.com/davdroman) - david.roman@treatwell.com

## License

The contents of this repository are [licensed](LICENSE) under the [Apache License, version 2.0](http://www.apache.org/licenses/LICENSE-2.0).

