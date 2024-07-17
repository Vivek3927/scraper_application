##### 1. Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby [3.0.1](https://github.com/Vivek3927/scraper_application.git)
- Rails [6.1.5](https://github.com/Vivek3927/scraper_application.git)

##### 2. Check out the repository

```bash
git clone https://github.com/Vivek3927/scraper_application.git
cd scraper_application
bundle install
```

##### 3. Create and setup the database

Run the following commands to create and setup the database.

```ruby
rails db:create
rails db:migrate
```

##### 4. Start the Rails server

You can start the rails server using the command given below.

```ruby
rails s
```

And now you can visit the site with the URL http://localhost:3000/companies

