# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Shikoba.Repo.insert!(%Shikoba.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Shikoba.Factory

_user_1 = insert(:user,
  email: "user_1@shikoba.com",
  role: :user
)

_admin = insert(:user,
  email: "admin@shikoba.com",
  role: :admin
)
