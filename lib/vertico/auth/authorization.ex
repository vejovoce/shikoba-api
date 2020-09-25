defmodule Vertico.Auth.Authorization do
  @moduledoc false

  use Rajska,
    valid_roles: [:user, :admin],
    super_role: :admin,
    default_rule: :default
end
