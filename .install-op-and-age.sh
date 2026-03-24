#!/bin/bash
set -eufo pipefail

AGE_KEY_PATH="${HOME}/.config/chezmoi/age-key.txt"
AGE_KEY_DIR="$(dirname "$AGE_KEY_PATH")"
ONEPASSWORD_ITEM="op://Private/chezmoi-age/private"
OP_BIN=""

is_ci() {
    [ -n "${CI:-}" ]
}

run_privileged() {
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
        return 0
    fi

    if command -v sudo >/dev/null 2>&1; then
        sudo "$@"
        return 0
    fi

    echo "Error: need root privileges to install 1Password CLI, but sudo is not available." >&2
    exit 1
}

op_cmd() {
    if [ -n "$OP_BIN" ]; then
        "$OP_BIN" "$@"
    else
        op "$@"
    fi
}

age_key_exists() {
    [ -s "$AGE_KEY_PATH" ] && grep -Fq 'AGE-SECRET-KEY-' "$AGE_KEY_PATH"
}

load_os_release() {
    [ -r /etc/os-release ] || return 1
    # shellcheck disable=SC1091
    . /etc/os-release
}

has_command() {
    command -v "$1" >/dev/null 2>&1
}

is_debian_like() {
    if has_command apt-get; then
        return 0
    fi

    load_os_release || return 1
    case "${ID:-}" in
        ubuntu|debian|linuxmint|pop)
            return 0
            ;;
        *)
            case "${ID_LIKE:-}" in
                *debian*)
                    return 0
                    ;;
            esac
            return 1
            ;;
    esac
}

is_fedora_like() {
    if has_command dnf; then
        return 0
    fi

    load_os_release || return 1
    case "${ID:-}" in
        fedora|rhel|centos|rocky|almalinux)
            return 0
            ;;
        *)
            case "${ID_LIKE:-}" in
                *rhel*|*fedora*)
                    return 0
                    ;;
            esac
            return 1
            ;;
    esac
}

is_arch_like() {
    if has_command pacman; then
        return 0
    fi

    load_os_release || return 1
    case "${ID:-}" in
        arch|manjaro|endeavouros)
            return 0
            ;;
        *)
            case "${ID_LIKE:-}" in
                *arch*)
                    return 0
                    ;;
            esac
            return 1
            ;;
    esac
}

ensure_op_installed_macos() {
    if command -v brew >/dev/null 2>&1; then
        brew install 1password-cli
        OP_BIN="$(command -v op || true)"
        return 0
    fi

    if [ -x /opt/homebrew/bin/brew ]; then
        /opt/homebrew/bin/brew install 1password-cli
        export PATH="/opt/homebrew/bin:$PATH"
        OP_BIN="/opt/homebrew/bin/op"
        return 0
    fi

    if [ -x /usr/local/bin/brew ]; then
        /usr/local/bin/brew install 1password-cli
        export PATH="/usr/local/bin:$PATH"
        OP_BIN="/usr/local/bin/op"
        return 0
    fi

    echo "Error: 1Password CLI is required before chezmoi can hydrate the age key." >&2
    echo "Install Homebrew first, then rerun chezmoi apply:" >&2
    echo "  https://brew.sh" >&2
    exit 1
}

ensure_apt_prerequisites() {
    run_privileged apt-get update -y
    run_privileged apt-get install -y --no-install-recommends curl gnupg
}

ensure_onepassword_apt_repo() {
    local keyring="/usr/share/keyrings/1password-archive-keyring.gpg"
    local list_file="/etc/apt/sources.list.d/1password.list"

    if [ ! -f "$list_file" ]; then
        ensure_apt_prerequisites
        curl --proto '=https' --tlsv1.2 -fsSL https://downloads.1password.com/linux/keys/1password.asc \
            | run_privileged gpg --dearmor --output "$keyring"
        echo "deb [arch=$(dpkg --print-architecture) signed-by=$keyring] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" \
            | run_privileged tee "$list_file" >/dev/null
    fi
}

ensure_op_installed_debian() {
    ensure_onepassword_apt_repo
    run_privileged apt-get update -y
    run_privileged apt-get install -y --no-install-recommends 1password-cli
}

ensure_onepassword_rpm_repo() {
    local repo_file="/etc/yum.repos.d/1password.repo"

    if [ ! -f "$repo_file" ]; then
        run_privileged rpm --import https://downloads.1password.com/linux/keys/1password.asc
        # shellcheck disable=SC2016
        run_privileged sh -c 'printf "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://downloads.1password.com/linux/keys/1password.asc\n" > /etc/yum.repos.d/1password.repo'
    fi
}

ensure_op_installed_fedora() {
    ensure_onepassword_rpm_repo
    run_privileged dnf install -y 1password-cli
}

ensure_op_installed_arch() {
    run_privileged pacman -S --noconfirm --needed 1password-cli
}

ensure_op_installed() {
    if command -v op >/dev/null 2>&1; then
        OP_BIN="$(command -v op)"
        return 0
    fi

    case "$(uname -s)" in
        Darwin)
            ensure_op_installed_macos
            ;;
        Linux)
            if is_debian_like; then
                ensure_op_installed_debian
            elif is_fedora_like; then
                ensure_op_installed_fedora
            elif is_arch_like; then
                ensure_op_installed_arch
            else
                echo "Error: unsupported Linux distribution for automatic 1Password CLI bootstrap." >&2
                echo "Install 1password-cli manually, then rerun chezmoi apply." >&2
                exit 1
            fi
            ;;
        *)
            echo "Error: unsupported operating system for automatic 1Password CLI bootstrap." >&2
            exit 1
            ;;
    esac

    if ! command -v op >/dev/null 2>&1; then
        if [ -n "$OP_BIN" ] && [ -x "$OP_BIN" ]; then
            return 0
        fi

        echo "Error: 1Password CLI installation did not make 'op' available on PATH." >&2
        exit 1
    fi

    OP_BIN="$(command -v op)"
}

write_age_key() {
    local tmp

    mkdir -p "$AGE_KEY_DIR"
    tmp="$(mktemp "$AGE_KEY_DIR/age-key.txt.XXXXXX")"
    trap 'rm -f "$tmp"' EXIT

    if ! op_cmd read "$ONEPASSWORD_ITEM" > "$tmp"; then
        echo "Error: failed to read age key from 1Password." >&2
        echo "Ensure 1Password CLI is installed, unlocked, and authenticated, then rerun chezmoi apply." >&2
        echo "If this is a new machine, you may need to add or sign in to your 1Password account in the CLI first." >&2
        exit 1
    fi

    if ! grep -Fq 'AGE-SECRET-KEY-' "$tmp"; then
        echo "Error: 1Password item did not contain a valid age secret key." >&2
        echo "Check $ONEPASSWORD_ITEM and rerun chezmoi apply." >&2
        exit 1
    fi

    chmod 600 "$tmp"
    mv "$tmp" "$AGE_KEY_PATH"
    trap - EXIT
}

main() {
    if is_ci; then
        exit 0
    fi

    if age_key_exists; then
        exit 0
    fi

    ensure_op_installed
    write_age_key
}

main "$@"
