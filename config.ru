require 'isolate/now'
$LOAD_PATH.unshift("./lib")
require 'gust_application'

use Rack::Static, urls: %w(/css), root: "public"
run GustApplication.new
