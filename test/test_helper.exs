Dynamo.under_test(Coleoid.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule Coleoid.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end
