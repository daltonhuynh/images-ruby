require 'spec_helper'
require 'images'

describe Images::Client do
  let(:client) { described_class.new('api_key', 'http://host') }

end
