# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Forum.Repo.insert!(%Forum.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Forum.Repo
alias Forum.Accounts.User

mock_data = [
  %User{name: "Arun Panta", email: "arun.panta@temus.com"},
  %User{name: "Bram Desoete", email: "bram.desoete@temus.com"},
  %User{name: "Hardeep Singh Arora", email: "hardeep.arora@temus.com"},
  %User{name: "Varsha Singh", email: "varsha.singh@temus.com"},
  %User{name: "Daryl Tan", email: "daryl.tan@temus.com"},
  %User{name: "John Ang", email: "john.ang@temus.com"},
  %User{name: "Shubham Gupta", email: "shubham.gupta@temus.com"},
  %User{name: "Cheong Wei Yih", email: "weiyih.cheong@temus.com"},
  %User{name: "Matt Johnson", email: "matt.johnson@temus.com"},
  %User{name: "Tan Kian How", email: "kianhow.tan@temus.com"}
]

Repo.delete_all(User)
Enum.each(mock_data, fn user ->
  Repo.insert!(user)
end)
