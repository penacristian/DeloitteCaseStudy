# DeloitteCaseStudy

Project distribution
The project is divided into 4 main sections:
  UI. All user interface-related classes.
  Service. All server-related classes.
  Data Base. All database-related classes.
  Util. All extra classes used by the application.
  
The UI was created using a TabBar distribution with three main sections: a Catalog, a Shopping Cart, and a Wishlist.
The Catalog has two ViewControllers: one that shows all categories of products and the second one that shows the product
inside the selected category.
All product-related view controllers inherit from a super class that implements all the methods needed to show a table view 
of products.
MCV paradigm was used in the application. Communication between table view cells and it's parent view was implemented
using a protocol.
  
Service is formed by 1 class named service that includes methods for the four endpoints of the server.

The Database was created using Core Data and managed by a main class named DataManager. The DataManager is responsible for 
inserting, deleting and modifying objects as well as managing the managedObjectContext and persistentStoreCoordinator. 
The database has 3 entities. Products, Categories and ShoppingCart. 
All objects of the database are created once. Products are managed by productId and Categories by name. The last one is a 
singleton created only once and used across the application.

There's only one util in this version of the application. A theme manager responsible for all colours and view controllers 
aesthetic configurations.

Important Note: The delete product from cart endpoint works but takes nearly 1 minute.
