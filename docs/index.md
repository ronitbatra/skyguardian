# SkyGuardian

![SkyGuardian](https://via.placeholder.com/800x400?text=SkyGuardian+Drone+Swarm)

## Overview

SkyGuardian v0.2 is a cost‑friendly, fully‑simulated proof‑of‑concept that shows how a small fleet of autonomous quad‑rotor drones can track and monitor rogue drones near protected facilities.

### Key Features

- **Autonomous Tracking**: Locate and shadow-track rogue drones while maintaining safe distances
- **Natural Language Control**: Issue plain English commands like "shadow only" or "orbit at 50 meters"
- **Multi-Agent Coordination**: Drones coordinate using state-of-the-art Graph Neural Networks
- **Resilient Communications**: System maintains functionality even with 40% packet loss
- **Budget-Friendly**: Entire solution built for under $20 using cloud resources

## Project Highlights

| Feature | Details |
|---------|---------|
| **Swarm Intelligence** | 3+ drones working as a coordinated team |
| **Target Tracking** | Maximum average distance ≤ 5 m |
| **Quick Recovery** | Reacquisition after occlusion ≤ 2 s |
| **Edge-Ready** | < 20 ms inference latency |
| **Low Budget** | Total cost under $20 |

## Getting Started

- For installation and setup, see the [Getting Started](getting_started.md) guide
- For a complete overview of the project goals and scope, read the [Project Charter](project_charter.md)
- To understand the system architecture, check the [Architecture](architecture.md) documentation
- For details on the command grammar, visit the [Rules of Engagement](roe.md) page

## Success Metrics

SkyGuardian is considered successful when it achieves:

1. Maximum average distance between any swarm drone and the rogue ≤ 5 meters
2. Reacquisition pause after occlusion ≤ 2 seconds
3. Mission completion with 40% packet loss ≥ 90%
4. All operations crash-free in the final demo

## Technical Stack

- **AI/ML**: Reinforcement Learning (PPO), Graph Neural Networks (GNN), Llama-3 (8B)
- **Communication**: MQTT with mTLS, ROS2
- **Simulation**: gym-pybullet-drones (training) and AirSim (demo)
- **Deployment**: TensorRT for optimized inference, cloud GPUs for training

## Demo Preview

<iframe width="560" height="315" src="https://www.youtube.com/embed/dQw4w9WgXcQ" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Quick Command Reference

| Command | Description |
|---------|-------------|
| "shadow only" | Follow from a distance without intercepting |
| "intercept at X meters" | Approach to specified distance |
| "orbit at X meters" | Circle at specified radius |
| "form triangle" | Position in triangular formation |
| "return to base" | Abandon mission and return home |
