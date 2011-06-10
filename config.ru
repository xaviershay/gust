require 'isolate/now'
$LOAD_PATH.unshift("./lib")
require 'gust_application'
run GustApplication.new
