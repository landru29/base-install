#!/usr/bin/env bash

set -euo pipefail

REMOVE_CONTAINERS=false
REMOVE_VOLUMES=false
REMOVE_IMAGES=false

usage() {
  echo "Usage: $(basename "$0") [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --containers    Supprime tous les containers"
  echo "  --volumes       Supprime tous les volumes"
  echo "  --images        Supprime toutes les images"
  echo "  --help          Affiche cette aide"
  exit 0
}

if [[ $# -eq 0 ]]; then
  echo "Aucune option spécifiée. Utilisez --help pour voir les options disponibles."
  exit 1
fi

for arg in "$@"; do
  case "$arg" in
    --containers) REMOVE_CONTAINERS=true ;;
    --volumes)    REMOVE_VOLUMES=true ;;
    --images)     REMOVE_IMAGES=true ;;
    --help)       usage ;;
    *)
      echo "Option inconnue : $arg"
      echo "Utilisez --help pour voir les options disponibles."
      exit 1
      ;;
  esac
done

# --- Containers ---
if [[ "$REMOVE_CONTAINERS" == true ]]; then
  echo "🗑️  Suppression des containers..."
  CONTAINERS=$(docker ps -aq)
  if [[ -n "$CONTAINERS" ]]; then
    docker stop $CONTAINERS 2>/dev/null || true
    docker rm $CONTAINERS
    echo "✅ Containers supprimés."
  else
    echo "ℹ️  Aucun container à supprimer."
  fi
fi

# --- Volumes ---
if [[ "$REMOVE_VOLUMES" == true ]]; then
  echo "🗑️  Suppression des volumes..."
  VOLUMES=$(docker volume ls -q)
  if [[ -n "$VOLUMES" ]]; then
    docker volume rm $VOLUMES
    echo "✅ Volumes supprimés."
  else
    echo "ℹ️  Aucun volume à supprimer."
  fi
fi

# --- Images ---
if [[ "$REMOVE_IMAGES" == true ]]; then
  echo "🗑️  Suppression des images..."
  IMAGES=$(docker images -aq)
  if [[ -n "$IMAGES" ]]; then
    docker rmi -f $IMAGES
    echo "✅ Images supprimées."
  else
    echo "ℹ️  Aucune image à supprimer."
  fi
fi
