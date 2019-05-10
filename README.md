# Gatekeeper

Gatekeeper consists of two components, a Discord Bot and a Ruby on Rails web application.

## Bot

The bot currently contains two functionalities, a greeter and a role self-selection.  More
functionalities are planned (specifically, the functionality that requires Ruby on Rails :wink:).

### Greeter

The greeter function is just a simple tool to "greet" new users when they enter. The only command is
accessible by anyone with the `manage server` permission (including the Owner, and anyone with `administrator`).
Greetings are on a per-server basis.

#### Greeter Administration


```
+greet
```
will display the current greeting setup.


```
+greet here Hello this is your life now.
```
will set the greeting to "Hello this is your life now" and display it to new members in the current channel when they join.



```
+greet #a-specific-channel Hello this is your life now.
```
will set the greeting to "Hello this is your life now" and display it to new members #a-specific-channel when they join.


```
+greet private Hello this is your life now.
```
will set the greeting to "Hello this is your life now" and send it to new members in a direct message when they join.


```
+greet off
```
will turn off the greeting but keep the message saved for later.


```
+greet on
```
will turn on the greet after it has been off.


```
+greet delete
```
will delete the greeting.


### Role Self-Selection

The role selection functionality is a little more complicated than greeter.  It has a setup command to specify which roles
to allow in the self-selection process, and it has a a command for users to use to perform the self-selection activity.

#### Role Self-Selection Administration

Anyone with the `manage roles` permission on the server can access this functionality.


```
+roles list
```
A list of roles will be sent in a direct message for setup purposes.  The format will be Role Name followed by a large
integer (this is the `<role_id>`) followed by the label if the role has been previously setup.


```
+role add <label>:<role_id> [<label>:<role_id>...]
```

Multiple roles can be setup at a time so long as they already exist in Discord. the `<label>` is the simple phrase a user
can type to select that role (especially useful in cases were role names have complex lettering). The `<role_id>` can
be found by using the the `+roleslist` command.


```
+role rem <label> [<label>...]
```
If a role needs to be removed, simple remove it by it's label.  This does NOT delete the role from Discord.


```
+roles off
```
will turn off role self-selection but keep the settings saved for later.


```
+roles on
```
will turn on role self-selection after it has been off.


```
+roles delete
```
will delete the role self-selection settings entirely.  This does NOT delete anything on Discord.


```
+roles
```
will show a list of labelled roles only in the channel were the command is executed.  This is useful for users so they
can see the instructions for selecting roles they wish to have.

#### Role Self-Selection Use


```
+roles <label> [<label>...]
```
Users may select one more roles to apply to themselves by typing out the command with each label.

## Web App

_coming soon_
