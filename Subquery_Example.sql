SELECT 
  warehouse.warehouse_id,
  CONCAT(warehouse.state, ': ', warehouse.warehouse_id) AS warehouse_name,
  COUNT(orders.order_id) AS number_of_orders,
  (SELECT
    COUNT(*)
    FROM `test-project-393317.warehouse_orders.orders`) 
  AS total_orders,
  CASE
      WHEN COUNT(orders.order_id)/(SELECT COUNT(*) FROM `test-project-393317.warehouse_orders.orders` orders) <= 0.20
      THEN "fulfilled 20% or less of orders"
      WHEN COUNT(orders.order_id)/(SELECT COUNT(*) FROM `test-project-393317.warehouse_orders.orders` orders) > 0.20
      AND COUNT(orders.order_id)/(SELECT COUNT(*) FROM `test-project-393317.warehouse_orders.orders` orders) <= 0.60
      THEN "fulfilled >20% and <=60% of orders"
    ELSE "fulfilled more than 60% of orders"
    END AS fulfillment_summary
 FROM `test-project-393317.warehouse_orders.warehouse` warehouse
 LEFT JOIN `test-project-393317.warehouse_orders.orders` orders
  ON orders.warehouse_id = warehouse.warehouse_id
 GROUP BY
  warehouse.warehouse_id,
  warehouse_name
HAVING
  COUNT(orders.order_id) >0