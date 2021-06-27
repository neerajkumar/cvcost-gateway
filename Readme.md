# SpreeRazorpay

API gateway is the single entry point for all clients. The API gateway handles requests in one of two ways. Some requests are simply proxied/routed to the appropriate service. It handles other requests by fanning out to multiple services.

Using an API gateway has the following benefits:

- Insulates the clients from how the application is partitioned into microservices
- Insulates the clients from the problem of determining the locations of service instances
- Provides the optimal API for each client
- Reduces the number of requests/roundtrips. For example, the API gateway enables clients to retrieve data from multiple services with a single round-trip. Fewer requests also means less overhead and improves the user experience. An API gateway is essential for mobile applications.
- Simplifies the client by moving logic for calling multiple services from the client to API gateway
- Translates from a “standard” public web-friendly API protocol to whatever protocols are used internally

`cvcost-gateway` consists the authentication and authorisation. Authentication has been implemented using `UserServices`. Authorisation has been implemented using `cancancan`. It also consists redis to cache some of your requests.

## Installation

```ruby
bundle Install
```

Use
```ruby
bundle exec foreman start
```
to start the server.