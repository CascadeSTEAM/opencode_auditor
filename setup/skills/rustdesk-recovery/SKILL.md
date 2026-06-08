---
name: vault-rustdesk-recovery
description: Locate, inspect, and recover RustDesk remote-desktop configuration — config paths, peer extraction, and password decryption using XSalsa20-Poly1305.
---

# RustDesk Recovery Skill

Load this skill when auditing a system with RustDesk installed. All operations are read-only.

> **Version caveat:** The decryption method below (zero nonce, machine-UUID key) targets RustDesk **1.4.x** using libsodium's `SecretBox` (XSalsa20-Poly1305). Future versions may change the scheme — verify the current RustDesk source before relying on it.

## 1. Locate Config Files

RustDesk stores config in two possible locations depending on the install method:

| Install Method | Config Root |
|---|---|
| Native (apt, rpm, .deb) | `~/.config/rustdesk/` |
| Flatpak | `~/.var/app/com.rustdesk.RustDesk/config/rustdesk/` |

### Key files

| File | Purpose |
|---|---|
| `RustDesk.toml` | Local machine identity, keys, permanent password |
| `RustDesk2.toml` | Rendezvous server, network settings, unlock PIN |
| `RustDesk_local.toml` | UI state, last-connected ID, favorites list |
| `RustDesk_ab` | Address book (encrypted binary) |
| `peers/<ID>.toml` | Per-peer connection config (password, view settings, host info) |

### Log files

```bash
ls ~/.local/share/logs/RustDesk/
```

## 2. Extract Peer Information

```bash
# List all saved peer IDs and hostnames
for f in ~/.config/rustdesk/peers/*.toml ~/.var/app/com.rustdesk.RustDesk/config/rustdesk/peers/*.toml; do
  [ -f "$f" ] || continue
  id=$(basename "$f" .toml)
  hostname=$(grep -oP '(?<=hostname = ")[^"]*' "$f" 2>/dev/null || echo "unknown")
  username=$(grep -oP '(?<=username = ")[^"]*' "$f" 2>/dev/null || echo "unknown")
  platform=$(grep -oP '(?<=platform = ")[^"]*' "$f" 2>/dev/null || echo "unknown")
  echo "ID=$id  hostname=$hostname  user=$username  platform=$platform"
done
```

## 3. Get Local Machine Identity

```bash
# RustDesk ID (9-digit number shown in the UI)
/usr/share/rustdesk/rustdesk --get-id 2>/dev/null || rustdesk --get-id 2>/dev/null

# Machine UUID (used as encryption key)
cat /etc/machine-id
```

## 4. Decrypt Peer Passwords

RustDesk 1.4.x encrypts stored passwords with XSalsa20-Poly1305 using:
- **Key:** Machine UUID string, padded/null-truncated to 32 bytes
- **Nonce:** 24 zero bytes (static — a known weakness)
- **Format:** `00` + base64(nonce(24) + ciphertext)

### Decryption with Python (requires `pynacl`)

```bash
pip install pynacl 2>/dev/null || pip3 install pynacl
```

```python
import base64, tomllib
from nacl.secret import SecretBox

uuid = open("/etc/machine-id").read().strip()
key = uuid.encode().ljust(32, b'\x00')[:32]
box = SecretBox(key)
nonce = b'\x00' * 24

peer_id = "516431705"  # <-- replace with target peer ID
with open(f"peers/{peer_id}.toml", "rb") as f:
    cfg = tomllib.load(f)

stored = bytes(cfg["password"]).decode("ascii")
ver, payload = stored[:2], stored[2:]
padded = payload + "=" * (4 - len(payload) % 4)
raw = base64.b64decode(padded)

plaintext = box.decrypt(raw, nonce)
print(f"Decrypted password bytes: {plaintext.hex()}")
print(f"Printable: {bytes(b for b in plaintext if 32 <= b < 127).decode()}")
```

> **Note:** Passwords may decrypt to binary (hashed/token) rather than plaintext strings — this is normal for connections using one-time passwords.

### Decrypt the Local Machine's Own Permanent Password

The same method applies to `RustDesk.toml`'s `password` field:

```python
import base64, tomllib
from nacl.secret import SecretBox

uuid = open("/etc/machine-id").read().strip()
key = uuid.encode().ljust(32, b'\x00')[:32]
box = SecretBox(key)
nonce = b'\x00' * 24

with open("RustDesk.toml", "rb") as f:
    cfg = tomllib.load(f)

enc = cfg["password"]
ver, payload = enc[:2], enc[2:]
padded = payload + "=" * (4 - len(payload) % 4)
raw = base64.b64decode(padded)

plain = box.decrypt(raw, nonce)
print(f"Permanent password: {plain.decode(errors='replace')}")
```

## 5. Security Inventory Notes

During an audit, flag RustDesk as a remote-access tool and note:
- Whether it uses public rendezvous servers (`rs-*.rustdesk.com`) or a self-hosted server
- Whether a permanent password is set (`verification-method` in `RustDesk2.toml`)
- How many peers are saved (exposure surface)
- Whether the address book (`RustDesk_ab`) contains sensitive targets

Corresponding SOC2 controls: CC6.1 (access control), CC6.8 (malware protection — remote tools as vector), CC7.2 (monitoring).
