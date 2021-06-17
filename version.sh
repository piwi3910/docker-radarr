echo "Finding latest radarr release and set it as a env.variable to use during docker build"
apt update -y
apt install curl grep jq sed -y
version=$(curl --silent "https://api.github.com/repos/Radarr/Radarr/tags" | jq -r '.[0].name' | sed -r 's/^.{1}//')
echo "version=$version" >> vars.env

