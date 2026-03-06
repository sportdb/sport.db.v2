Github Copilot Chat Export
<https://github.com/copilot/c/2e9ab4cd-690e-4bfc-9617-6a229daf4e45>


## Q: hello.   can you suggest some ideas how to handle or write no date and no time in a plain text format.      use  --/-- or --:-- or such?  can you comment?

A: Hello! I'd be happy to help you brainstorm ideas for representing missing date and time values in plain text formats.

Here are some common approaches and my thoughts on each:

**For Missing Dates:**
- `--/--` or `--/--/--` - Clear visual indicator, easy to scan
- `????-??-??` - Follows ISO 8601 structure but with placeholders
- `(no date)` or `[no date]` - Explicit and human-readable
- `N/A` or `—` (em-dash) - Simple and widely recognized
- `0000-00-00` - Machine-readable but potentially confusing

**For Missing Times:**
- `--:--` or `--:--:--` - Mirrors the date approach, clean and consistent
- `??:??` - Follows HH:MM structure with placeholders
- `(no time)` or `[no time]` - Explicit and clear
- `N/A` or `—` - Simple and recognizable
- `00:00:00` - Machine-readable but ambiguous (could mean midnight)

**My recommendations:**

1. **Consistency is key** - Choose a pattern and use it for both dates and times across your format
2. **The `--/--` and `--:--` approach** is intuitive because:
   - It mirrors the actual format structure
   - The dashes are visually distinct from data
   - It's easy to parse programmatically
   - No ambiguity (unlike `00:00:00` which could be a real time)

3. **For mixed contexts**, you might combine them: `2026-03-04 14:30` vs `2026-03-04 --:--` vs `--/-- --:--`

**What's your use case?** Are you designing this for human consumption, machine parsing, or both? That might help narrow down the best choice.

## Q: yes, it is both human reading & writing AND machine parsing with a context-free grammar.   any more ideas?  how about __/__ or __:__ as an alternative? or _-_-_ or such?  or the empty set unicode char for no date? any thoughts?

A: Great question! Let me explore those alternatives and discuss their tradeoffs for both human readability and context-free grammar parsing:

**Underscores vs. Dashes:**

- `__/__` or `__:__` - Visually similar to dashes but slightly wider, might be more distinct in some fonts
- **Pro:** Clear placeholder character, distinct from data
- **Con:** Underscores can be part of identifiers in some grammars; might conflict with other syntax

- `_-_-_` or similar mixed patterns - Creative but inconsistent
- **Con:** Harder to parse; unclear pattern; doesn't map cleanly to date/time structure

**Empty Set Character (∅ or similar Unicode):**

- Using `∅` for "no date" is clever and semantic
- **Pro:** Unambiguous, semantically meaningful, hard to confuse with real data
- **Con:** Requires Unicode support; might cause encoding headaches in legacy systems; harder to type; less obvious to general users what it means

**Other Unicode approaches:**
- `⊥` (perpendicular/bottom symbol) - Similar pros/cons
- `⟨⟩` (angle brackets) - More readable than ∅ but still Unicode-dependent
- `〰` (wavy dash) - Visually distinct but unusual

**My refined recommendations for context-free grammar:**

1. **`--/--` and `--:--` (my top pick for your use case)**
   - Aligns structurally with `YYYY-MM-DD` and `HH:MM:SS`
   - Escapes cleanly in CFG without special Unicode handling
   - Human-readable without explanation
   - Machine-parseable: grammar rules can literally match the pattern

2. **`__/__` and `__:__` as a close second**
   - If you want more visual separation from numeric data
   - Works well in CFG, but watch for identifier conflicts

3. **Reserve Unicode (like ∅) only if:**
   - Your grammar explicitly supports Unicode
   - You're in a domain where semantic symbols have meaning (academic, mathematical contexts)
   - You want maximum "can't possibly be real data" guarantee

**For a context-free grammar, I'd suggest:**
```
date := YYYY-MM-DD | --/--
time := HH:MM:SS | --:--:--
datetime := date SPACE time
```

This is clean, unambiguous, and doesn't require special character handling.

**What's your grammar targeting?** (Language, parser type, etc.) That might influence the best choice for your specific use case.

## Q: the format is for football (soccer) sports match schedules & results.  can you  comment what styles are in use?

A: Great context! Let me think about what you'd find in real-world football/soccer match schedules and results formats:

**Common industry standards and what they use:**

1. **FIFA/UEFA Official Formats**
   - Typically use `DD/MM/YYYY HH:MM` or `YYYY-MM-DD HH:MM`
   - For missing/unscheduled matches: often just leave blank, use `TBD`, or `–` (em-dash)
   - Time slots shown as `19:30`, `20:00`, etc.

2. **ESPN/Sofascore Style**
   - ISO format: `2026-03-04`
   - Times: `14:30` or `2:30 PM`
   - Unscheduled: `TBD`, blank field, or `–`

3. **Flashscore/League Websites**
   - Mix of `DD.MM.YYYY` (European) or `MM/DD/YYYY` (US)
   - Often use `–` or em-dash for missing values
   - Times shown as `19:30`

4. **CSV/Data Exchange Formats**
   - ISO `YYYY-MM-DD` and `HH:MM:SS`
   - Missing values: empty field, `NULL`, `N/A`, or `–`

5. **Plain Text League Tables/Schedules**
   - European style: `04.03.2026 14:30`
   - Variable approaches for missing dates: blank spaces, `--`, `TBD`

**What I see in practice for missing values in football contexts:**
- `TBD` (To Be Determined) - very common in schedules
- `–` or `—` (em-dash or en-dash) - clean, minimalist
- Blank/empty field - simplest for machine parsing
- `19:30` vs `--:--` style less common but emerging in data-heavy formats

**For your football format, I'd suggest:**

If you want to be **explicit and machine-friendly**:
- `2026-03-04 14:30` for scheduled matches
- `2026-03-04 --:--` for date known, time TBD
- `--/-- --:--` for completely unscheduled
- This mirrors what users already recognize from league websites

Alternatively, if you want **ultra-clean plain text**:
- Use `TBD` for unscheduled (very intuitive in sports context)
- Use blank lines or `N/A` for results not yet available

**Do you have any example schedules or formats you're working with that I could look at?** That would help me suggest the most practical approach for your specific use case.

## Q: yes, here's an example for the FA Cup. the  w/o matches should get marked that have no date (usually gets "inherited"):
Nov 11  
  Barnes              2-0  Civil Service       
  Crystal Palace      0-0  Hitchin            [Both Qualified]
  Maidenhead          2-0  Great Marlow        
  Upton Park          0-3  Clapham Rovers      
  Royal Engineers     w/o  Reigate Priory      
  Wanderers           w/o  Harrow Chequers     
Jan 10  
   Hitchin             0-5  Royal Engineers     
   Queen's Park        w/o  Donington School   
Mar 9    
  Royal Engineers     3-0  Crystal Palace    @ Kennington Oval, London      
  Wanderers           w/o  Queen's Park        


A: Excellent example! This is really helpful. I can see the pattern now:

**What I notice:**
- Matches are grouped by date headers (`Nov 11`, `Jan 10`, `Mar 9`)
- Most matches show scores: `2-0`, `0-0`, `3-0`
- `w/o` (walkover) matches have **no score** and implicitly inherit the date from the header
- Some matches have location annotations (`@ Kennington Oval, London`)
- The spacing/indentation groups matches under their date

**For marking `w/o` matches with explicit "no date" in plain text format:**

Here are a few approaches that preserve readability:

**Option 1: Keep w/o as-is, infer the inherited date**
```
Nov 11  
  Royal Engineers     w/o     Reigate Priory
```
Your grammar knows: `w/o` matches inherit the preceding date header. Simple, minimal markup.

**Option 2: Make the inherited date explicit**
```
Nov 11  
  Royal Engineers     w/o (--/--:--) Reigate Priory
```
Or just the date part if time is never used:
```
Nov 11  
  Royal Engineers     w/o (--/--)     Reigate Priory
```

**Option 3: Alternate marker for "no specific date"**
```
Nov 11  
  Royal Engineers     w/o [inherited]  Reigate Priory
```
More human-readable, though less machine-minimal.

**My recommendation for your football format:**

Since `w/o` is already a sports-specific convention that's universally understood, I'd suggest:

1. **Keep `w/o` as the primary marker** - it's domain-appropriate
2. **In your CFG, treat `w/o` specially:**
   ```
   match := team_a (score | w/o) team_b [location]
   score := digits "-" digits
   w/o := "w/o"  // inherits date from section header
   ```
3. **For plain text consistency**, if you ever need to show a w/o match *outside* a dated section, use:
   ```
   Royal Engineers     w/o (--/--)     Reigate Priory
   ```

**Does this align with how you're thinking about structuring it?** Should your grammar explicitly handle date inheritance, or would each match line ideally contain its own date?

## Q:   the date header mostly use Apr 17 or May 7 or such as a format - thus, can you comment if --/-- may feel intuitive for no date  or any other ideas?

A: Excellent point! Now that I see the actual date format you're using (`Apr 17`, `May 7`, etc.), let me reconsider:

**Your date format: `Mon DD` or `Mon D`**
- Very human-readable, compact
- Implicit year (context-dependent)
- Natural sports reporting style

**Now evaluating `--/--` for "no date" in this context:**

**The challenge with `--/--`:**
- It doesn't visually match your actual format (`Apr 17`)
- Looks like a date field format (like `MM/DD`), which you're not using
- Might feel slightly mismatched to users familiar with your format

**Better alternatives for your specific format:**

1. **`--` (just two dashes)** ✓ My top pick
   - Minimal, clean
   - Matches the "letter abbreviation + number" structure conceptually
   - Easy to scan: `--` vs `Apr 17`
   - Works great in plain text
   - In CFG: `date := MONTH DD | --`

2. **`???` (three question marks)** 
   - Mirrors the visual length of `Apr 17` (3 chars + 2 chars)
   - Signals "unknown" clearly
   - Less common but intuitive

3. **`TBD`** (already mentioned)
   - Very natural in sports context
   - Slightly longer but explicit
   - `TBD` vs `Apr 17` - both 3+ chars, reads naturally

4. **`--  ` (dashes + spaces)**
   - Preserves alignment if you have columnar formatting
   - Feels more intentional than single `--`

**My recommendation for your format:**

Use **`--`** as the "no date" marker:
```
Apr 17  
  Barnes              2-0  Civil Service       
  Royal Engineers     w/o  Reigate Priory      
--
  Wanderers           w/o  Harrow Chequers     
Jan 10  
  Hitchin             0-5  Royal Engineers
```

**Why `--` works best here:**
- Visually distinct from `Apr 17`, `May 7`, etc.
- Compact and clean
- Feels like a placeholder in the same "space" as a date
- Easy CFG rule: `date_header := MONTH DD | "--"`
- No ambiguity with actual data

Does `--` feel intuitive for your football format, or would you prefer one of the alternatives?

## Q:  how about ---/--  to match the date format or how about using a blank line with the rule that a blank line stops the inheritance of date (via date headers/lines)?

A: Brilliant ideas! Both are clever and worth exploring:

**Option 1: `---/--` (matching your date format structure)**

This is elegant because:
- It visually mirrors `Apr 17` length and complexity
- The slash suggests "date separator" matching your mental model
- Easy to spot as a placeholder: `---/--` vs `Apr 17`
- CFG rule is simple: `date_header := MONTH DD | "---/--"`

**Pro:** Consistent visual structure with real dates
**Con:** The slash doesn't map cleanly to your format (you don't use slashes), so it might feel slightly foreign

**Option 2: Blank line to stop date inheritance (my preference!)**

This is actually more elegant for your specific use case:

```
Apr 17  
  Barnes              2-0  Civil Service       
  Royal Engineers     w/o  Reigate Priory      

  Wanderers           w/o  Harrow Chequers     

Jan 10  
  Hitchin             0-5  Royal Engineers
```

**Why this is brilliant:**
- **Pure semantics:** Blank line = "date context ends, no inheritance"
- **No special marker needed** - uses whitespace naturally
- **Very readable** - blank lines naturally separate logical sections
- **CFG-friendly:** You can define it as:
  ```
  section := date_header match+ | match+  // blank line resets context
  ```
- **Matches publishing convention** - blank lines are standard separators in plain text
- **Zero ambiguity** - can't be confused with actual data

**My strong recommendation: Use the blank line approach**

It's cleaner, more semantic, and aligns with how plain text naturally works. Users don't need to understand special symbols—they just see a blank line and intuitively know "new context."

**Combined example:**
```
Apr 17  
  Barnes              2-0  Civil Service       
  Royal Engineers     w/o  Reigate Priory      

  Wanderers           w/o  Harrow Chequers     

Jan 10  
  Hitchin             0-5  Royal Engineers
```

The blank line before `Wanderers` signals: "This match has no scheduled date (no inherited date from above)."

Does the blank line approach feel right for your format?

## Q:  how about supporting a horizontal ruler e.g. --- as an alternative option to the blank line?  any other ideas on what to use for plain text dividers / rulers?

A: Excellent idea! A horizontal ruler like `---` gives you an explicit, visible divider. Let me explore this:

**Option: `---` (horizontal ruler for "no date" context reset)**

```
Apr 17  
  Barnes              2-0  Civil Service       
  Royal Engineers     w/o  Reigate Priory      
---
  Wanderers           w/o  Harrow Chequers     

Jan 10  
  Hitchin             0-5  Royal Engineers
```

**Pros:**
- Visually explicit - impossible to miss
- Semantic: says "context break" clearly
- Works in both human reading and machine parsing
- Clear visual separation in dense match lists

**Cons:**
- Requires one extra line
- Could conflict with markdown/other formats if you ever need interop

**Other plain text divider/ruler options:**

1. **`====` (equals signs)** - Stronger visual weight
   - More "official looking," like section headers
   - Common in ASCII art and plain text documents

2. **`----` (longer dashes)** - Matches Markdown style
   - Familiar to users of markdown/plain text
   - Provides visual rhythm

3. **`****` (asterisks)** - Decorative, clear visual break
   - Popular in plain text (looks like a separator)
   - More visual impact than dashes

4. **`~~~~` (tildes)** - Wavy separator
   - Distinct from other uses
   - Less standard but visually interesting

5. **`----` with surrounding whitespace (asymmetric)**
   ```
   Apr 17  
     ...matches...
   
   ----
   
     ...unscheduled matches...
   ```
   - Extra whitespace makes it feel more "official"

6. **`...` (ellipsis)** - Minimal, suggests "continuation elsewhere"
   - Subtle, less intrusive
   - Might be confused with omitted content

7. **`/ / /` or `| | |` (spaced patterns)** - Creative but unusual
   - More visual texture
   - Might feel overly decorative for sports data

**My recommendation for your football format:**

**Combination approach:** Support both blank line AND horizontal ruler, with `----` as the explicit ruler:

```
Apr 17  
  Barnes              2-0  Civil Service       
  Royal Engineers     w/o  Reigate Priory      

----

  Wanderers           w/o  Harrow Chequers     

Jan 10  
  Hitchin             0-5  Royal Engineers
```

**CFG rule would be:**
```
date_reset := blank_line | "----" | "====";
section := date_header match+ | date_reset match+;
```

**Why this works:**
- **Flexibility:** Users can choose blank line (minimal) or `----` (explicit)
- **Readability:** Both are recognizable dividers in plain text
- **Consistency:** `----` echoes your existing `---/--` discussion without conflicts
- **Parsing:** Easy to define in CFG - either separator resets date context

**My preference:** `----` (four dashes) feels right because:
- Longer than the casual `--` you'd use inline
- Less than a full markdown `-----`
- Clear visual weight without being overstated
- Common enough in plain text culture

Does supporting both blank lines and `----` as dividers feel like the right approach? Or do you prefer just one?

