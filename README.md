# TechnologicalTasks
An application for setting up and managing daily tasks with possible backups using server resources.

**Skills:** UIKit · SwiftUI · AutoLayout · FileManager · SQLite · CoreData · URLSessions · GCD · CocoaPods · SPM · MVC · XCTest · SwiftLint · CocoaLumberjack

This application presents two targets for UIKit (base) and SwiftUI in readonly mode. Dark theme and landscape mode are supported.

The task list is stored in a file (using FileManager and JSON parsing), SQLite and CoreData databases. Backup to the server via http requests (using URLSession) is also used.
In a situation of desynchronization there is data marking as dirty with subsequent updating and forced updating via RefrechControl.

CocoaLumberjack (SPM) is used to log events. SwiftLint (Pods) for code quality control. XCText is used to perform unit testing FileCache methods.



