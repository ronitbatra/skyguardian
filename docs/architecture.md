# SkyGuardian Architecture

This document provides a detailed look at the SkyGuardian system architecture and how the components interact with each other.

## System Overview

SkyGuardian employs a multi-agent reinforcement learning (MARL) approach to control a swarm of drones, with communication handled through a mission planner that accepts natural language commands.

```
                ┌────────────────────┐
                │ Human Operator GUI │
                │ "shadow only" text │
                └────────┬───────────┘
                         ▼
           ┌──────────────────────────────┐
           │ ROE Parser (Llama‑3 8B)      │
           │  • Takes English, returns    │
           │    JSON mission plan         │
           └────────┬─────────────────────┘
                    ▼
        ┌────────────────────────┐
        │ Mission‑Planner (ROS2) │
        │  • Assigns roles       │
        │  • Publishes waypoints │
        └──────┬──────┬──────────┘
               │MQTT  │Secure mTLS
       ┌───────┘      └─────────────┐
  ┌──────────────┐           ┌──────────────┐
  │ Drone Agent  │           │ Drone Agent  │   … (3 total)
  │ • Policy net │           │ • Policy net │
  │   (PPO+GNN)  │           │   (PPO+GNN)  │
  └──────────────┘           └──────────────┘
               ▲    packet‑drop simulator ▲
               └─────────────┬────────────┘
                             ▼
                   Rogue Drone (scripted)
```

## Key Components

### 1. User Interface

A simple text-based interface allows operators to issue commands in natural language. The interface also displays:

- Live console logs from the mission planner
- Real-time metrics on drone performance
- Visualization of the simulation environment

### 2. Natural Language Processing

The ROE Parser uses Llama-3 8B to convert natural language commands into structured JSON:

```json
{
  "rule": "shadow",
  "distance": 10,
  "no_intercept": true,
  "priority": "stealth"
}
```

This small fine-tuned model runs efficiently even on consumer GPUs and can understand a variety of command phrasings.

### 3. Mission Planner

Built on ROS2, the Mission Planner:

- Maintains global state awareness
- Assigns specific roles to each drone
- Publishes waypoints and behavior parameters
- Handles conflict resolution between agents
- Implements fallback behaviors if communications fail

### 4. Drone Agents

Each drone agent runs:

- A Graph Neural Network (GNN) for communication between drones
- A Proximal Policy Optimization (PPO) reinforcement learning model
- Sensor fusion algorithms for target tracking
- Local obstacle avoidance
- Failsafe protocols for communications loss

### 5. Communication Layer

Communication between components uses:

- MQTT with mTLS for secure, lightweight messaging
- ROS2 topics for coordination between drones
- Simulated packet loss and latency to test resilience

### 6. Simulation Environment

The system runs in two simulation environments:

1. **gym-pybullet-drones**
   - Fast physics engine
   - Ideal for training reinforcement learning models
   - Supports hundreds of simulations in parallel

2. **AirSim**
   - Photo-realistic environment
   - High-fidelity physics
   - Used for final demo and visualization

## Technical Implementation Details

### Reinforcement Learning Implementation

The PPO-GNN policy was trained with the following parameters:

- Reward function combining:
  - Negative reward for distance from target beyond threshold
  - Negative reward for collisions
  - Positive reward for maintaining line-of-sight
  - Reward shaping to encourage cooperative behavior
- Training regime:
  - 10M timesteps on gym-pybullet-drones
  - Domain randomization for wind, sensor noise, and communications
  - Curriculum learning starting with simple tasks

### System Requirements

- **Training**: Cloud GPU (e.g., A100 on RunPod)
- **Inference**: Consumer GPU (GTX 1060 or better)
- **Deployment target**: Nvidia Jetson Nano or Xavier NX
- **Storage**: ~2GB for models and simulation environment

### Integration Testing

The system includes:

- Unit tests for each component
- Integration tests for the full system
- Stress tests with increasing packet loss rates
- Adversarial tests with unpredictable rogue drone behavior 