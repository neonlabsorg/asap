# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# User.find_or_create_by(
#   email: "admin@example.com", 
#   displayname: "Administrator", 
#   username: "admin") if User.none?


# Create default users if they don't exist
default_users = [
  {
    email: "ahmed.gasanov@neonlabs.org",
    displayname: "Ahmed Gasanov",
    username: "ahmed.gasanov@neonlabs.org"
  },
  {
    email: "sergei.bondar@neonlabs.org",
    displayname: "Sergei Bondar",
    username: "sergei.bondar@neonlabs.org"
  },
  {
    email: "vitalii.bicov@neonlabs.org",
    displayname: "Vitalii Bicov",
    username: "vitalii.bicov@neonlabs.org"
  }
]

default_users.each do |user_attrs|
  User.find_or_create_by!(username: user_attrs[:username]) do |user|
    user.email = user_attrs[:email]
    user.displayname = user_attrs[:displayname]
  end
end

# Create sample alert if no alerts exist
Alert.find_or_create_by(
  title: "Sample Alert 1",
  asset: "Sample Asset 1",
  issue: "Sample Issue 1",
  severity: "High",
  active: true,
  last_detected_at: Time.now,
  last_closed_at: nil,
  last_closed_by: nil,
  remediation: "Sample Remediation",
  source: "Sample Source",
  cve_list: [],
  output: '
    {
      "key1": "value1",
      "key2": "value2",
      "key3": {
        "key1": value1
      }
    }
    Some additional text goes here.
    You can have as many lines as you need.
  ',
  nessus_plugin_id: "12345",
  dc: "Sample DC",
  assignee_id: nil
) if Alert.none?