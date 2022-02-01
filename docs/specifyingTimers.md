# Timer Syntax

To define a Timer Event, first drag the Event onto your new process canvas.   Select the 'Change Type' spanner icon on the pop-up menu, and select Timer version of that from the menu.  To then specify the Timer Configuration, use the Properties Panel on the right of the screen.

Timer definitions can be specified in the properties panel as a literal value, or can be specified using a process variable substitution.  Timers can be specified using ISO 8601 syntax, or using more familiar Oracle syntax.

Under Timer, select the type of timer you want.  There are separate options for [ISO 8601](#ISO8601-Syntax) and [Oracle format Date and Interval](#Oracle-Syntax) specifications.

In addition, Flows for APEX Process Variables can also be used as substitution parameters so that you can use a Process Variable to define a Timer syntax component.  Valid substitutions and the required format and typing are listed below.

## ISO Syntax {#ISO8601-Syntax}

Under Timer Definition, use the ISO 8601 format for the required time or interval, as below.  A good overview to ISO 8601 date/time format strings can be [found on Wikipedia. (click here)](https://en.wikipedia.com/wiki/ISO_8601)

### ISO 8601 Date

Specify a specific date and time for the process to start.  Date/Time components are listed from broader to more specific, with date components separated by dash ('-') characters, time components separated by colon (':') characters, and an upper-case 'T' character  separating the date from the time components.  All components used must be zero-padded.
If only a Time component is provided, the event will be scheduled for the next time the specified time occurs.  So, for example, if the given string was `T14:00`, and the current time was 09:00, the event would be scheduled for 14:00 (2PM) today; if the time is after 14:00, the event will be scheduled for 14:00 (2PM) tomorrow.

- Some examples:

```
2007-04-05T14:30
2021-11-23T07:15:23
T14:30:15    represents the next occurring 14:00:15 today or tomorrow.
```

- Allowed Substitutions:  ISO Dates can be substituted with Flows for APEX Process Variables using the `&F4A$proc_var_name.` substitution syntax as follows:

  - Date-typed Process Variable.  The date-typed process variable must contain the date/time that the event should fire.
  - Varchar2-typed Process Variable.  The varchar2-typed process variable must contain a valid Oracle-date using a format mask of `YYYY-MM-DD HH24:MI:SS`.  The Time zone used will be that of the database server.

### ISO 8601 Duration / Period

Specifies a delay from the current time or the process to start, using an [ISO 8601 duration](https://en.wikipedia.com/wiki/ISO_8601#Durations) string.  This always starts with an upper-case 'P'.

- Some examples:

```
P3Y6M4DT12H30M5S" represents a duration of three years, six months, four days,
twelve hours, thirty minutes, and five seconds.
P3M               represents 3 months.
PT5M              represents 5 minutes.
PT30S             represents 30 seconds.
```

- Allowed Substitutions:  ISO Durations can be substituted with Flows for APEX Process Variables using the `&F4A$proc_var_name.` substitution syntax as follows:

  - Varchar2-typed Process Variable.  The varchar2-typed process variable must contain a valid ISO 8601 Duration / Period using a format mask of `P(yyY)(mmM)(ddD)T(hhH)(mmM)(ssS)`.  Each bracketed component is optional.

### ISO 8601 Repeating Duration / Cycle Timers

Specifies the date/time for an initial run and then defined intervals for repetition.  Repeating timers are newly supported in Flows for APEX from v21.2 onwards.  The Repeating Period uses a Repeat Specification followed by the Period Specification, above.
The Repeat Specification is of the form `Rnn/` where R is an upper-case 'R' character to denote a 'Repeat', 'nn' is the number of times the timer should fire, and the slash character ('/') is the separator between the Repeat specification and the Period specification.  If 'nn' is omitted or equals '-1', the timer will fire continuously until cancelled.

- Some examples:

```
R5/P5D          represents 5 events, starting in 5 Days and repeating every 5 days.
R10/P1H20M      represents 10 events, starting in 80 minutes and repeating every 80 minutes.
R/P20S          represents an unlimited number of events, repeating every 20 seconds.
R-1/P6H         represents an unlimited number of events, repeating every 6 hours.
```

- Allowed Substitutions:  ISO Durations can be substituted with Flows for APEX Process Variables using the `&F4A$proc_var_name.` substitution syntax as follows:

  - Varchar2-typed Process Variable.  The varchar2-typed process variable must contain a valid ISO 8601 Repeating Duration / Cycle Timer (as described above) using a format mask of `Rnn/P(yyY)(mmM)(ddD)T(hhH)(mmM)(ssS)`.  Each bracketed component is optional.

## Oracle-format Date and Interval Syntax. {#Oracle-Syntax}

From v22.1 onwards, you can also use the Oracle format Date and Interval specifications, and for Dates you can also specify the Format Mask.

For more information on Oracle date / time formats, please see the Oracle SQL Language Reference Manual.

### Oracle Dates

Oracle Dates can be specified as an Oracle-format date and an associated Oracle date format mask.

- Allowed Substitutions:  Oracle Dates can be substituted with Flows for APEX Process Variables using the `&F4A$proc_var_name.` substitution syntax as follows:

  - Date-typed Process Variable.  The date-typed process variable must contain the date/time that the event should fire.
  - Varchar2-typed Process Variable.  The varchar2-typed process variable must contain a valid Oracle-date using a format mask of `YYYY-MM-DD HH24:MI:SS`.  The Time zone used will be that of the database server.

### Oracle Duration

Oracle Durations are specified with two separate components - a Years-Months Interval and a Days-Seconds Interval.  Both must be supplied as a varchar2 string in the required format.  The Timer duration is the sum of both components.

- Interval Years to Months:   The Interval Years-to-Months component must be supplied in format `YY-MM`.
- Interval Days(3) to Seconds: The Interval Days-to-Seconds must be supplied in the format `DDD HH24:MI:SS`.
- Allowed Substitutions:  Each component of an Oracle Duration can optionally be substituted with a Flows for APEX Process Variables using the `&F4A$proc_var_name.` substitution syntax as follows:

  - For the Interval YM Component:   A varchar2-typed Process Variable containing a valid Oracle Interval YM using a format mask of `YY-MM`.
  - For the Interval DS Component:   A varchar2-typed Process Variable containing a valid Oracle Interval DS using a format mask of `DDD HH24:MI:SS`.

### Oracle Cycle Timer

Oracle Cycle Timers are specified as three separate components:

- Interval to First Firing: The Interval Days(3)-to-Seconds must be supplied in the format `DDD HH24:MI:SS`.
- Interval between Repeat Firings: The Interval Days-to-Seconds must be supplied in the format `DDD HH24:MI:SS`.
- Maximum Number of Runs:  The maximum number of times the timer will fire, in format `nnn`.  If omitted, the timer will continue to fire until cancelled.
- Allowed Substitutions:  Each component of an Oracle Cycle can optionally be substituted with a Flows for APEX Process Variables using the `&F4A$proc_var_name.` substitution syntax as follows:

  - For the Interval to First Firing:   A varchar2-typed Process Variable containing a valid Oracle Interval-DS using a format mask of `DDD HH24:MI:SS`.
  - For the Interval between Repeat Firings:   A varchar2-typed Process Variable containing a valid Oracle Interval-DS using a format mask of `DDD HH24:MI:SS`.
  - For the Maximum Number of Runs: A varchar2-typed Process Variable containing a valid number in format `nnnn`.
