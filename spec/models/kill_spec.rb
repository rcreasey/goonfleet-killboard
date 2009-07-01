require File.dirname(__FILE__) + '/../spec_helper'

describe Kill, "when new" do
  it "should parse a killmail correctly" do
    kill = Kill(:kill)
    puts Kill.inspect
  end
end