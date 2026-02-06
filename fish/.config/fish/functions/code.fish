function code \
    --description "Open files in a VSCode remote server if available"

    if set -q DEBUG
        set -x
    end

    # If VSCODE_IPC_HOOK_CLI is already set and the socket exists, use the existing code command
    if set -q VSCODE_IPC_HOOK_CLI; and test -S "$VSCODE_IPC_HOOK_CLI"
        command code $argv
        return
    end

    # If code is already in PATH, use it directly
    if type -q code
        command code $argv
        return
    end

    echo "Finding VSCode server..."

    # Find latest VSCode server node binary (sorted by modification time, newest first)
    set -l node (find ~/.vscode-server/cli/servers/*/server -name "node" -type f 2>/dev/null | while read -l f; stat -f "%m %N" "$f" 2>/dev/null; end | sort -rn | head -n 1 | cut -d' ' -f2-)

    if test -z "$node" -o ! -x "$node"
        echo "VSCode server not found" >&2
        return 1
    end

    # Locate CLI binary
    set -l cli (string replace -r '/node$' '/bin/remote-cli/code' "$node")

    if test ! -x "$cli"
        echo "CLI not found: $cli" >&2
        return 1
    end

    # Find running server PID (combines ps, grep for node path, grep for start-server)
    set -l pid (ps ux | awk -v n="$node" '$0 ~ n && /start-server/ {print $2; exit}')

    if test -z "$pid"
        echo "No running server for: $node" >&2
        return 1
    end

    # Extract IPC socket path from lsof output
    set -l sock (lsof -p $pid 2>/dev/null | awk '/unix.*vscode-ipc.*\.sock/ {print $8; exit}')

    if test -z "$sock" -o ! -S "$sock"
        echo "Invalid socket for PID $pid. Socket isn't created without an integrated VSCode terminal running." >&2
        return 1
    end

    # Set IPC socket for this terminal session and execute CLI
    set -gx VSCODE_IPC_HOOK_CLI $sock
    command code $argv
end
