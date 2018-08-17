# Cobwebhook

Set of plugs that do authentication and payload processing for various services.

## API

Use as a part of Plug pipeline:

```
defmodule Pipeline do
  use Plug.Builder

  plug Cobwebhook.Slack, ["1cb606ad1ccf30f99f60c8bc1d0bfec9"]
  plug Webhook
end
```

Takes a list of valid secrets. On valid request, sets `conn.assigns.payload`
and `conn.assigns.secret` and forwards request to the next plug in the pipeline.
