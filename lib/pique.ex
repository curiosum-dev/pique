defmodule Pique do
  @moduledoc """
  Main Pique application. Starts the `gen_smtp_server` with the
  default configuration. If the configuration states
  that `auth` is `true` then the application will not start unless
  it is configured with `sessionoptions` that specify a cert and key
  file as well as listening on `:ssl` vs. `:tcp`.

  Example SSL configuration:
  ```
  config :pique,
    auth: true,
    smtp_opts: [
      port: 4646,
      protocol: :ssl,
      sessionoptions: [
        certfile: "foo",
        keyfile: "bar"
      ]
    ]
  ```
  """
  require Logger

  use Application

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    smtp_options = Application.get_env(:pique, :smtp_opts, [])
    Logger.info("Starting SMTP server on #{Keyword.get(smtp_options, :port, 2525)} port")

    children = [
      %{
        id: :gen_smtp_server,
        start:
          {:gen_smtp_server, :start,
           [
             Application.get_env(:pique, :callback, Pique.Smtp),
             smtp_options
           ]}
      }
    ]

    opts = [strategy: :one_for_one, name: Pique.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
