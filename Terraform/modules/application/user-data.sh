#!/bin/bash
sudo yum update -y
sudo yum install -y httpd php php-mysql 

# Simple web page
echo "<h1>Hello from the Application Server!</h1>" | sudo tee /var/www/html/index.html

sudo tee /var/www/html/db-test.php <<EOF
<?php
\$servername = "${db_endpoint}";
\$username = "${db_username}";
\$password = "${db_password}";
\$dbname = "${db_name}";

// Create connection
\$conn = new mysqli(\$servername, \$username, \$password, \$dbname);

// Check connection
if (\$conn->connect_error) {
  die("Connection failed: " . \$conn->connect_error);
}
echo "Connected successfully to the database!";
\$conn->close();
?>
EOF

sudo systemctl start httpd
sudo systemctl enable httpd