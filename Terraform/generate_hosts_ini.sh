#!/bin/bash

# Fichier source généré par Terraform
INPUT_FILE="all_public_dns.txt"

# Fichier output pour Ansible
OUTPUT_FILE="hosts.ini"

# Clé privée SSH
SSH_KEY_PATH="../Terraform/my-key"

# Nom d'utilisateur par défaut
USER="ubuntu"

# Nettoyer ou créer le fichier hosts.ini
echo "# Inventory file auto-generated from all_public_dns.txt" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Lecture et traitement
while IFS='=' read -r key value; do
  # Nettoyer les espaces et guillemets
  key=$(echo "$key" | xargs)
  value=$(echo "$value" | sed 's/"//g' | xargs)

  # Associer le groupe Ansible à la clé
  case "$key" in
    cicdcd_public_dns)
      echo "[aws_cicdcd_instance]" >> "$OUTPUT_FILE"
      echo "$USER@$value ansible_ssh_private_key_file=$SSH_KEY_PATH" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      ;;
    test_public_dns)
      echo "[aws_test_instance]" >> "$OUTPUT_FILE"
      echo "$USER@$value ansible_ssh_private_key_file=$SSH_KEY_PATH" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      ;;
    production_public_dns)
      echo "[aws_production_instance]" >> "$OUTPUT_FILE"
      echo "$USER@$value ansible_ssh_private_key_file=$SSH_KEY_PATH" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      ;;
    monitoring_public_dns)
      echo "[aws_monitoring_instance]" >> "$OUTPUT_FILE"
      echo "$USER@$value ansible_ssh_private_key_file=$SSH_KEY_PATH" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      ;;
  esac
done < "$INPUT_FILE"

echo "✅ Fichier $OUTPUT_FILE généré avec succès !"
