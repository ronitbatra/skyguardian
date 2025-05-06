# Getting Started with SkyGuardian

This guide will help you set up and start using SkyGuardian.

## Installation

```bash
pip install skyguardian
```

## Configuration

Create a configuration file at `~/.config/skyguardian/config.yaml`:

```yaml
api_key: your_api_key_here
region: us-west-2
log_level: info
```

## Basic Usage

```python
import skyguardian

# Initialize the client
client = skyguardian.Client()

# Start monitoring
client.start_monitoring()

# Check status
status = client.get_status()
print(f"SkyGuardian status: {status}")
```

## Next Steps

Explore the [API Reference](api.md) for more advanced usage. 