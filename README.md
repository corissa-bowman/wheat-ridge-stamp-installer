# Wheat Ridge Building Approval Stamp

A dynamic Adobe Acrobat stamp for Wheat Ridge building approvals. Once installed, the stamp automatically fills in your name, today's date, and the current time whenever you place it on a PDF.

## Download

Click the green **Code** button above → **Download ZIP**, then unzip the folder.

## Install

### Mac

1. Open the unzipped folder.
2. Double-click **`Mac Install Stamp.command`**.
3. Follow the prompts. The installer will close Acrobat, copy the stamp into the right folder, and tell you when it's done.

#### If macOS blocks it ("Apple could not verify... is free of malware")

This happens because the script is not code-signed. You need to do this once per download:

**Option A — System Settings (no Terminal):**

1. Click **Done** on the warning dialog (do **not** click Move to Trash).
2. Open **System Settings → Privacy & Security**.
3. Scroll down to the **Security** section. You'll see a message that the script was blocked.
4. Click **Open Anyway** and authenticate with Touch ID or your password.
5. Double-click `Mac Install Stamp.command` again. This time confirm by clicking **Open** in the dialog.

**Option B — Terminal one-liner:**

1. Open **Terminal** (Applications → Utilities → Terminal, or press `Cmd+Space` and type "Terminal").
2. Paste the command below and press Enter (drag the file into Terminal to fill in the path automatically):

   ```bash
   xattr -d com.apple.quarantine "/path/to/Mac Install Stamp.command"
   ```

3. Double-click the installer normally — it'll run without any warning.

### Windows

1. Open the unzipped folder.
2. Double-click **`Windows Install Stamp.bat`**.
3. If SmartScreen warns you, click **More info** → **Run anyway**.
4. Follow the prompts.

## After installing

1. Open Adobe Acrobat or Reader.
2. Set your name so the stamp can fill it in:
   - **Mac:** Acrobat → Settings → Identity (`Cmd` + `,`)
   - **Windows:** Edit → Preferences → Identity (`Ctrl` + `K`)
3. Open any PDF, choose the **Stamp** tool, and place **Wheat Ridge Building Approval Stamp**.

If the stamp doesn't show up in the menu, fully quit Acrobat and reopen it — Acrobat only loads stamps at startup.

## Files in this repo

| File | Purpose |
| --- | --- |
| `Mac Install Stamp.command` | Mac installer (double-click) |
| `Windows Install Stamp.bat` | Windows installer (double-click) |
| `Wheat Ridge Building Approval Stamp.pdf` | The stamp itself |
| `Stamp_Installation_Guide.docx` | Full manual install guide and troubleshooting |

For detailed troubleshooting, see the installation guide.
