defmodule ShikobaWeb.GraphQL.Accounts.UserSchema do
  @moduledoc """
  User GraphQL schema.
  """

  use Absinthe.Schema.Notation
  alias Shikoba.Accounts.User
  alias ShikobaWeb.GraphQL.Accounts.AccountsResolver
  alias ShikobaWeb.GraphQL.Helpers.ResolverHelper

  @desc "User roles"
  enum :user_role_enum do
    value :user, description: "User"
    value :admin, description: "Admin"
  end

  @desc "An user"
  object :user do
    meta :authorize, :all

    field :id, :integer
    field :email, :string
    field :verified, :boolean
    field :role, :user_role_enum
  end

  object :user_queries do
    @desc "Gets a list of all users"
    field :list_users, list_of(:user) do
      middleware Rajska.QueryAuthorization, permit: :admin
      resolve &AccountsResolver.list_users/2
    end

    @desc "Gets a user by id"
    field :get_user, :user do
      arg :id, non_null(:integer)

      middleware Rajska.QueryAuthorization, [permit: :user, scope: User]
      resolve &AccountsResolver.get_user/2
    end

    @desc "Gets the user associated with the given token"
    field :current_user, :user do
      middleware Rajska.QueryAuthorization, permit: :all
      resolve &AccountsResolver.get_current_user/2
    end
  end

  object :user_mutations do
    @desc "Creates an unverified user with unconfirmed email"
    field :create_unverified_user, :string do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      middleware Rajska.QueryAuthorization, permit: :all
      middleware Rajska.RateLimiter,
        scale_ms: ResolverHelper.rate_limiter_scale_ms(),
        limit: ResolverHelper.rate_limiter_limit()

      resolve &AccountsResolver.create_unverified_user/2
    end

    @desc "Sends an email for user email verification"
    field :send_verification_email, :user do

      middleware Rajska.QueryAuthorization, [permit: :user, scope: false]
      resolve &AccountsResolver.send_verification_email/2
    end

    @desc "Logins an user"
    field :login_user, :string do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      middleware Rajska.QueryAuthorization, permit: :all
      middleware Rajska.RateLimiter,
        scale_ms: ResolverHelper.rate_limiter_scale_ms(),
        limit: ResolverHelper.rate_limiter_limit()
      middleware Rajska.RateLimiter,
        keys: :email,
        scale_ms: ResolverHelper.rate_limiter_scale_ms(),
        limit: ResolverHelper.rate_limiter_limit()

      resolve &AccountsResolver.login_user/2
    end

    @desc "Sends an email to reset password"
    field :request_reset_password, :string do
      arg :email, non_null(:string)

      middleware Rajska.QueryAuthorization, permit: :all
      middleware Rajska.RateLimiter,
        scale_ms: ResolverHelper.rate_limiter_scale_ms(),
        limit: ResolverHelper.rate_limiter_limit()
      middleware Rajska.RateLimiter,
        keys: :email,
        scale_ms: ResolverHelper.rate_limiter_scale_ms(),
        limit: ResolverHelper.rate_limiter_limit()

      resolve &AccountsResolver.request_reset_password/2
    end

    @desc "Resets the user's password"
    field :reset_password, :string do
      arg :token, non_null(:string)
      arg :password, non_null(:string)

      middleware Rajska.QueryAuthorization, permit: :all
      resolve &AccountsResolver.reset_password/2
    end
  end
end
