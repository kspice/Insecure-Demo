USE demo;
CREATE TABLE banned_clients (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    client TEXT NOT NULL,
    added DATETIME DEFAULT NOW()
);
CREATE TABLE referers (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    referer TEXT NOT NULL
);
