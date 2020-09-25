# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Vertico.Repo.insert!(%Vertico.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Vertico.Factory

_user_1 = insert(:user,
  email: "user_1@vertico.com",
  role: :user
)

_admin = insert(:user,
  email: "admin@vertico.com",
  role: :admin
)
