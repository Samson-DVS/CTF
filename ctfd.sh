# Update the package manager and install dependencies
sudo apt-get update
sudo apt-get install -y python3-pip python3-dev libpq-dev postgresql postgresql-contrib nginx

# Create a new user and database for CTFd
sudo -u postgres createuser ctfd
sudo -u postgres createdb -O ctfd ctfd

# Clone the CTFd repository and install the required Python packages
git clone https://github.com/CTFd/CTFd.git
cd CTFd
pip3 install -r requirements.txt

# Set up the CTFd configuration file
cp config.example.py config.py

# Run the CTFd setup script and follow the prompts
python3 serve.py --setup

# Create a systemd service file for CTFd
echo "
[Unit]
Description=CTFd
After=network.target

[Service]
User=ctfd
WorkingDirectory=$(pwd)
ExecStart=$(which python3) serve.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/ctfd.service

# Start the CTFd service and enable it to start on boot
sudo systemctl start ctfd
sudo systemctl enable ctfd

# Set up Nginx as a reverse proxy for CTFd
echo "
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
" | sudo tee /etc/nginx/sites-available/ctfd

# Enable the CTFd site in Nginx and restart the Nginx service
sudo ln -s /etc/nginx/sites-available/ctfd /etc/nginx/sites-enabled/
sudo systemctl restart nginx