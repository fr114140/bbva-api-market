require "spec_helper"

RSpec.describe Bbva::Api::Market do
  it "has a version number" do
    expect(Bbva::Api::Market::VERSION).not_to be nil
  end
end
