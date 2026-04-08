# simple_user_manager.sh — Linux User Management Tool

A simple, beginner-friendly Bash script for managing users on Linux.

---

## How to Run

```bash
sudo bash simple_user_manager.sh
```

> You need `sudo` because managing users requires admin (root) access.

---

## What It Can Do

| Option | What it does |
|---|---|
| 1. Create a new user | Adds a new user account and sets a password |
| 2. Delete a user | Removes a user and their home folder |
| 3. List all users | Shows all real user accounts (UID ≥ 1000), aligned in columns |
| 4. Change a password | Lets you reset any user's password |
| 5. Show user info | Displays UID, groups, and last login for a user |
| 6. Group management | Opens the group submenu (see below) |
| 7. Exit | Closes the script |

### Group Management Submenu

| Option | What it does |
|---|---|
| 1. Create a group | Creates a new group with `groupadd` |
| 2. Delete a group | Removes a group with `groupdel` |
| 3. Add user to group | Appends a user to an existing group |
| 4. Remove user from group | Removes a user from a group with `gpasswd -d` |
| 5. List all groups | Shows all real groups (GID ≥ 1000), aligned in columns |
| 6. Back to main menu | Returns to the main menu |

---

## How It Works — Key Commands Explained

### `useradd -m username`
Creates a new user. The `-m` flag automatically creates a home folder
for them at `/home/username`.

### `userdel -r username`
Deletes a user. The `-r` flag also removes their home folder and files.

### `passwd username`
Sets or changes the password for a user. It will prompt you to type it twice.

### `id username`
Shows a user's ID number (UID), group ID (GID), and all groups they belong to.

### `usermod -aG groupname username`
Adds a user to a group. The `-a` means "append" (don't remove from other
groups) and `-G` specifies the group name.

### `groupadd groupname`
Creates a new group on the system.

### `groupdel groupname`
Deletes a group. Users who were members are not deleted — they just lose membership.

### `gpasswd -d username groupname`
Removes a user from a group.

### `getent group groupname`
Looks up a group by name in `/etc/group`. Used internally to check if a group exists.

### `printf "%-20s %-6s %s\n"`
Used to print output in aligned columns. Breaking it down:

- **`%s`** — print a string
- **`%20s`** — print a string in a field **20 chars wide**, right-aligned
- **`%-20s`** — the `-` flips it to **left-aligned**, padding with spaces on the right
- **`\n`** — newline at the end

So in this script:
```
%-20s  → Username/Group column, 20 chars wide, left-aligned
%-6s   → UID/GID column, 6 chars wide, left-aligned
%s     → Home/Members column, no fixed width (last column, no padding needed)
```

Example output:
```
deepak               1000   /home/deepak
alice                1001   /home/alice
```

The width number sets the **minimum field width**. Every value gets padded to that width, so all columns line up regardless of how long the value is.

---

## Understanding Users in Linux

- Every user has a **UID** (User ID). Regular users start at UID 1000.
- Users below UID 1000 are system accounts (used by services, not people).
- All user info is stored in the file `/etc/passwd`.
- Passwords are stored (encrypted) in `/etc/shadow`.
- Groups are stored in `/etc/group`.
- Every user also has a **primary group** (same name as the user by default) and can belong to multiple **secondary groups**.

---

## Example Walkthrough

```
 LINUX USER MANAGEMENT TOOL
----------------------------------------
 1. Create a new user
 2. Delete a user
 ...
 Enter your choice (1-7): 1

  CREATE A NEW USER
----------------------------------------
Enter the new username: alice
User 'alice' created.
Now set a password for 'alice':
New password:
Retype new password:
passwd: password updated successfully

Done! User 'alice' has been created.
```

---

## Common Issues

**"Please run this script as root"**
Add `sudo` before the command: `sudo bash simple_user_manager.sh`

**"User does not exist"**
Check your spelling. Use option 3 (List all users) to see who exists.

**"Group does not exist"**
The group must already exist before adding a user to it. Use option 6 → List all groups to see what's available, or create one first via option 6 → Create a group.