**Basic Features:**

a. This is pretty very simple app, on launch of the app it will load the fruits list from an Api. User can select any fruit from the list to navigate to detail screen and see the details of the fruits
    •    Price in pounds and pence 
    •    Weight in KG  
b. The user can be able to invoke a reloading of the fruit api by pull to refresh on the fruit list screen.
c. The app send usage stats to the server with 
    .    event=load – For any network request  the associated data is the time taken (in ms) for the request to complete
    .    event=display – whenever a screen is shown. The associated data is in time taken (in ms) from when the user initiated the request that would show the screen to the point where the screen has finished drawing on the device 
    .    event=error – Apps send the error response to the server as a usage stats. 
    
**Universal app**
App works on both iPhone and iPad and different orientations
Minimum iOS deployment target is 14.0

**App demontrate Technical approach of:-**
a. Code structure and software architecture  - using MVVM CLEAN architecture with SOLID Principle
b. Combine used to bind VieModel to View 
d. Unit test cases - Test with Mock Api and response, testing of View Models, UITestCases for list and detail screens.
e. Coding best practice - For Modularity, Readability and Scalability , protocol orientated programming, extension, codable, dependency injection for better Testability of the code.
 g. Support dark mode - as all the colors are by default system color.
 
**Future enhancement**
a. Dynamic Type Accessibility.
b. Write performance XCTMeasure test case for XCTMemoryMetric and XCTCPUMetric.
c. Send stats for application crashes and exceptions.
d. Improve UI

**Screen shot**


![image](https://user-images.githubusercontent.com/19665932/156553516-d3b39cd1-d681-4a36-a4c0-5e6e5f3f63dd.png)

![image](https://user-images.githubusercontent.com/19665932/156553572-401e3926-b8e2-4873-af12-73da6c88fff1.png)
