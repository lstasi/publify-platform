$dbname="publify"
$dbuser="publifyuser"
$dbpassword="Publ1fy"
$webip="192.168.56.10"
$lbip="192.168.56.2"
$dbip="192.168.56.20"
$publify_folder="/var/publify"
	
node lb{
    include publify::lb
}
node web{
    include publify::web
}
node db{
    include publify::db
}
