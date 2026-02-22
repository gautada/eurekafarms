# ╭──────────────────────────────────────────────────────────╮
# │ Nyx Calder - OpenClaw AI Assistant Container            │
# ╰──────────────────────────────────────────────────────────╯

ARG CONTAINER_VERSION=dev

# ══════════════════════════════════════════════════════════════
# Stage 1: Build OpenClaw from source
# ══════════════════════════════════════════════════════════════
# FROM docker.io/library/node:22-trixie AS builder
FROM docker.io/gautada/openclaw:$CONTAINER_VERSION AS container

# ┌──────────────────────────────────────────────────────────┐
# │ Metadata                                                 │
# └──────────────────────────────────────────────────────────┘
LABEL org.opencontainers.image.title="nyxcalder"
LABEL org.opencontainers.image.description="Nyx Calder - Autonomous Cloud-Native Software Engineer running OpenClaw"
LABEL org.opencontainers.image.url="https://github.com/gautada/nyxcalder"
LABEL org.opencontainers.image.source="https://github.com/gautada/nyxcalder"
LABEL org.opencontainers.image.documentation="https://github.com/gautada/nyxcalder/blob/main/README.md"

# ┌──────────────────────────────────────────────────────────┐
# │ Application User                                         │
# └──────────────────────────────────────────────────────────┘
# Rename base container user (cheliped) to nyx
ARG OLD_USER=cheliped
ARG USER=nyx
RUN /usr/sbin/usermod -l "$USER" "$OLD_USER" \
 && /usr/sbin/usermod -d /home/$USER -m $USER \
 && /usr/sbin/groupmod -n $USER $OLD_USER \
 && /bin/echo "$USER:$USER" | /usr/sbin/chpasswd 
 
RUN rm -rf /home/$OLD_USER 
#  && fR $USER:$USER /opt/openclaw

# # OpenClaw workspace directory
# ENV OPENCLAW_HOME=/home/$USER
# USER $USER
# RUN pnpm install --frozen-lockfile \     
#  && pnpm build \
#  && pnpm ui:build

# ┌──────────────────────────────────────────────────────────┐
# │ Service Configuration                                    │
# └──────────────────────────────────────────────────────────┘
RUN rm -rf /home/$USER/.openclaw \
 && /bin/ln -fsv /mnt/volumes/data /home/$USER/.openclaw \
 && chown -R $USER:$USER /home/$USER
