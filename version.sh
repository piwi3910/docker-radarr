echo "Finding latest radarr release and set it as a env.variable to use during docker build"
apt update -y
apt install curl grep jq sed -y
version=$(curl --silent "https://api.github.com/repos/Radarr/Radarr/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")' | sed -r 's/^.{1}//')
echo "version=$version" >> vars.env