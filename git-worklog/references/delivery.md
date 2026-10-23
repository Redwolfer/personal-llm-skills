# Save and deliver the report

Honor an explicit output path. Otherwise prefer the user's Desktop when the host has access to it.

## Choose a location

| Host capability | Delivery |
|---|---|
| Access to the user's filesystem | Save to the requested path or Desktop. |
| A session sandbox with file output | Save in the session's output directory and present a download or attachment. |
| Text output only | Return CSV or a short Markdown table with import guidance. |

For Desktop output, resolve `~/Desktop/` on macOS or Linux and `%USERPROFILE%\Desktop\` on Windows. If that location does not exist, ask once for the actual Desktop path.

Use the host's available output locations and permissions. When a session cannot reach the real Desktop, say so and tell the user to move the download there. Use the file-presentation tool when the host provides one, including after saving a local copy.

## Filename

Use `worklog_<project>_<start>_<end>.xlsx`, with dates in `YYYY-MM-DD` format. Substitute the resolved Project value, for example `worklog_PMB_2026-08-01_2026-08-22.xlsx`.

For multiple distinct projects, join their labels, for example `worklog_PMB-Internal_2026-08-01_2026-08-22.xlsx`. When a label is too generic to distinguish repositories, append the relevant repository basename. Use the `.csv` extension for CSV output.

## Present the draft

Reply in Bahasa Indonesia with the path, download link, or attachment. Include a brief reminder to review the draft before submission, especially Type and Man/Hour. The task summaries reflect the assistant's interpretation of the diff, and the hours are estimates.

For text output, include the CSV or table and tell the user to import it into Excel or Google Sheets. Keep the reply direct and omit greetings, praise, and sign-offs.
