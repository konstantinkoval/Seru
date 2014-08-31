Seru (セル)
=====

##Core Date Stack in Swift.
Seru is a light library that is designed to remove boilerplate code and make work with CoreDate extremely easy.  
Now you can remove all the boilerplate code generated by default apple template and replace it with **1** line of code `PersistenceLayer()`


## Usages

#### Setup CoreData

Setup Core data stack with model name that matches project name.
```swift
class AppDelegate: UIResponder, UIApplicationDelegate {            
  lazy var persistence = PersistenceLayer()
  ...
```

Use custom name for model file  
```swift
  PersistenceLayer(name: "MyModel")
```

Seru provides default error handler. You can provide your own error handler.
```swift
PersistenceLayer(name: "Example", errorHandler:
  ErrorHandler(errorHandler: { error in
  // custom error handling for all issue related with CoreData
})
```

#### Save

Save main NSManagedObjectContext
```swift
var persistenceController: PersistenceLayer
persistenceController.persist()
```

Save other NSManagedObjectContext
```swift
var otherContenxt: NSManagedObjectContext
var persistenceController: PersistenceLayer
persistenceController.persist(otherContenxt)
```