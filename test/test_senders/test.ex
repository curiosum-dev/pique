defmodule Pique.TestSenders.TestFail do
  @behaviour Pique.Behaviours.Sender

  def send(state) do
    {:error, ~c"552 Failed to pass Sender", state}
  end
end

defmodule Pique.TestSenders.TestPass do
  @behaviour Pique.Behaviours.Sender

  def send(state) do
    {:ok, state[:body], state}
  end
end
