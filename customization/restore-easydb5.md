How to add the data of an easydb 5 to an empty fylr

1. Surf to your fylr and add to the URL: /inspect/backup/

  example: http://fylr.example.com/inspect/backup/

2. Fill in the paragraph `Create backup` (via API, not via database) there. Ue URL and login of an easydb 5. Make sure `Oauth2` is not selected.

3. Fill in the paragraph `Restore backup` (via API, not via database). This time with URL and login of fylr.

When in doubt about the form field "File Mode":
* "Remote leave" does not copy asset files but uses the easydb-URLs to display assets in fylr.
* "Client Copy" copies asset files from easydb server to fylr via your browser.
* "Server Copy" copies asset files from easydb server to fylr without using your browser.

