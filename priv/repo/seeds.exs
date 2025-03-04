# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DailyTalk.Repo.insert!(%DailyTalk.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Faker.start()

alias DailyTalk.Chat.Room
alias DailyTalk.Chat
alias DailyTalk.Accounts
alias DailyTalk.Repo

Repo.insert!(%Room{name: "weekend-plans", description: "Let's plan for the weekend!"})
Repo.insert!(%Room{name: "sre-team", description: "The SRE team's channel"})

for _n <- 1..10 do
  name = Faker.Person.first_name()
  email = "#{String.downcase(name)}@streamchat.io"
  Accounts.register_user(%{name: name, email: email, password: "passw0rd!passw0rd!"})
end

for _n <- 1..100 do
  Chat.create_message(%{
    content: Faker.Lorem.sentence(),
    room_id: Enum.random([1, 2]),
    sender_id: Enum.random([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
  })
end
