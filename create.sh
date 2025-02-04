#!/usr/bin/env bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Dinosaur ASCII Art (full body)
dino_art() {
  echo -e "${CYAN}"
  echo "                __"
  echo "               / _)"
  echo "      _.----._/ /"
  echo "     /         /"
  echo "  __/ (  | (  |"
  echo " /__.-'|_|--|_|"
  echo -e "${NC}"
}

# Function to display success message
success_message() {
  echo -e "${GREEN}Project '$1' has been successfully created!${NC}"
}

# Start of the script
clear
dino_art
echo -e "${BLUE}Welcome to the Deno Dev Container Setup Script!${NC}"
echo -e "${YELLOW}What would you like to name your project? (default: my-deno-project)${NC}"
read -p "Project name: " project_name

# If no project name is given, use the default name
project_name=${project_name:-my-deno-project}

# Check if the directory already exists
if [ -d "$project_name" ]; then
  echo -e "${RED}Error: A directory named '$project_name' already exists in the current directory.${NC}"
  exit 1
fi

# Download the boilerplate zip quietly
echo -e "${CYAN}Setting up the project...${NC}"
curl -L -o boilerplate.zip https://github.com/5t111111/deno-devcontainer-boilerplate/archive/refs/heads/main.zip > /dev/null 2>&1

# Unzip and copy into the project directory,
unzip -q boilerplate.zip -d "${project_name}_temp"

mv "${project_name}_temp/deno-devcontainer-boilerplate-main" "$project_name"

# Remove the now-empty directory
rm -r "${project_name}_temp"

# Replace 'deno-devcontainer-boilerplate' with the project name in compose.yaml
if [[ "$(uname)" == "Darwin" ]]; then
  sed -i '' "s/deno-devcontainer-boilerplate/$project_name/g" "$project_name/.devcontainer/compose.yaml"
else
  sed -i "s/deno-devcontainer-boilerplate/$project_name/g" "$project_name/.devcontainer/compose.yaml"
fi

# Overwrite README.md with the project name
echo "# $project_name" > "$project_name/README.md"

# Remove the zip file
rm boilerplate.zip

# Remove the script file itself
rm "$project_name/create.sh"

# Display success message
success_message "$project_name"
