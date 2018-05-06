$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "microsoft"
require "minitest/autorun"
require "webmock/minitest"

WebMock.disable_net_connect!(allow_localhost: true)

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

