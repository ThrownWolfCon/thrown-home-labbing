---
title: "Multi-container app with Compose"
linkTitle: "Compose app"
description: "Run a web server, an app, and a database together with Docker Compose, and practice the things that go wrong: networking between containers, data persistence, and startup order."
weight: 20
params:
  topic: tutorial
  area: "Containers"
  time: "about 30 minutes"
  difficulty: "Intermediate"
tags: ["Containers"]
---

{{< lab-meta >}}

## Goal

Run a web server, an app, and a database together with Docker Compose, and practice the things that go wrong: networking between containers, data persistence, and startup order.

## You'll need

- Docker with the Compose plugin ([Install Docker on Ubuntu]({{< ref "/docs/labs/containers/install-docker" >}}))

## Setup

```bash
mkdir -p ~/compose-lab && cd ~/compose-lab
```

Create `compose.yaml`:

```yaml
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    depends_on:
      - app
    networks:
      - app-net

  app:
    image: python:3.12-alpine
    command: python -m http.server 8000
    working_dir: /srv
    volumes:
      - ./site:/srv          # bind mount: files from your folder
    networks:
      - app-net

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: lab
      POSTGRES_PASSWORD: lab-only-password
      POSTGRES_DB: labdb
    volumes:
      - db-data:/var/lib/postgresql/data   # named volume: managed by Docker
    networks:
      - app-net

networks:
  app-net:

volumes:
  db-data:
```

And a page for the app to serve:

```bash
mkdir -p site && echo "<h1>Hello from the app container</h1>" > site/index.html
```

## Do it

1. **Bring it up and look around:**

    ```bash
    docker compose up -d
    docker compose ps
    docker compose logs --tail 20
    curl -s localhost:8080 | head -5
    ```

2. **Containers find each other by service name.** Exec into `web` and reach `app`:

    ```bash
    docker compose exec web wget -qO- http://app:8000
    docker network inspect compose-lab_app-net --format '{{range .Containers}}{{.Name}} {{.IPv4Address}}{{"\n"}}{{end}}'
    ```

3. **Bind mounts are live.** Edit the page on your host and fetch it again from inside:

    ```bash
    echo "<h1>Edited on the host</h1>" > site/index.html
    docker compose exec web wget -qO- http://app:8000
    ```

4. **Named volumes outlive containers.** Write data, destroy the containers, bring them back:

    ```bash
    docker compose exec db psql -U lab -d labdb -c "CREATE TABLE notes(t text); INSERT INTO notes VALUES ('still here');"
    docker compose down
    docker compose up -d
    sleep 5
    docker compose exec db psql -U lab -d labdb -c "SELECT * FROM notes;"
    ```

5. **See where the data really lives:**

    ```bash
    docker inspect $(docker compose ps -q db) --format '{{json .Mounts}}' | python3 -m json.tool
    ```

## What you should see

- Step 2: `web` reaches `app` by name. Compose runs a DNS server on the project network.
- Step 3: the edit shows up immediately, with no rebuild or restart.
- Step 4: `still here` survives `down` and `up`, because `down` removes containers and networks but not named volumes.
- Step 5: `"Type": "bind"` with your folder as `Source` for `app`, and `"Type": "volume"` under `/var/lib/docker/volumes/` for `db`.

{{< callout type="info" >}}
**depends_on isn't 'wait until ready'**

`depends_on` only controls start *order*. Postgres can take a few seconds to accept connections after its container starts. For real apps, add a `healthcheck:` to `db` and use `depends_on: { db: { condition: service_healthy } }`.
{{< /callout >}}

{{< callout type="warning" >}}
**Secrets in compose files**

The password above is fine for a throwaway lab. For anything real, put secrets in an `.env` file that's listed in `.gitignore`, and never commit it.
{{< /callout >}}

## Cleanup

```bash
cd ~/compose-lab
docker compose down -v      # -v also removes the named volume
cd ~ && rm -rf ~/compose-lab
```

## Next steps

- Add a healthcheck to `db` and the `service_healthy` condition.
- Point nginx at `app` as a reverse proxy with a mounted `default.conf`.
- Break name resolution by moving `app` to a second network, then diagnose it.
