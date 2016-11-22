require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../../spec/support', __FILE__)
require 'yandex_kassa_form'

PASSWORD_GOOD    = 's<kY23653f,{9fcnshwq'
PASSWORD_INVALID = 'invalid pwd'
PASSWORD         = PASSWORD_GOOD
ERROR_MESSAGE    = 'message when errored'
BODY_FILE        = 'generic_body.txt'
TRUE_PROC        = Proc.new { [true] }

def load_file(filename)
  File.new(File.expand_path("../support/files/#{filename}", __FILE__)).read
end

def load_params(filename)
  YandexKassaForm::Request.parse(load_file(filename))
end

def request
  load_params(BODY_FILE).merge!(shopPassword: PASSWORD)
end
