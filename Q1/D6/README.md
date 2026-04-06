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
| 3. List all users | Shows all real user accounts on the system |
| 4. Change a password | Lets you reset any user's password |
| 5. Show user info | Displays UID, groups, and last login for a user |
| 6. Add user to a group | Adds a user to an existing group (e.g. `sudo`) |
| 7. Exit | Closes the script |

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

---

## Understanding Users in Linux

- Every user has a **UID** (User ID). Regular users start at UID 1000.
- Users below UID 1000 are system accounts (used by services, not people).
- All user info is stored in the file `/etc/passwd`.
- Passwords are stored (encrypted) in `/etc/shadow`.
- Groups are stored in `/etc/group`.

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
The group must already exist. Check with: `getent group groupname`