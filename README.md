# OS 12th Project

# System Monitoring Project 

This project delivers a comprehensive system monitoring solution using a **Zenity-based graphical user interface (GUI)**, designed for ease of use and adaptability. It enables users to monitor system performance, hardware health, and generate detailed reports with a **user-friendly dashboard**. To ensure portability and compatibility across various platforms, the project is fully containerized with Docker, simplifying deployment and usage on diverse operating systems and hardware configurations.

## Features
- Real-time monitoring of **CPU, memory, disk, and network metrics**.
- **Alerts** for critical conditions like high CPU/memory usage or low disk space.
- **User-friendly GUI** powered by Zenity for report viewing and system monitoring.
- Generates detailed reports in **Markdown and HTML formats**.
- **Dockerized** for portability and reproducibility.

## Requirements

### For Direct Execution (Without Docker)
Ensure the following packages are installed:
- `sysstat`: For CPU and memory metrics.
- `dos2unix`: Command is used to convert text files from the DOS/Windows format to the Unix/Linux format, also to fix Line Ending Issues.
- `python3`: Command used to run Python 3.x on your system. Python is a programming language, and python3 specifically refers to version 3 of Python. It is the recommended version for most current development work, as Python 2 is no longer supported.
- `python3-pip`: This is the package manager for Python 3. It allows you to install, upgrade, and manage Python libraries and packages from the Python Package Index (PyPI). It's used for installing third-party libraries or tools that are not part of the Python standard library.
- `lm-sensors`: For temperature monitoring.
- `smartmontools`: For disk health checks.
- `zenity`: For GUI support.
- `pandoc`: For generating HTML reports.
- `curl`: For network testing.
- `net-tools`: For basic network commands like ifconfig.
- `iproute2`: For advanced networking tools like ip.
- `x11-utils`: For managing X11 displays (useful for GUI applications in a container).
- `lshw`: For detailed hardware information.
- `xdg-utils`: For opening files and URLs with default desktop applications.
- `chromium`: For viewing HTML reports.
- `mesa-utils`: For providing OpenGL utilities.
- `bc`: For performing floating-point and arbitrary precision calculations in shell scripts.
- `CUDA Toolkit 11.8`: The NVIDIA System Management Interface tool for monitoring and managing NVIDIA GPUs.
- `rocm-smi` : The ROCm System Management Interface tool for monitoring and managing AMD GPUs.

Install these packages on Debian/Ubuntu-based systems with:
```bash
sudo apt-get update
sudo apt-get update && sudo apt-get install -y sysstat lm-sensors smartmontools zenity pandoc curl net-tools iproute2 x11-utils lshw xdg-utils chromium mesa-utils bc rocm-smi dos2unix python3 python3-pip
wget https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/cuda-keyring_1.0-1_all.deb
sudo dpkg -i cuda-keyring_1.0-1_all.deb
sudo apt-get update && apt-get install -y
cuda-toolkit-11-8
```

### For Docker Execution
- Visit **https://www.docker.com/** to build and run containers.
- Docker Compose (optional, for orchestration).

## Installation and Setup

### Running Locally (Without Docker) on VMs or WSL 2

1- Ensure that above requirements are installed.

2- Clone the repository:
```bash
git clone https://github.com/yourusername/system-monitoring.git
cd system-monitoring
```

3- Make the script executable:
```bash
chmod +x monitor.sh
```

4- Run the script (one of the two ways):
```bash
./monitor.sh
bash monitor.sh
```

### Running with Docker on VMs or WSL 2
1- Install Docker on Linux (You can also install Docker by following the instructions on the official [**Docker Website**](https://docs.docker.com/engine/install/)):
```bash
sudo apt-get update
sudo apt-get install -y docker.io
```

2- Or on Windows, [**Docker Website**](https://docs.docker.com/engine/install/):
- After installing **Docker Desktop** from the website above, make sure it's running. Docker Desktop provides a Docker daemon that WSL can access.
- Configure **WSL Integration** with Docker Desktop:
  - Open **Docker Desktop**.
  - Go to Settings (the **gear icon in the top-right**).
  - In the General tab, ensure that **Enable the experimental WSL 2-based engine is checked**.
  - Go to the **Resources tab** and then the **WSL Integration section**.
  - Ensure that your WSL distributions (like **Ubuntu**) are enabled to use Docker.
  - Make sure your WSL distributions (e.g., Ubuntu) are selected. You can toggle on the distributions you want to use Docker with (typically, you’ll select the one you’re using, e.g., Ubuntu).
  - Click **Apply & Restart** if you made any changes.
- Check Docker Status in WSL:
```bash
docker --version
docker info
```

3- Build the Docker image:
```bash
docker build -t system-monitor .
```

4- Controlling for the X server in a Unix/Linux environment:
```bash
xhost +local:docker
```
- **xhost:** A utility to manage the access control list for the X server. It allows or denies connections from clients.
local: This option specifies that the restriction applies to local connections, meaning connections initiated from the local machine (using UNIX domain sockets).
:docker: Specifies a particular user or group, in this case, the docker group. When combined with -local, it denies X server access to local processes running as users in the docker group.
- When using GUI applications inside **Docker containers** that rely on the **host's X server** (e.g., **to display a graphical window**), the container must have **permission to connect to the X server**. However, allowing all containers unrestricted access to the X server poses security risks.
- Running **xhost -local:docker** ensures that **Docker containers are not automatically granted access to your X server**. This is a security measure to prevent untrusted containers from interacting with your host's graphical environment.

2- Run the container:
```bash
docker run --rm -it --name system-monitor --privileged --device=/dev/sda --env DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --net=host --gpus all -v /home/user/system_logs:/app/monitoring_logs -v /mnt/c:/mnt/c -v /mnt/d:/mnt/d -v /mnt/e:/mnt/e -v /proc:/host_proc --cpus="4" system-monitor > /dev/null 2>&1
```
- **docker run:** Launches a new container from the specified image.
- **--rm:** Automatically removes the container when it stops.
- **-it:** -i, keeps the STDIN (standard input) open even if not attached, -t, allocates a pseudo-TTY (a terminal interface), enabling interactive terminal use. Together, these allow the container to be run interactively.
- **-name system-monitor:** Assigns the name system-monitor to the container, makes it easier to reference this container by name in subsequent commands.
- **-privileged:** Grants the container additional privileges, including access to host devices and capabilities. Required for operations like accessing hardware or modifying certain system-level configurations, e.g., reading disk SMART status or GPU metrics.
- **-device=/dev/sda:** Provides access to the host's /dev/sda device (a storage device like a hard drive or SSD) inside the container. Allows tools like smartctl (used in the script) to query the physical disk's health and attributes.
- **-env DISPLAY=$DISPLAY:** Passes the host's DISPLAY environment variable to the container. This allows GUI applications inside the container to connect to the host's X server and display windows on the host's screen.
- **-v /tmp/.X11-unix:/tmp/.X11-unix:** Mounts the host's X server socket (located at /tmp/.X11-unix) into the container at the same path. Facilitates communication between GUI applications in the container and the host's X server for window rendering.
- **--net=host:** The --net=host option in Docker specifies that the container should use the host machine's network stack instead of creating its own isolated network. This means that the container will have direct access to the host's network interfaces and IP addresses, allowing it to communicate with the outside world using the host’s networking configuration. For a GUI application to display on the host machine’s screen, the container needs access to the X11 server, typically by setting the DISPLAY environment variable and mounting /tmp/.X11-unix from the host to the container. The issue could have been caused by the container not having proper network permissions to access the X11 server. X11 uses access control via authorization tokens stored in files like ~/.Xauthority. With --net=host, the container may have been able to bypass some network-related restrictions, and thus, properly connect to the X11 server.
- **--gpus all:** Grants the container access to all GPUs on the host, necessary for running GPU-based tasks or CUDA-enabled applications.
- **-v /home/user/system_logs:/app/monitoring_logs:** Mounts a host directory (/home/user/system_logs) to the container's directory (/app/monitoring_logs), enabling log persistence and sharing between the host and container.
- **-v /mnt/c:/mnt/c -v /mnt/d:/mnt/d -v /mnt/e:/mnt/e:** These flags mount the Windows drives C:, D:, and E: into the container, making them accessible at /mnt/c, /mnt/d, and /mnt/e, respectively.
- **--cpus="4":** Limits the container to using up to 4 CPU cores. This ensures the container doesn't monopolize the host's CPU resources.
- **system-monitor:** Specifies the Docker image to use for creating the container. In this case, it refers to an image named system-monitor.
- **\> dev/null:** Redirects standard output (stdout) to /dev/null, effectively discarding it.
- **2>&1:** Redirects standard error (stderr) to standard output (stdout), so both are sent to /dev/null

4- Running with Docker Compose (Optional)
- Start the service:
```bash
docker-compose up
```
- Stop the service:
```bash
docker-compose down
```

## How to Use

### Launch the Dashboard
**- The script opens a Zenity-based GUI with three options:**
  - **Run System Monitoring:** Collects metrics and generates a report.
  - **View Historical Reports:** Browse and view saved reports.
  - **Exit:** Closes the application.**

**- View Alerts:**
  - Real-time alerts for critical conditions are displayed as Zenity notifications.

**- View Reports:**
  - Reports are saved in the monitoring_logs directory. Select a report through the GUI to view details.
