---
name: manage-mcps
description: Use when the user wants to find, add, delete, or update MCP servers from mcpservers.org. Triggers on requests like "add an MCP server", "find me an MCP for...", "install MCP", "browse MCP servers", or any mention of mcpservers.org.
---

# MCP Server Manager

Browse, add, delete, and update MCP servers in `opencode.json` using [mcpservers.org](https://mcpservers.org) as the source.

## Workflow

### 1. Finding MCP servers

When the user asks for an MCP server, search mcpservers.org:

- Category browsing: `https://mcpservers.org/category/<category>` (development, productivity, database, search, web-scraping, file-system, version-control, communication, cloud-service, etc.)
- Topic guides: `https://mcpservers.org/topics` (browser-automation-mcp, web-scraping-mcp, rag-mcp, coding-agent-mcp, etc.)
- Direct search: `https://mcpservers.org/search?query=<term>`
- Full listing: `https://mcpservers.org/all`

Fetch the relevant page, extract the top results with their names, descriptions, and links. Present a curated list to the user.

### 2. Getting server details

For each candidate server, fetch its detail page (linked from the listing). The detail page contains:
- The server's install command (usually `npx` or `docker`)
- Required environment variables / API keys
- Whether it is local or remote

### 3. Adding a server

Before adding, **always ask the user for approval** with:
- Server name and description
- The exact `mcp` config block to be added
- Any API keys or environment variables required

Once approved, add to the user's `opencode.json` (project-level `./opencode.json` or global `~/.config/opencode/opencode.json`) under the `mcp` key:

```json
{
  "mcp": {
    "server-name": {
      "type": "local",
      "command": ["npx", "-y", "@package/mcp-server"],
      "enabled": true,
      "environment": {
        "API_KEY": "{env:MY_API_KEY}"
      }
    }
  }
}
```

For remote servers:
```json
{
  "mcp": {
    "server-name": {
      "type": "remote",
      "url": "https://mcp-endpoint.example.com",
      "enabled": true,
      "headers": {
        "Authorization": "Bearer {env:TOKEN}"
      }
    }
  }
}
```

### 4. Deleting a server

To remove a server, confirm with the user first, then remove the matching key from `mcp` in `opencode.json`.

### 5. Updating a server

To update, read the current config, show the user the current vs proposed values, get approval, then edit.

## Important notes

- Always use `"type": "local"` or `"type": "remote"` — the field is required.
- `command` must be an array of strings, never a single string.
- Use `{env:VAR}` interpolation for secrets, not `${VAR}`.
- After any config change, remind the user to **restart opencode** for changes to take effect.
- Validate the final JSON is well-formed before saving.
