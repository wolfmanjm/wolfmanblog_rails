require 'spec_helper'

describe "Logins" do
  describe "GET /login" do
    it "should be able to login" do
      get "/login"
      response.status.should == 200
    end
  end
end
