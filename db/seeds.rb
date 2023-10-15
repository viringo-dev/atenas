# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
if Rails.env.development?
  kevin = User.create({"name"=> "Kevin", "surname"=> "Levin", "username"=> "punkevin", "email"=> "kevin@gmail.com", "phone"=> "+51 987654321", "phone_code"=> 51, "gender"=> 0, "birthdate"=> "1999-01-01", "locale"=>"es", "country"=> "Peru", "city"=> "Lima", "deleted_at"=> nil, "password"=> "k234234234", "password_confirmation"=> "k234234234", "confirmed_at"=> Time.current})
  lucero = User.create({"name"=> "Lucero", "surname"=> "Lero", "username"=> "lucero", "email"=> "lucero@gmail.com", "phone"=> "+51 987654322", "phone_code"=> 51, "gender"=> 1, "birthdate"=> "1999-01-01", "locale"=>"es", "country"=> "Peru", "city"=> "Lima", "deleted_at"=> nil, "password"=> "k234234234", "password_confirmation"=> "k234234234", "confirmed_at"=> Time.current})
  Task.create({"name"=> "Factorización de números primos y teoréma de pitagoras (100 ejercicios)", "description"=> "Lorem ipsum dolor sit amet consectetur, adipisicing elit. Dicta ipsam atque maiores nesciunt vel alias veniam nisi, sit dolorem cupiditate quisquam illo cumque, iste quis, sequi adipisci a voluptates est.", "reward"=> 100, "currency"=> 0, "status"=> 0, "deadline"=> "2021-08-20 00:00:00", "user_id"=> kevin.id})
  Task.create({"name"=> "Tarea 2", "description"=> "Lorem ipsum dolor sit amet consectetur, adipisicing elit. Dicta ipsam atque maiores nesciunt vel alias veniam nisi, sit dolorem cupiditate quisquam illo cumque, iste quis, sequi adipisci a voluptates est.", "reward"=> 200, "currency"=> 0, "status"=> 0, "deadline"=> "2021-08-20 00:00:00", "user_id"=> lucero.id})
end
