# 
# Install the MYSQL driver
#   gem install mysql2
#
# Ensure the MySQL gem is defined in your Gemfile
#   gem 'mysql2'
#
# And be sure to use new-style password hashing:
#   http://dev.mysql.com/doc/refman/5.0/en/old-client.html
development:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: vn_trans
  pool: 5
  username: vn_trans
  password: 
  socket: /var/run/mysqld/mysqld.sock

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: vn_trans_test
  pool: 5
  username: vn_trans
  password:
  socket: /var/run/mysqld/mysqld.sock

production:
  adapter: mysql2
  encoding: utf8
  reconnect: false
  database: vn_trans
  pool: 5
  username: vn_trans
  password: 
  socket: /var/run/mysqld/mysqld.sock
