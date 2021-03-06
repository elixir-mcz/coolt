defmodule Coolt.Guardian do
  use Guardian, otp_app: :coolt

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(claims) do
    {:ok, find_me_a_resource(claims["sub"])}
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end

  defp find_me_a_resource(sub) do
    sub
  end
end