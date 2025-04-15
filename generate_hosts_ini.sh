#!/bin/bash

# Chemins vers les fichiers
DNS_FILE="Terraform/all_public_dns.txt"
OUTPUT_FILE="Ansible/hosts.ini"
KEY_PATH="../Terraform/my-key"

# Nettoyage de l'ancien fichier hosts.ini
echo "# Inventory file auto-generated from all_public_dns.txt" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Lecture des DNS et écriture dans le fichier hosts.ini
while IFS='=' read -r key value; do
  dns=$(echo "$value" | xargs)  # Supprime les espaces éventuels

  case "$key" in
    cicdcd_public_dns)
      echo "[aws_cicdcd_instance]" >> "$OUTPUT_FILE"
      echo "ubuntu@$dns ansible_ssh_private_key_file=$KEY_PATH" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      ;;
    test_public_dns)
      echo "[aws_test_instance]" >> "$OUTPUT_FILE"
      echo "ubuntu@$dns ansible_ssh_private_key_file=$KEY_PATH" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      ;;
    production_public_dns)
      echo "[aws_production_instance]" >> "$OUTPUT_FILE"
      echo "ubuntu@$dns ansible_ssh_private_key_file=$KEY_PATH" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      ;;
    monitoring_public_dns)
      echo "[aws_monitoring_instance]" >> "$OUTPUT_FILE"
      echo "ubuntu@$dns ansible_ssh_private_key_file=$KEY_PATH" >> "$OUTPUT_FILE"
      echo "" >> "$OUTPUT_FILE"
      ;;
  esac
done < "$DNS_FILE"

echo "Fichier hosts.ini généré avec succès dans Ansible/hosts.ini"
