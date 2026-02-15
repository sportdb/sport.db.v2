
# Sport Radar Match Status Notes 

source <https://developer.sportradar.com/soccer/docs/soccer-ig-match-status-workflow>


status vs match status


## status

Below are each of the overall status values 
you can expect to see returned from the Soccer API status attribute. 
Reference these definitions for details on what each sport event state signifies.

- not_started – The match is scheduled to be played
- started - The match has begun
- live – The match is currently in progress
- postponed – The match has been postponed to a future date
- suspended - The match has been suspended
- delayed – The match has been temporarily delayed and will be continued. Typically appears prior to match start
- interrupted - The match began, but coverage has stopped for a short time. Note that match scores may not be updated during this period, the last recorded match score will be displayed instead
- cancelled – The match has been cancelled and will not be played
- ended – The match is over
- closed – The match results have been confirmed
- abandoned - The match has been abandoned


## match_status

Below are the valid match_status values you may encounter in the Soccer API. Use these definitions to understand the specific phases of a match while it is in a live state.

- not_started – The match is scheduled to be played
- started - The match has begun
- 1st_half – The match is in the first half
- 2nd_half – The match is in the second half
- overtime – The match is in overtime
- 1st_extra – The match is in the first extra period
- 2nd_extra – The match is in the second extra period
- awaiting_penalties – Waiting for announcement of penalties
- penalties – Penalties are ongoing
- awaiting_extra_time – Waiting on referee to announce extra time
- interrupted – The match has been interrupted
- abandoned – The match has been abandoned
- postponed – The match has been postponed to a future date
- start_delayed – The match has been temporarily delayed and will be continued
- cancelled – The match has been cancelled and will not be played
- halftime – The match is in halftime
- extra_time_halftime – The match is in extra time halftime
- ended – The match has ended
- aet – The match has ended after extra time
- ap – The match has ended after penalties


samples


season schedule code sample

``` json
    {
      "sport_event": {
        "id": "sr:sport_event:50849967",
        "start_time": "2024-08-16T19:00:00+00:00",
        "start_time_confirmed": true,
        "sport_event_context": {
          "sport": {
            "id": "sr:sport:1",
            "name": "Soccer"
          },
          "category": {
            "id": "sr:category:1",
            "name": "England",
            "country_code": "ENG"
          },
          "competition": {
            "id": "sr:competition:17",
            "name": "Premier League",
            "gender": "men"
          },
          "season": {
            "id": "sr:season:118689",
            "name": "Premier League 24/25",
            "start_date": "2024-08-16",
            "end_date": "2025-05-25",
            "year": "24/25",
            "competition_id": "sr:competition:17"
          },
          "stage": {
            "order": 1,
            "type": "league",
            "phase": "regular season",
            "start_date": "2024-08-16",
            "end_date": "2025-05-25",
            "year": "24/25"
          },
          "round": {
            "number": 1
          },
          "groups": [
            {
              "id": "sr:league:84075",
              "name": "Premier League 24/25"
            }
          ]
        },
        "coverage": {
          "type": "sport_event",
          "sport_event_properties": {
            "lineups": true,
            "formations": false,
            "venue": true,
            "extended_player_stats": true,
            "extended_team_stats": true,
            "lineups_availability": "pre",
            "ballspotting": true,
            "commentary": true,
            "fun_facts": true,
            "goal_scorers": true,
            "goal_scorers_live": true,
            "scores": "live",
            "game_clock": true,
            "deeper_play_by_play": true,
            "deeper_player_stats": true,
            "deeper_team_stats": true,
            "basic_play_by_play": true,
            "basic_player_stats": true,
            "basic_team_stats": true
          }
        },
        "competitors": [
          {
            "id": "sr:competitor:35",
            "name": "Manchester United",
            "country": "England",
            "country_code": "ENG",
            "abbreviation": "MUN",
            "qualifier": "home",
            "gender": "male"
          },
          {
            "id": "sr:competitor:43",
            "name": "Fulham FC",
            "country": "England",
            "country_code": "ENG",
            "abbreviation": "FUL",
            "qualifier": "away",
            "gender": "male"
          }
        ],
        "venue": {
          "id": "sr:venue:9",
          "name": "Old Trafford",
          "capacity": 75635,
          "city_name": "Manchester",
          "country_name": "England",
          "map_coordinates": "53.463150,-2.291444",
          "country_code": "ENG",
          "timezone": "Europe/London"
        }
      },
      "sport_event_status": {
        "status": "closed",
        "match_status": "ended",
        "home_score": 1,
        "away_score": 0,
        "winner_id": "sr:competitor:35",
        "period_scores": [
          {
            "home_score": 0,
            "away_score": 0,
            "type": "regular_period",
            "number": 1
          },
          {
            "home_score": 1,
            "away_score": 0,
            "type": "regular_period",
            "number": 2
          }
        ]
      }
    }
```

sport event summary sample

``` json
  {
  "sport_event": {
    "id": "sr:sport_event:51133377",
    "start_time": "2025-06-05T18:15:00+00:00",
    "start_time_confirmed": true,
    "sport_event_context": {
      "sport": {
        "id": "sr:sport:1",
        "name": "Soccer"
      },
      "category": {
        "id": "sr:category:4",
        "name": "International"
      },
      "competition": {
        "id": "sr:competition:308",
        "name": "World Cup Qualification AFC",
        "parent_id": "sr:competition:24660",
        "gender": "men"
      },
      "season": {
        "id": "sr:season:108589",
        "name": "World Cup Qualification 2026, AFC",
        "start_date": "2023-10-12",
        "end_date": "2025-11-25",
        "year": "23-25",
        "competition_id": "sr:competition:308"
      },
      "stage": {
        "order": 3,
        "type": "league",
        "phase": "regular season",
        "start_date": "2024-09-05",
        "end_date": "2025-06-10",
        "year": "23-25"
      },
      "round": {
        "number": 9
      },
      "groups": [
        {
          "id": "sr:league:76709",
          "name": "World Cup 2026, AFC Qualification, Round 3, Group A",
          "group_name": "A"
        }
      ]
    },
    "coverage": {
      "type": "sport_event",
      "sport_event_properties": {
        "lineups": true,
        "formations": false,
        "venue": true,
        "extended_player_stats": false,
        "extended_team_stats": false,
        "lineups_availability": "pre",
        "ballspotting": true,
        "commentary": true,
        "fun_facts": true,
        "goal_scorers": true,
        "goal_scorers_live": true,
        "scores": "live",
        "game_clock": true,
        "deeper_play_by_play": true,
        "deeper_player_stats": true,
        "deeper_team_stats": true,
        "basic_play_by_play": true,
        "basic_player_stats": true,
        "basic_team_stats": true
      }
    },
    "competitors": [
      {
        "id": "sr:competitor:4792",
        "name": "Qatar",
        "country": "Qatar",
        "country_code": "QAT",
        "abbreviation": "QAT",
        "qualifier": "home",
        "gender": "male"
      },
      {
        "id": "sr:competitor:4766",
        "name": "IR Iran",
        "country": "Iran",
        "country_code": "IRN",
        "abbreviation": "IRI",
        "qualifier": "away",
        "gender": "male"
      }
    ],
    "venue": {
      "id": "sr:venue:2205",
      "name": "Jassim Bin Hamad Stadium",
      "capacity": 35000,
      "city_name": "Doha",
      "country_name": "Qatar",
      "map_coordinates": "25.267358,51.484251",
      "country_code": "QAT",
      "timezone": "Asia/Qatar"
    },
    "sport_event_conditions": {
      "referees": [
        {
          "id": "sr:referee:2162222",
          "name": "Khled Hoish, Mohammed",
          "nationality": "Saudi Arabia",
          "country_code": "SAU",
          "type": "main_referee"
        }
      ],
      "weather": {
        "pitch_conditions": "good",
        "overall_conditions": "medium"
      },
      "ground": {
        "neutral": false
      },
      "lineups": {
        "confirmed": true
      }
    }
  },
  "sport_event_status": {
    "status": "live",
    "match_status": "1st_half",
    "home_score": 0,
    "away_score": 0,
    "period_scores": [
      {
        "home_score": 0,
        "away_score": 0,
        "type": "regular_period",
        "number": 1
      }
    ],
    "ball_locations": [
      {
        "order": 4,
        "x": 34,
        "y": 82,
        "qualifier": "away"
      },
      {
        "order": 3,
        "x": 61,
        "y": 41,
        "qualifier": "away"
      },
      {
        "order": 2,
        "x": 40,
        "y": 21,
        "qualifier": "away"
      },
      {
        "order": 1,
        "x": 40,
        "y": 21,
        "qualifier": "home"
      }
    ],
    "match_situation": {
      "status": "attack",
      "qualifier": "away",
      "updated_at": "2025-06-05T18:37:30+00:00"
    },
    "clock": {
      "played": "19:14"
    }
  },
  "statistics": {
    "totals": {
      "competitors": [
        {
          "id": "sr:competitor:4792",
          "name": "Qatar",
          "abbreviation": "QAT",
          "qualifier": "home",
          "statistics": {
            "ball_possession": 64,
            "cards_given": 0,
            "corner_kicks": 0,
            "fouls": 1,
            "free_kicks": 4,
            "goal_kicks": 0,
            "injuries": 1,
            "offsides": 2,
            "red_cards": 0,
            "shots_blocked": 0,
            "shots_off_target": 1,
            "shots_on_target": 0,
            "shots_saved": 2,
            "shots_total": 1,
            "substitutions": 0,
            "throw_ins": 4,
            "yellow_cards": 0,
            "yellow_red_cards": 0
          },
          "players": [
            {
              "statistics": {
                "assists": 0,
                "corner_kicks": 0,
                "goals_scored": 0,
                "offsides": 0,
                "own_goals": 0,
                "red_cards": 0,
                "shots_blocked": 0,
                "shots_off_target": 0,
                "shots_on_target": 0,
                "substituted_in": 0,
                "substituted_out": 0,
                "yellow_cards": 0,
                "yellow_red_cards": 0
              },
              "id": "sr:player:223372",
              "name": "Hatem, Abdel Aziz",
              "starter": false
            },
            {
              "statistics": {
                "assists": 0,
                "corner_kicks": 0,
                "goals_scored": 0,
                "offsides": 0,
                "own_goals": 0,
                "red_cards": 0,
                "shots_blocked": 0,
                "shots_off_target": 0,
                "shots_on_target": 0,
                "substituted_in": 0,
                "substituted_out": 0,
                "yellow_cards": 0,
                "yellow_red_cards": 0
              },
              "id": "sr:player:229278",
              "name": "Alaaeldin, Ahmed",
              "starter": true
            }
          ]
        }
      ]
    }
  }
}
```