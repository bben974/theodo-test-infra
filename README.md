# theodo-test-infra

Structure avec 2 dossiers principaux: terraform et ansible.

terraform pour gérer et provisionner les machines et ansible pour gérer et provisionner les configurations.

# Dossier terraform

Le cloud choisi est OVH.

## Structure de dossier

- Le dossier `module` contient les modules standards que nous générons dans terraform, et qui seront réutilisés par la suite

- Le dossier `prod` contient l'implémentation de la production divisée en 2 dossiers `structure` qui sera le dossier d'initialisation de l'infrastructure (création du network, de la clé ssh etc) et le dossier `server` qui contient la création de nos machines

# Dossier Ansible

Ansible sera utilisé avec des playbooks

## Structure de dossier

 - Le dossier `inventory` contient les inventaires des machines 
 - Le dossier `roles` contient les différents modules standards réutilisables
 - A la racine du dossier ansible se trouvent les playbooks pour configurer nos différentes machines 
