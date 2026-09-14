require "rails_helper"

RSpec.describe "signup and sign in", type: :request do
  it "creates an account and opens search" do
    post user_registration_path, params: {
      user: {
        email: "neha@mail.test",
        password: "password",
        password_confirmation: "password"
      }
    }

    expect(response).to redirect_to(trips_path)
    follow_redirect!
    expect(response.body).to include("log out")
    expect(User.find_by(email: "neha@mail.test")).to be_present
  end

  it "lets a rider sign in with email" do
    create(:user, email: "arun@mail.test", password: "password")

    post user_session_path, params: {
      user: { email: "arun@mail.test", password: "password" }
    }

    expect(response).to redirect_to(trips_path)

    get bookings_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("My bookings")
  end

  it "asks for login before showing bookings" do
    get bookings_path

    expect(response).to redirect_to(new_user_session_path)
  end
end
