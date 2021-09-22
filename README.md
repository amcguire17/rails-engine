
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT LOGO -->
<br />
<p align="center">

  <h3 align="center">Rails Engine</h3>

</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
        <li><a href="#endpoints">Endpoints</a></li>
      </ul>
    </li>
    <li>
      <a href="#setup">Setup</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
        <li><a href="#project_configurations">Project Configurations</a></li>
      </ul>
    </li>
    <li><a href="#contributing">Contributing</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

Rails Engine is a 7 day solo project during Mod 3 of 4 for Turing School's Back End Engineering Program.

The objective of Rails Engine is to expose an API for an E-Commerce Application that can be consumed by a front end team.

Learning Goals:
* Expose an API
* Use serializers to format JSON responses
* Test API Exposure
* Compose advanced ActiveRecord queries to analyze information stored in SQL databases
* Write basic SQL statements without the assistance of an ORM

This project was challenging but also enjoyable for me. I practiced project management and breaking down large problems into smaller steps.

### Endpoints

| route | description |
|-------|-------------|
| GET /api/v1/merchants | Get all merchants (default 20 per page) |
| GET /api/v1/merchants?per_page=number&page=number | Get all merchants using pagination |
| GET /api/v1/merchants/id | get one merchant by id |
| GET /api/v1/merchants/id/items | get all items for one merchant by id |
| GET /api/v1/merchants/find?name=text | get merchant by name |
| GET /api/v1/merchants/find_all?name=text | get all merchants by name |
| GET /api/v1/items | Get all items (default 20 per page) |
| GET /api/v1/items?per_page=number&page=number | Get all items using pagination |
| GET /api/v1/items/id | get one item by id |
| POST /api/v1/items | create an item |
| PATCH /api/v1/items/id | update an item |
| DELETE /api/v1/items/id | delete an item |
| GET /api/v1/items/id/merchant | get an item's merchant |
| GET /api/v1/items/find?name=text | get item by name |
| GET /api/v1/items/find?min_price=number | get item by minumum price |
| GET /api/v1/items/find?max_price=number | get item by maximum price |
| GET /api/v1/items/find?min_price=number&max_price=number | get item by price range |
| GET /api/v1/items/find_all?name=text | get all items by name |
| GET /api/v1/revenue/merchants?quantity=number | get x amount of merchants by most revenue |
| GET /api/v1/merchants/most_items?quantity=number | get x amount of merchants by most items |
| GET /api/v1/revenue?start=date&end=date | get revenue by date range |
| GET /api/v1/revenue/merchants/id | get revenue for a merchant by id |
| GET /api/v1/revenue/items | get top ten items by revenue |
| GET /api/v1/revenue/items?quantity=number | get x amount of items by most revenue |
| GET /api/v1/revenue/unshipped | get top ten invoices for unshipped revenue |
| GET /api/v1/revenue/unshipped?quantity=number | get x amount of invoices for unshipped revenue |
| GET /api/v1/revenue/weekly | get revenue by week |


### Built With

* Ruby 2.7.2
* Rails 5.2.6
* PostgreSQL
* RSpec
* SimpleCov
* Factory Bot/Faker
* Fast JSON API
* Rubocop



<!-- GETTING STARTED -->
## Setup

This project requires Ruby 2.7.2.

### Installation

1. Fork this repository
2. Clone the fork
3. From the command line, install gems and set up your DB:
   * `bundle install`
   * `rails db:{create,migrate,seed}`
   * Run `rails db:schema:dump` to check `schema.rb`
4. Run the test suite with bundle exec rspec.
5. Run your development server with rails s to see the app in action.

#### Project Configurations

* Ruby version
    ```bash
    $ ruby -v
    ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-darwin20]
    ```

* [System dependencies](https://github.com/bfl3tch/little-esty-shop/blob/main/Gemfile)
    ```bash
    $ rails -v
    Rails 5.2.6
    ```

* Database creation
    ```bash
    $ rails db:{drop,create,migrate}
    Created database 'rails-engine_development'
    Created database 'rails-engine_test'
    ```

* How to run the test suite
    ```bash
    $ bundle exec rspec -fd
    ```

* [Local Deployment](http://localhost:3000), for testing:
    ```bash
    $ rails s
    => Booting Puma
    => Rails 5.2.6 application starting in development
    => Run `rails server -h` for more startup options
    Puma starting in single mode...
    * Version 3.12.6 (ruby 2.7.2-p137), codename: Llamas in Pajamas
    * Min threads: 5, max threads: 5
    * Environment: development
    * Listening on tcp://localhost:3000
    Use Ctrl-C to stop

    ```

<!-- CONTACT -->
## Contact

[Amanda McGuire](https://github.com/amcguire17)

Project Link: [Rails Engine](https://github.com/amcguire17/rails-engine)


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/amcguire17/rails-engine.svg?style=for-the-badge
[contributors-url]: https://github.com/amcguire17/rails-engine
[forks-shield]: https://img.shields.io/github/forks/amcguire17/rails-engine.svg?style=for-the-badge
[forks-url]: https://github.com/amcguire17/rails-engine/network/members
[stars-shield]: https://img.shields.io/github/stars/amcguire17/rails-engine.svg?style=for-the-badge
[stars-url]: https://github.com/amcguire17/rails-engine/stargazers
[issues-shield]: https://img.shields.io/github/issues/amcguire17/rails-engine.svg?style=for-the-badge
[issues-url]: https://github.com/amcguire17/rails-engine/issues
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/amanda-e-mcguire/
