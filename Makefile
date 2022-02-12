help:
	@grep "####" Makefile | grep -v grep | sed -e "s/####//"

cart: #### setup cart component
	@bash component/cart.sh

catalogue: #### setup catalogue component
	@bash component/catalogue.sh

frontend: #### setup frontend component
	@bash component/frontend.sh

mongodb: #### setup mongodb component
	@bash component/mongodb.sh

mysql: #### setup mysql component
	@bash component/mysql.sh

payment: #### setup payment component
	@bash component/payment.sh

redis: #### setup redis component
	@bash component/redis.sh

shipping: #### setup shipping component
	@bash component/shipping.sh

user: #### setup user component
	@bash component/user.sh

rabbitmq: #### setup rabbitmq component
	@bash component/rabbitmq.sh