# KeychainHelper

`KeychainHelper` is a Swift utility that simplifies saving, retrieving, updating, and deleting sensitive data in the iOS Keychain. This helper struct uses Apple's Security framework and is designed to handle keychain operations in a clean and secure way.

## Features

- **Save value**: Store sensitive data securely in the Keychain.
- **Retrieve value**: Fetch stored data from the Keychain.
- **Update value**: Modify existing data stored in the Keychain.
- **Delete value**: Remove stored data from the Keychain.

## Installation

### Swift Package Manager

You can install `BMKeychain` by adding it via the Swift Package Manager (SPM) in Xcode.

#### Adding to a Project

1. In Xcode, select your project in the navigator.
2. Choose **Package Dependencies**.
3. Click the **+** button to add a new package.
4. Enter the following URL:  
   `https://github.com/BakrIOS91/BMKeychain`
5. Select the relevant version and click **Add Package**.
6. Once added, you can import `BMKeychain` where needed in your project:

   ```swift
   import BMKeychain
   ```

#### Adding to a Swift Package

To include `BMKeychain` as a dependency in your own Swift package, add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/BakrIOS91/BMKeychain", from: "0.1.1")
]
```

Then include `BMKeychain` as a dependency in your targets:

```swift
.target(
    name: "YourTarget",
    dependencies: ["BMKeychain"]
)
```

## Usage

### 1. Saving a Value
Use `saveValue(_:forKey:)` to store a string in the Keychain. If a value already exists for the given key, it will be updated.

```swift
try KeychainHelper.shared.saveValue("password123", forKey: "userPassword")
```

### 2. Retrieving a Value
Retrieve a stored value from the Keychain using `retrieveValue(forKey:)`. It returns an optional `String`.

```swift
let password = try KeychainHelper.shared.retrieveValue(forKey: "userPassword")
```

### 3. Updating a Value
Update an existing value using `updateValue(_:forKey:)`.

```swift
try KeychainHelper.shared.updateValue("newPassword456", forKey: "userPassword")
```

### 4. Deleting a Value
Delete a stored value using `deleteValue(forKey:)`.

```swift
try KeychainHelper.shared.deleteValue(forKey: "userPassword")
```

## Error Handling

`KeychainHelper` uses custom errors defined as `KeychainError` to handle various failure cases like:

- case failedToConvertValueToData
- case failedToSaveValue
- case failedToRetrieveValue
- case faildToDeleteValue
- case failedToUpdateValue

Make sure to handle these errors appropriately in your application.
