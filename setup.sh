#!/bin/bash
set -euo pipefail
#
# SCOPE OF WORK TOOLS
#
WORK_TOOLS=(git docker curl)
#
# COLOR VARIABLES
#
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' 
#
# LOG FUNCTIONS
#
log_info() { echo -e "${GREEN}[INFO]${NC} $*" ; } 
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*" ; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" ; }
log_step() { echo -e "${BLUE}[STEP]${NC} $*" ; }
log_ok() { echo -e "${GREEN}[OK]${NC} $*" ; }
#
# CHECK ARGUMENT FUNCTIONS
#
check_argument() {
if [[ -z "${1:-}" ]]
then
	log_error "Usage: setup.sh <project_name>"
	exit 1
fi
}
#
# MAIN FUNCTIONS
#
# Creating a project structure function
#
create_structure () {
#
# LOCAL VARIABLES
#
local project_path="$1"
local parent_dir
parent_dir=$(dirname "$project_path")
#
# CHECKING THE CORRECTNESS OF AN ARGUMENT
#
# Check parent directory existing
if [[ ! -d "$parent_dir" ]]
then
	log_error "Parent directory does not exist: ${parent_dir}"
	return 1
fi
#
# Check argument already existsing
#
if [[ -e "$project_path" ]]
then
	log_error "Already exists: ${project_path}"
	return 1
fi
#
# CREATING A PROJECT STRUCTURE
#
log_step "Creation ${project_path} directory"
mkdir "$project_path" && log_ok "${project_path} created" # Folder of project 

for folder in "src" "tests" "docs" ".github"
do
	log_step "Creation ${folder} directory"
	mkdir "${project_path}/${folder}" && log_ok "${folder} created"
done
}
#
# Check tool function
#
check_tools() {
for tool in "$@"
do
	if command -v "$tool" &>/dev/null
	then
		log_ok "${tool} found."
	else
		log_warn "${tool} not found"
	fi
done
}
#
# SCRIPT BODY
#
PROJECT_NAME="${1:-}"

check_argument "$PROJECT_NAME"
check_tools "${WORK_TOOLS[@]}"
create_structure "$PROJECT_NAME"
