# API Reference

This document provides detailed information about the SkyGuardian API.

## Client

The main interface to SkyGuardian.

```python
from skyguardian import Client

client = Client(api_key="your_api_key", region="us-west-2")
```

### Methods

#### `start_monitoring()`

Start the monitoring service.

```python
client.start_monitoring()
```

#### `stop_monitoring()`

Stop the monitoring service.

```python
client.stop_monitoring()
```

#### `get_status()`

Get the current status of the monitoring service.

```python
status = client.get_status()
print(status)  # "running", "stopped", or "error"
```

#### `get_alerts(start_time=None, end_time=None, severity=None)`

Get alerts within a specified time range.

```python
alerts = client.get_alerts(
    start_time="2023-01-01T00:00:00Z",
    end_time="2023-01-02T00:00:00Z",
    severity="high"
)
```

## Models

### Alert

Represents a security alert.

```python
class Alert:
    id: str
    timestamp: datetime
    severity: str  # "low", "medium", "high", "critical"
    message: str
    metadata: dict
``` 