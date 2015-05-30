require 'csv'

CSV.foreach('db/testcsv/users_unix.csv') do |row|
  User.create(email:row[1],
              password:row[2],
              password_confirmation:row[3],
              name:row[12],
              profile_image_path:row[13])
end

CSV.foreach('db/testcsv/follows.csv') do |row|
  Follow.create(from_user_id:row[1],
                to_user_id:row[2])
end

CSV.foreach('db/testcsv/categories.csv') do |row|
  Category.create(name:row[1])
end

CSV.foreach('db/testcsv/hobbies_unix.csv') do |row|
  Hobby.create(name:row[1],
               category_id:row[2],
               photo_url:row[3])
end

CSV.foreach('db/testcsv/hobbies_users.csv') do |row|
  HobbyUser.create(hobby_id:row[1],
                   user_id:row[2],
                   ranking:row[3])
end

CSV.foreach('db/testcsv/articles.csv') do |row|
  Article.create(title:row[1],
                 contents:row[3],
                 view_count:row[4],
                 point:row[5],
                 published_at:row[6],
                 user_id:row[7],
                 hobby_id:row[8])
end

CSV.foreach('db/testcsv/votes.csv') do |row|
  Vote.create(votable_id:row[1],
              votable_type:row[2],
              voter_id:row[3],
              voter_type:row[4],
              vote_flag:row[5],
              vote_scope:row[6],
              vote_weight:row[7])
end

CSV.foreach('db/testcsv/comments.csv') do |row|
  Comment.create(title:row[1],
                 comment:row[2],
                 commentable_id:row[3],
                 commentable_type:row[4],
                 user_id:row[5],
                 role:row[6])
end

CSV.foreach('db/testcsv/battles.csv') do |row|
  Battle.create(article1_id:row[1],
                 article2_id:row[2],
                 vote1_num:row[3],
                 vote2_num:row[4])
end
