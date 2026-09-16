require "rails_helper"

RSpec.describe "sidekiq dashboard", type: :request do
  it "does not let a rider open jobs" do
    create(:user, email: "rider@mail.test", password: "password")
    post user_session_path, params: { user: { email: "rider@mail.test", password: "password" } }

    get sidekiq_web_path

    expect(response).to have_http_status(:not_found)
    expect(response.body).to include("this page is not present")
  end

  it "lets an admin open jobs" do
    create(:user, :admin, email: "admin@mail.test", password: "password")
    post user_session_path, params: { user: { email: "admin@mail.test", password: "password" } }

    get sidekiq_web_path

    expect(response).to have_http_status(:ok)
  end
end

RSpec.describe "missing page", type: :request do
  it "says this page is not present for an unknown path" do
    create(:user, email: "rider@mail.test", password: "password")
    post user_session_path, params: { user: { email: "rider@mail.test", password: "password" } }

    get "/this-path-is-not-real"

    expect(response).to have_http_status(:not_found)
    expect(response.body).to include("this page is not present")
  end
end
