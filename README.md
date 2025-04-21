# UR10 Simulation with ROS2, Gazebo, MoveIt, and UR Interfaces

This project provides a simulation environment for the UR10 robotic arm using ROS2, Gazebo, MoveIt, and UR interfaces. It is designed for researchers and developers working on robotics applications.

## Features
- Simulate the UR10 robotic arm in a virtual environment.
- Utilize ROS2 for robot control and communication.
- Integrate with Gazebo for physics-based simulation.
- Use MoveIt for motion planning and manipulation.
- Leverage UR interfaces for seamless interaction with the robotic arm.

## Getting Started

### Prerequisites
Ensure you have the following dependencies installed:
- Docker
- ROS2
- ROS2 Control
- MoveIt

### Setup
1. Clone this repository to your local machine.
2. Use Docker to interact with the project. The `docker-compose.yaml` file defines the necessary services.

### Folder Structure
The following is the folder structure of this project:

```
/home/gabriel/ur10_ws/
├── docker-compose.yaml   # Docker Compose configuration for services
├── README.md             # Project documentation
├── config/               # Configuration files (currently empty)
├── docker/               # Docker-related files
│   └── common.yaml       # Common Docker service definitions
└── src/                  # Source code for the project
    ├── package_1/        # Example package 1
    └── package_2/        # Example package 2
```

### Usage
To start using the project, run the following commands to pull dependecies and relevant packages to compile:
```bash
./scripts/update
```

Build the docker image and compile packages
```bash
docker compose run --rm --build compile
```

To run a bash inside the docker, run:
```bash
docker compose run --rm bash
```

To just compile the packages
```bash
docker compose run --rm compile
```

This will bring up the defined services. You can interact with the simulation environment through the provided Docker interface.

### Services
The `docker-compose.yaml` file defines several services for different tasks. These will be detailed as the project evolves.

## Target Audience
This project is intended for:
- Researchers exploring robotic arm simulations.
- Developers building applications for the UR10 robotic arm.

## Contributing
Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## License
This project is licensed under MIT. Please update this section with the appropriate license information.
