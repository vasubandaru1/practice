help:
	@grep "####" Makefile | grep -v grep | sed -e "s/####//"

git pull:
	@git-pull &>>/dev/null

cart: git pull #### setup cart component
	@bash component/cart.sh

catalogue: git pull #### setup catalogue component
	@bash component/catalogue.sh

frontend: git pull #### setup frontend component
	@bash component/frontend.sh

mongodb: git pull #### setup mongodb component
	@bash component/mongodb.sh

mysql: git pull #### setup mysql component
	@bash component/mysql.sh

payment: git pull #### setup payment component
	@bash component/payment.sh

redis: git pull #### setup redis component
	@bash component/redis.sh

shipping: git pull #### setup shipping component
	@bash component/shipping.sh

user: git pull #### setup user component
	@bash component/user.sh

rabbitmq: git pull #### setup rabbitmq component
	@bash component/rabbitmq.sh