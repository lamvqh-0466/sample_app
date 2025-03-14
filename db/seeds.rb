# 20.times do |n|
#   name  = "Example User #{n + 1}"
#   email = "example#{n+1}@railstutorial.org"
#   password = "password"
#   User.create!(name:  name, email: email, password: password, password_confirmation: password,activated: true)
# end
users = User.all
user = users.first
following = users[2..20]
followers = users[3..15]
following.each{|followed| user.follow(followed)}
followers.each{|follower| follower.follow(user)}
