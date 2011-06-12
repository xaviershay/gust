require 'isolate/now'
$LOAD_PATH.unshift("./lib")
require 'gust_application'

use Rack::Static, urls: %w(/css /syntaxhighlighter), root: "public"
run GustApplication.new
