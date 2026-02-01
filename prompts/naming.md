via Google AI-mode

# Q: can you comment why use et (extra_time) for the score and NOT after extra-time (aet)?  isn't the strict interpretation of extra_time only the extra-time (that is, 30 mins)?


A: In technical data structures like JSON, we prioritize clarity for the computer over linguistic conventions used for humans. You are correct that "strictly" speaking, extra time (ET) refers only to that specific 30-minute period. However, using extra_time as a score key is preferred for several reasons: 

### 1. Snapshot vs. Finality

- AET (After Extra Time) is a status. It tells a human that the game is over and the score shown is the final one.
- ET (Extra Time) in JSON represents a specific segment of the data. By labeling the key extra_time, we are defining a data point: "the score recorded at the end of the extra time periods". 

### 2. Standard Data Modeling (State-at-Time)

Data architects typically name score fields based on the clock state at the time of recording: 

- half_time: Score at 45'.
- full_time: Score at 90'.
- extra_time: Score at 120'. 

If you used after_extra_time, it would be inconsistent with full_time (which is technically "after full time"). 

### 3. Computation and Delta Logic

A "strict" interpretation of only the 30 minutes (e.g., "they played a 1-1 draw in extra time") is rarely stored because:

- The Final Score is Cumulative: In almost all sports data, the score at 120' is the only one that matters for determining the winner.
- Delta Calculation: If you need to know what happened only during those 30 minutes, a computer can easily calculate extra_time_score - full_time_score. 

#### How to use both for maximum clarity:
If you want to be both "strictly" correct and data-friendly, use extra_time for the numbers and a separate status field for the human-readable label: 

``` json
{
  "scores": {
    "full_time": {"home": 1, "away": 1},
    "extra_time": {"home": 2, "away": 1}
  },
  "status_label": "AET"
}
```


