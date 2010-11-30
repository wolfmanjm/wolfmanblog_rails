require 'spec_helper'

describe "Logins" do
  describe "GET /login" do
    it "should be able to login" do
      get "/login"
      p response.body
    end
  end
end
