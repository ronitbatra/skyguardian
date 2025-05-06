# Rules of Engagement (ROE)

SkyGuardian accepts natural language commands that define how the drone swarm should interact with the rogue drone. This document provides detailed information on the command grammar and available options.

## Command Structure

Commands typically follow this structure:

```
<action> [at <distance> meters] [with <modifier>]
```

For example:
- "shadow only"
- "intercept at 15 meters"
- "orbit at 30 meters quickly"

## Available Commands

| Command | Description | JSON Output | Example |
|---------|-------------|------------|---------|
| **shadow** | Follow the rogue drone from a safe distance without direct interception attempts | `{"rule": "shadow", "distance": 10, "no_intercept": true}` | "shadow only" |
| **intercept** | Approach and intercept the rogue drone at specified distance | `{"rule": "intercept", "distance": X}` | "intercept at 8 meters" |
| **orbit** | Maintain circular orbit around the rogue at specified radius | `{"rule": "orbit", "distance": X}` | "orbit at 20 meters" |
| **formation** | Position drones in a specific formation around target | `{"rule": "formation", "pattern": "TYPE"}` | "form triangle" |
| **rtb** | Return to base, abandoning tracking mission | `{"rule": "rtb"}` | "return to base" |

## Command Modifiers

Commands can be enhanced with modifiers that adjust behavior parameters:

| Modifier | Effect | JSON Parameter | Example |
|----------|--------|---------------|---------|
| **quickly** | Prioritize speed over stealth | `"priority": "speed"` | "shadow quickly" |
| **quietly** | Minimize noise/visibility | `"priority": "stealth"` | "orbit quietly" |
| **safely** | Maximize distance from obstacles | `"priority": "safety"` | "intercept safely" |
| **aggressively** | Minimize response time, accept higher risk | `"priority": "aggressive"` | "shadow aggressively" |

## Formation Patterns

When using the "formation" command, these patterns are available:

| Pattern | Description | JSON Parameter |
|---------|-------------|---------------|
| **triangle** | Triangular formation around target | `"pattern": "triangle"` |
| **line** | Linear formation (useful for convoy escort) | `"pattern": "line"` |
| **circle** | Equal spacing in a circle | `"pattern": "circle"` |

## Complete Examples

Here are some complete command examples and their JSON interpretations:

### "shadow only"
```json
{
  "rule": "shadow",
  "distance": 10,
  "no_intercept": true
}
```

### "intercept at 5 meters quickly"
```json
{
  "rule": "intercept",
  "distance": 5,
  "priority": "speed"
}
```

### "orbit at 15 meters quietly"
```json
{
  "rule": "orbit",
  "distance": 15,
  "priority": "stealth"
}
```

### "form triangle safely"
```json
{
  "rule": "formation",
  "pattern": "triangle",
  "priority": "safety"
}
```

## Command Processing

1. The natural language command is sent to the Llama-3 ROE Parser
2. The parser extracts intent, parameters, and modifiers
3. A structured JSON representation is generated
4. The Mission Planner interprets the JSON and creates individual task assignments
5. Each drone receives its specific instructions through the MQTT channel

## Fallback Behavior

If a command is ambiguous or contains conflicting parameters, the system will:

1. Use default values for missing parameters
2. Prioritize safety over performance
3. Request clarification for severely ambiguous commands

For example, if "orbit" is specified without a distance, it defaults to 10 meters.

## Adding New Commands

The command set can be extended by fine-tuning the Llama-3 model on additional examples. The system architecture supports adding new commands without altering the core drone policy, as the Mission Planner handles the translation between high-level commands and specific drone behaviors. 