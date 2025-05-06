# SkyGuardian v0.2 – Simulated Drone‑Swarm Mission Planner

## 1. What the project is
SkyGuardian v0.2 is a cost‑friendly, fully‑simulated proof‑of‑concept that shows how a small fleet of autonomous quad‑rotor drones can:
- Locate a rogue (unfriendly) drone that appears around a protected facility (for example, a power plant).
- Shadow‑track that rogue drone—keep it in sight at a safe distance—without colliding with each other or the environment.
- Follow "Rules of Engagement" (ROE) written in plain English. A controller can type commands like "shadow only" or "orbit at 50 meters," and the swarm will change behaviour automatically.
- Survive bad radio conditions. Even if 40% of messages drop out (simulated jamming), each drone can keep the rogue in sight or land safely if the link fails completely.

The entire demo runs on free or very cheap cloud GPUs and open‑source simulators—no real drones or expensive hardware required.

## 2. Why it's impressive
| Skill showcased | Why recruiters care |
|-----------------|---------------------|
| Multi‑Agent Reinforcement Learning (MARL) | Shows you can make many robots cooperate using state‑of‑the‑art AI. |
| Graph Neural Networks (GNNs) | Modern technique for letting agents "talk" to neighbours efficiently. |
| Natural‑Language Control with Llama‑3 | Converts human commands to machine‑readable plans—exactly what future human/AI teaming requires. |
| Edge AI Latency Testing | Demonstrates you understand deployment constraints (Jetson‑class hardware) even without buying the boards. |
| Security Mind‑Set | mTLS encryption and jamming simulations prove you think about safety and cyber‑resilience. |
| Shoestring Budget Engineering | You shipped all of the above for < $20—shows creativity and responsibility with resources. |

## 3. High‑Level Architecture
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

Simulation back‑ends:
- **gym‑pybullet‑drones** for fast physics + RL training  
- **AirSim** for photo‑real demo runs

## 4. Major Components in Plain Language
| Piece | What it does | Simple explanation |
|-------|--------------|-------------------|
| Reinforcement‑Learning Policy (PPO‑GNN) | Tells each drone how to move every split‑second. It was trained in a game‑like simulator where it got "points" for staying close (but not too close) to the rogue drone and avoiding crashes. | It's like teaching a video‑game character by trial‑and‑error until it wins. |
| Graph Neural Network (GNN) | Lets a drone merge its own view with short messages from its neighbours in one neural‑network "brain." | Think of group chat: each drone reads its friends' pings before deciding its next step. |
| Llama‑3 8B ROE Parser | Reads a plain English instruction, then outputs tidy JSON the computer can understand. | Acts like a translator between humans and robots. |
| Mission‑Planner (ROS2) | A small program that turns the JSON plan into individual assignments: "Drone 1 go left," "Drone 2 go right," etc. | Works like a coach giving positions to players on a field. |
| MQTT with mTLS | Secure, lightweight message system each drone uses to talk to the planner. | Comparable to a private WhatsApp group with encryption. |
| Domain‑Randomisation & Packet‑Loss Simulator | Adds wind, sensor errors and dropped messages during training so real‑world surprises don't break the policy. | Like practicing basketball with ankle weights—everything feels easier in the real game. |
| TensorRT Latency Emulator | Runs the neural‑network in a slowed‑down container that mimics cheap edge hardware (< 20 ms per decision). | A stopwatch test to prove the brain will still be quick on a weaker computer. |

## 5. What the user (you) will see at the end
- A two‑minute demo video showing three simulated drones circling a photo‑real power plant in AirSim, locking onto a red rogue drone and shadow‑tracking it as it weaves.
- A split‑screen of:
  - Live console logs from the mission‑planner (role updates).
  - A textbox where the operator types a different ROE ("orbit at 50 m") and the swarm instantly changes pattern.
  - Grafana graphs proving radio packet loss is happening while track error stays low.
- A public GitHub repo containing:
  - run_demo.sh – one‑command set‑up script.
  - Pre‑trained policy file (sg_policy.trt).
  - Architecture diagrams and step‑by‑step build notes.
  - Jupyter notebook showing training curves and the RF‑resilience plot.

## 6. Success Metrics
| Metric | Target | Why it matters |
|--------|--------|---------------|
| Maximum average distance between any swarm drone and the rogue | ≤ 5 m | Drone must stay "close enough" to film rogue. |
| Reacquisition pause after occlusion | ≤ 2 s | Shows quick group re‑organisation. |
| Inference latency in "edge" mode | < 20 ms | Ensures policy is fast on Jetson‑class hardware. |
| Mission completion with 40% packet loss | ≥ 90% | Demonstrates RF‑jamming resilience. |
| Crash‑free episodes | 100% in final demo | Safety first, even in sim. |
| All code + demo delivered | 21 days | Time-bound delivery. |
| Total budget | < $20 | Cost-effective solution. |

## 7. Core Technologies Explained for High‑School Level
| Tech | Elevator pitch | Real‑world analogy |
|------|---------------|-------------------|
| Reinforcement Learning | An AI learns by doing something over and over, getting points when it does well and losing points when it does badly. | Training a puppy with treats and "no!" |
| Multi‑Agent RL (MARL) | Many AIs learn at once and must cooperate. | Classmates working on a group scavenger hunt—each person has a walkie‑talkie. |
| Graph Neural Network | A kind of neural network that reasons over a web (graph) of connections. | Figuring out the best route on a subway map, not just a straight line. |
| Llama‑3 Language Model | An open‑source "chatbot brain" that can understand and generate text. | The free alternative to ChatGPT's engine. |
| TensorRT | NVIDIA software that makes neural networks run super‑fast, especially on small GPUs. | Turning a bulky textbook into a pocket‑guide without losing information. |
| ROS2 | A set of rules and tools that let robot programs talk to each other. | USB + Wi‑Fi + some agreed‑upon words for robots. |
| MQTT | A tiny, efficient message system often used by IoT devices. | Digital walkie‑talkies that work over the internet. |
| mTLS (mutual TLS) | A way for both sides of a connection to prove who they are before speaking, and then encrypt the chat. | Showing ID cards to each other before you start talking in a secret code. |

## 8. How everything works together (step‑by‑step story)
1. User types "shadow only."
2. Llama‑3 converts that sentence into JSON:
   ```json
   {"rule": "shadow", "distance": 10, "no_intercept": true}
   ```
3. Mission‑Planner breaks the plan into individual waypoints and publishes them over MQTT.
4. Each Drone Agent receives the waypoint plus tiny status messages from neighbours.
5. The PPO‑GNN policy (running at < 20 ms) outputs new motor commands 30 times per second.
6. Physics happens in gym‑pybullet‑drones or AirSim, where wind, noise, and dropped packets randomly occur.
7. If too many packets fail, Failsafe calls land() so the drone descends safely.
8. Grafana dashboard shows live radio stats and tracking error.
9. At the end of an episode, training logs are stored; if reward improved, a new checkpoint is saved.

## 9. Rules of Engagement (ROE) Grammar
The system understands the following natural language commands:

| Command | Description | JSON Output |
|---------|-------------|------------|
| "shadow only" | Follow the rogue drone from a safe distance without intercepting | `{"rule": "shadow", "distance": 10, "no_intercept": true}` |
| "intercept at X meters" | Approach and intercept the rogue drone at specified distance | `{"rule": "intercept", "distance": X}` |
| "orbit at X meters" | Maintain circular orbit around the rogue at specified radius | `{"rule": "orbit", "distance": X}` |
| "form triangle" | Position drones in triangular formation around target | `{"rule": "formation", "pattern": "triangle"}` |
| "return to base" | Abandon tracking and return to starting position | `{"rule": "rtb"}` |

Commands can be combined with modifiers like "quietly" (reduce noise/visibility), "quickly" (prioritize speed over stealth), or "safely" (maximize distance from obstacles).

## 10. Prerequisites (skills & tools)
- Basic Python (variables, pip install, running scripts).
- Comfort with the command line (Linux or macOS preferred, Windows WSL works).
- Git & GitHub account.
- A credit card for RunPod or Google Cloud (but total spend < $20).
- A computer with at least 8 GB RAM to SSH into the cloud pod (no local GPU required).

## 11. Final Deliverables Checklist
- GitHub release v0.2 with code, policy, docs.
- Demo video (demo_final.mp4) under 2 min.
- Architecture diagram (architecture.mmd or PNG).
- Training notebook (reward_ablation.ipynb).
- RF‑resilience plot (rf_resilience_plot.png).
- LinkedIn/Twitter post summarizing project & linking video.

## Summary
SkyGuardian v0.2 lets you prove that three simulated drones can follow natural‑language orders, cooperate via cutting‑edge AI, and stay robust in harsh radio conditions—showcasing advanced robotics concepts on a shoestring budget. 