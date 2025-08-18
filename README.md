## Hadoop Single-Node (Docker)

Run a self-contained Hadoop 3.3.6 single-node cluster (HDFS + YARN) in Docker. The image starts NameNode, DataNode, SecondaryNameNode, ResourceManager, and NodeManager automatically.

- Hadoop: 3.3.6
- Java: OpenJDK 11
- DefaultFS: `hdfs://localhost:9000`
- Exposed ports:
  - 9000: HDFS RPC (fs.defaultFS)
  - 9870: NameNode UI
  - 8088: YARN ResourceManager UI
  - 8042: YARN NodeManager UI
  - 19888: MapReduce JobHistory UI

## Quickstart (one‑click)

Prerequisite: Docker Desktop (or Docker Engine) installed and running.

Create a host folder to exchange files with the container. These locations are recommended:

- Windows: `C:\Hadoop\shared`
- macOS: `~/Documents/shared`

Then run the container with a single command.

macOS/Linux:

```bash
mkdir -p ~/Documents/shared
docker run -d \
  -p 9000:9000 -p 9870:9870 -p 8088:8088 -p 8042:8042 -p 19888:19888 \
  -v ~/Documents/shared:/shared \
  --name hadoop-container \
  yashrajn/hadoop
```

Windows (PowerShell or CMD):

```bash
mkdir C:\Hadoop\shared 2> NUL
docker run -d ^
  -p 9000:9000 -p 9870:9870 -p 8088:8088 -p 8042:8042 -p 19888:19888 ^
  -v C:\Hadoop\shared:/shared ^
  --name hadoop-container ^
  yashrajn/hadoop
```

After a few seconds, the services will be up. You can verify with:

```bash
docker exec -it hadoop-container bash -lc "jps"
```

Expected output includes: `NameNode`, `DataNode`, `SecondaryNameNode`, `ResourceManager`, `NodeManager`.

## Build the image yourself (optional)

If you prefer to build locally from this repository:

```bash
docker build -t yashrajn/hadoop .
```

Then run it using the same commands shown in Quickstart (replace the image name if you used a different tag).

## Access the container

Open a shell inside the container:

```bash
docker exec -it hadoop-container bash
```

Check running Java processes (Hadoop daemons):

```bash
jps
```

## Web UIs

- NameNode UI: http://localhost:9870
- YARN ResourceManager UI: http://localhost:8088
- NodeManager UI: http://localhost:8042
- JobHistory UI: http://localhost:19888

## Using HDFS

The container is pre-configured with `fs.defaultFS=hdfs://localhost:9000`.

Basic commands (run inside the container):

```bash
hdfs dfs -mkdir -p /user/root
hdfs dfs -mkdir -p /data
hdfs dfs -put /shared/* /data || true
hdfs dfs -ls -R /
hdfs dfs -cat /data/<your-file>
```

Notes:

- `/shared` is a host-mounted directory. Put files there on your host to access them inside the container.
- Use `hdfs dfs -put /shared/<file> /data/` to upload from the shared folder to HDFS.

## Managing the container

Stop / start / remove:

```bash
docker stop hadoop-container
docker start hadoop-container
docker rm -f hadoop-container
```

Check recent logs:

```bash
docker logs --tail=200 hadoop-container
```

## Troubleshooting

- Ports already in use: adjust the `-p` mappings or free the ports 9000, 9870, 8088, 8042, 19888.
- `jps` shows nothing: wait a few seconds and check logs with `docker logs hadoop-container`. Ensure Docker has enough CPU/RAM.
- Windows path issues: prefer absolute paths in `-v`, e.g. `-v C:\Hadoop\shared:/shared`. For Docker Desktop with WSL2, ensure your drive is shared.
- Web UI not loading: confirm the container is running and UIs are mapped (`docker ps`), then try `curl http://localhost:9870`.

## License

This project is licensed under the terms of the Apache License 2.0. See [LICENSE](LICENSE) for details.


