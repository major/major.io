---
aktt_notify_twitter:
- false
aliases:
- /2009/01/09/writing-a-ruby-on-rails-application-without-using-a-database/
author: Major Hayden
date: 2009-01-09 17:00:44
tags:
- database
- ruby on rails
title: Writing a Ruby on Rails application without using a database
---

Some of you may be wondering &#8220;why would you want to use Rails without a database?&#8221; There are several situations why a database would not be needed, and I've run into quite a few of them. One of the specific cases was when I wanted to write a web interface for an application that only had a REST interface available to the public.

If you find yourself needing to write a Rails application without a database, just do the following:

**For Rails 1.0 and up:**

`config/environment.rb`:

<pre lang="rails">config.frameworks -= [ :active_record ]</pre>

`test/test_helper.rb`

<pre lang="rails">class Test::Unit::TestCase
  self.use_transactional_fixtures = false
  self.use_instantiated_fixtures  = false
  def load_fixtures
  end
end</pre>

**For Rails 2.1 and up:** Comment out both of the lines that begin with `ActiveRecord::Base` in `config/initializers/new_rails_defaults.rb`:

<pre lang="rails">if defined?(ActiveRecord)
  # Include Active Record class name as root for JSON serialized output.
  # ActiveRecord::Base.include_root_in_json = true

  # Store the full class name (including module namespace) in STI type column.
  # ActiveRecord::Base.store_full_sti_class = true
end
</pre>

For more details, review the [full article][1] on [rubyonrails.org][2].

 [1]: http://wiki.rubyonrails.org/rails/pages/HowToUseRailsWithoutADatabase
 [2]: http://rubyonrails.org