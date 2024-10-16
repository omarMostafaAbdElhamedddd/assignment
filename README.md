E-Commerce Flutter App(assignment app)
Overview
This is a simple e-commerce mobile app built using Flutter. The app allows users to browse products, add items to a cart or favorite list, and proceed to checkout. Features like login with Firebase, product fetching from a backend API, cart management, and favorite list are implemented. The project also includes simple animations to enhance the user experience, with Provider, Bloc, and the MVVM (Model-View-ViewModel) design pattern used to structure the application.

Features Implemented
Splash Screen: The app shows a splash screen when opened.
Authentication:
Login and create account with Firebase Authentication.
Option to enter as a guest (Note: only logged-in users can add to the favorite list).
Home View:
Displays products fetched from the backend API.
Pagination for loading more products.
Users can add products to the cart or favorite list (only after logging in).
Navigate to the cart and favorite from the home view.
Product Details View:
Displays detailed information about each product.
Users can add products to their cart or favorite.
"Buy Now" option available.
Cart View:
Users can manage the quantity of each product in the cart.
Option to delete products from the cart.
Displays the total price of all products in the cart.
Proceed to checkout and confirm the order.
Favorite View:
Displays all favorite products (only available after logging in).
Option to remove products from the favorite list.
Animations:
Simple animations for product image transitions and cart updates to enhance the user experience.
Design Pattern: MVVM
I implemented the MVVM (Model-View-ViewModel) design pattern to keep the codebase well-structured and maintainable:

Model: Represents the data and business logic, including models for products and cart items.
View: Contains the UI components such as product list views, cart view, and favorite list view.
ViewModel: Acts as an intermediary between the view and the model, handling all logic related to fetching data from the backend, managing state, and updating the UI through state management.
This approach ensures that the app is scalable and each component is modular, making it easier to manage as the app grows.

State Management
Bloc: Used to manage the state of fetching products, adding products to the cart, and favorite actions.
Provider: Used for simpler state management, including connectivity status and authentication checks.
Technical Details
Backend API: FakeStore API is used to fetch product data (https://fakestoreapi.com/).
Firebase: Firebase Authentication was used for login and user creation. A user must be logged in to add products to the favorite list.
Local Storage: Used Hive for storing product data to allow basic offline functionality. Users can browse previously fetched products even without an internet connection.
Animations: Implemented simple animations for smoother user experience, especially with product transitions and cart updates.
Challenges and Time Constraints
Due to limited time, I prioritized completing the core functionalities of the project, including product fetching, cart and favorite management, and user authentication. Balancing this task with other ongoing work was a challenge, but I ensured that the essential features were well-implemented and that the app was functional.

Future Improvements
Given more time, I would like to:

Add product search functionality.
Implement an offline-first strategy to allow syncing product data when the user reconnects to the internet.
Add more advanced animations.
Improve test coverage with unit and widget tests.

Conclusion
This project demonstrates my understanding of Flutter, state management using Provider and Bloc, backend integration with APIs and Firebase, and the MVVM design pattern. Simple animations were also added to enhance the user experience. Despite the time constraints, I successfully implemented the core features and ensured the app is functional with room for future improvements.
