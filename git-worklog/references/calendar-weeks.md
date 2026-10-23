# Calendar week grouping

Group rows by the ISO year and week of the commit's author date. Weeks run from Monday through Sunday. Continue the calendar sequence across month boundaries.

When a reporting range begins in the previous month, keep its first dates in their actual calendar week. A range beginning on 26 June keeps that week's group even when the report also covers July.

Use the ISO year as part of the group key so weeks at a year boundary remain distinct.

```python
from datetime import date


def week_label(d: date) -> str:
    iso_year, iso_week, _ = d.isocalendar()
    monday = date.fromisocalendar(iso_year, iso_week, 1)
    sunday = date.fromisocalendar(iso_year, iso_week, 7)
    return f"Week {iso_week} ({monday:%d %b} - {sunday:%d %b %Y})"
```

Sort rows chronologically. Before each new week group, insert a divider labeled with `week_label()`. In the workbook, merge that row across all 11 columns and use bold text with a light fill.
