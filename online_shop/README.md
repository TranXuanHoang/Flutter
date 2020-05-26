# online_shop

Create a simple online shopping app that provides the following functionalities

* Sign-up, login, logout
* Also provide auto login when opening the app again, and auto logout when a specific period of time has passed
* View all products that are being sold
* Make purchase orders (no payment at this time), and view orders history
* Add/update/delete products that are being managed by users (each user can only update/delete products that he/she added before)
* Mark products as favorite and filter out favorite products
* View product details

The app persists the data in a [Firebase](https://firebase.google.com/) Realtime Database.

## List of Main Screens

|Sign Up  |Login |Handle Authentication Form Error |
|---------|---------|---------|
|![Sign Up](./snapshots/1-1-Signup.png) |![Login](./snapshots/1-2-Login.png) |![Handle Authentication Form Error](./snapshots/1-3-AuthenticationFormErrorHandling.png) |
|Sign Up Form |Logout and Re-Login |Product Overview Screen |
|![Sign Up Form](./snapshots/1-4-SignupInputForm.png) |![Logout and Re-Login](./snapshots/1-5-LogoutAndLoginAgain.gif) |![Product Overview Screen](./snapshots/2-1-Home.png) |
|Left-hand-side Drawer Menu |Product Detail Screen |Place an Order |
|![Left-hand-side Drawer Menu](./snapshots/2-2-SideDrawerMenu.png) |![Product Detail Screen](./snapshots/2-3-ProductDetail.gif) |![Place an Order](./snapshots/2-4-PlaceAnOrder.gif) |
|Add a New Product to the Shop |Update Product Information |Delete a Product from the Shop |
|![Add a New Product to the Shop](./snapshots/2-5-AddANewProduct.gif) |![Update Product Information](./snapshots/2-6-UpdateProduct.gif) |![Delete a Product from the Shop](./snapshots/2-7-DeleteProduct.gif) |
