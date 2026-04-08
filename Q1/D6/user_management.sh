#!/bin/bash
# =============================================
# simple_user_manager.sh
# A beginner-friendly Linux user management tool
# Must be run as root: sudo bash simple_user_manager.sh
# =============================================

# ---------- Helper functions ----------

# Print a line of dashes for visual separation
print_line() {
    echo "----------------------------------------"
}

# Pause and wait for the user to press Enter
press_enter() {
    echo ""
    read -p "Press Enter to go back to the menu..."
}

# Check if the script is running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run this script as root: sudo bash simple_user_manager.sh"
        exit 1
    fi
}

# ---------- Menu options ----------

# 1. Create a new user
create_user() {
    print_line
    echo "  CREATE A NEW USER"
    print_line

    read -p "Enter the new username: " username

    # Check if user already exists
    if id "$username" &>/dev/null; then
        echo "User '$username' already exists!"
        press_enter
        return
    fi

    # Create the user with a home directory
    useradd -m "$username"
    echo "User '$username' created."

    # Set a password for the user
    echo "Now set a password for '$username':"
    passwd "$username"

    echo ""
    echo "Done! User '$username' has been created."
    press_enter
}

# 2. Delete a user
delete_user() {
    print_line
    echo "  DELETE A USER"
    print_line

    read -p "Enter the username to delete: " username

    # Check if user exists
    if ! id "$username" &>/dev/null; then
        echo "User '$username' does not exist!"
        press_enter
        return
    fi

    # Confirm before deleting
    read -p "Are you sure you want to delete '$username'? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        echo "Cancelled. No changes were made."
        press_enter
        return
    fi

    # Delete user and their home directory
    userdel -r "$username" 2>/dev/null
    echo "User '$username' has been deleted."
    press_enter
}

# 3. List all users
list_users() {
    print_line
    echo "  ALL USER ACCOUNTS"
    print_line

    printf "%-20s %-6s %s\n" "Username" "UID" "Home"
    print_line

    while IFS=: read -r username _ uid _ _ home _; do
        if [ "$uid" -ge 1000 ] && [ "$uid" -ne 65534 ]; then
            printf "%-20s %-6s %s\n" "$username" "$uid" "$home"
        fi
    done < /etc/passwd

    press_enter
}

# 4. Change a user's password
change_password() {
    print_line
    echo "  CHANGE A USER'S PASSWORD"
    print_line

    read -p "Enter the username: " username

    # Check if user exists
    if ! id "$username" &>/dev/null; then
        echo "User '$username' does not exist!"
        press_enter
        return
    fi

    passwd "$username"
    press_enter
}

# 5. Show info about a user
show_user_info() {
    print_line
    echo "  USER INFORMATION"
    print_line

    read -p "Enter the username: " username

    # Check if user exists
    if ! id "$username" &>/dev/null; then
        echo "User '$username' does not exist!"
        press_enter
        return
    fi

    echo ""
    echo "--- Basic Info ---"
    id "$username"

    echo ""
    echo "--- Password Status ---"
    passwd -S "$username"

    echo ""
    echo "--- Recent Logins ---"
    last "$username" | head -5

    press_enter
}

# ---------- Group management functions ----------

# 6a. Create a group
create_group() {
    print_line
    echo "  CREATE A NEW GROUP"
    print_line

    read -p "Enter the group name: " groupname

    if getent group "$groupname" &>/dev/null; then
        echo "Group '$groupname' already exists!"
        press_enter
        return
    fi

    groupadd "$groupname"
    echo "Group '$groupname' created."
    press_enter
}

# 6b. Delete a group
delete_group() {
    print_line
    echo "  DELETE A GROUP"
    print_line

    read -p "Enter the group name to delete: " groupname

    if ! getent group "$groupname" &>/dev/null; then
        echo "Group '$groupname' does not exist!"
        press_enter
        return
    fi

    read -p "Are you sure you want to delete '$groupname'? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        echo "Cancelled. No changes were made."
        press_enter
        return
    fi

    groupdel "$groupname"
    echo "Group '$groupname' has been deleted."
    press_enter
}

# 6c. Add a user to a group
add_user_to_group() {
    print_line
    echo "  ADD USER TO GROUP"
    print_line

    read -p "Enter the username: " username
    read -p "Enter the group name: " groupname

    if ! id "$username" &>/dev/null; then
        echo "User '$username' does not exist!"
        press_enter
        return
    fi

    if ! getent group "$groupname" &>/dev/null; then
        echo "Group '$groupname' does not exist!"
        press_enter
        return
    fi

    usermod -aG "$groupname" "$username"
    echo "User '$username' added to group '$groupname'."
    press_enter
}

# 6d. Remove a user from a group
remove_user_from_group() {
    print_line
    echo "  REMOVE USER FROM GROUP"
    print_line

    read -p "Enter the username: " username
    read -p "Enter the group name: " groupname

    if ! id "$username" &>/dev/null; then
        echo "User '$username' does not exist!"
        press_enter
        return
    fi

    if ! getent group "$groupname" &>/dev/null; then
        echo "Group '$groupname' does not exist!"
        press_enter
        return
    fi

    gpasswd -d "$username" "$groupname"
    press_enter
}

# 6e. List all groups
list_groups() {
    print_line
    echo "  ALL GROUPS"
    print_line

    printf "%-20s %-6s %s\n" "Group" "GID" "Members"
    print_line

    while IFS=: read -r groupname _ gid members; do
        if [ "$gid" -ge 1000 ] && [ "$gid" -ne 65534 ]; then
            printf "%-20s %-6s %s\n" "$groupname" "$gid" "$members"
        fi
    done < /etc/group

    press_enter
}

# 6. Group management submenu
group_menu() {
    while true; do
        clear
        print_line
        echo "   GROUP MANAGEMENT"
        print_line
        echo " 1. Create a group"
        echo " 2. Delete a group"
        echo " 3. Add user to group"
        echo " 4. Remove user from group"
        echo " 5. List all groups"
        echo " 6. Back to main menu"
        print_line
        read -p " Enter your choice (1-6): " gchoice

        case "$gchoice" in
            1) create_group ;;
            2) delete_group ;;
            3) add_user_to_group ;;
            4) remove_user_from_group ;;
            5) list_groups ;;
            6) return ;;
            *) echo "Invalid choice."; sleep 2 ;;
        esac
    done
}

# ---------- Main menu ----------

show_menu() {
    clear
    print_line
    echo "   LINUX USER MANAGEMENT TOOL"
    print_line
    echo " 1. Create a new user"
    echo " 2. Delete a user"
    echo " 3. List all users"
    echo " 4. Change a user's password"
    echo " 5. Show user info"
    echo " 6. Group management"
    echo " 7. Exit"
    print_line
    read -p " Enter your choice (1-7): " choice
}

# ---------- Main program ----------

check_root

while true; do
    show_menu

    case "$choice" in
        1) create_user ;;
        2) delete_user ;;
        3) list_users ;;
        4) change_password ;;
        5) show_user_info ;;
        6) group_menu ;;
        7) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid choice. Please enter a number from 1 to 7."; sleep 2 ;;
    esac
done