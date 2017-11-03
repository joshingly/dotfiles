require "rubygems"
require "awesome_print"

AwesomePrint.pry!

def no_pg_scan
  execute_sql "set enable_seqscan = off"
end

def execute_sql(str)
  ActiveRecord::Base.connection.execute(str)
end
