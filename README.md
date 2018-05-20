Google Maps APi + Yandex Geocoder

A small example the right way to share state between swift view controllers

This project have:
1) One Model "Place", which storage a structure of place (address, longiture, latitude)
2) Two ViewControllers: 
"MainVC" contains GoogleMap and Search Bar
"SearchVC" contains Search Bar and table with search result (you can type an adress into and app will autofill address by Yandex Geocoder API). After selecting a location, MainVC opens and sets the new placeholder for Search Bar and reload Google Map with new address.
3) "PlaceController" - its a Model Controller. I used it for saving new locations. "MainVC" get places from this Model Controller

I think, it is the best practice to storage and share state beetween controllers. 

Thank for your attention! If you think that I'm wrong, I'm waiting your feedback. 

Best regards, atymx!
