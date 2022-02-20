**PROJECT TITLE: PASSWORD MANAGER**
- Training in Linux and Git

**The branches:**
- mouse Automation

**Packages should be installed:**
- jq      -> JSON
- OpenSSL -> Encryption
- hashalot-> SHA256

**Saving the data as JSON (JQ utility):**
- To install use <code>sudo apt install jq</code> to install the package.
- To store the User data [ID, USER, FINGERPRINT] we use redirection
- To get the selected data we use grep
- To get the data only from the selected columns; <code>user_exits=$(echo $exits | jq '.USER')</code>
