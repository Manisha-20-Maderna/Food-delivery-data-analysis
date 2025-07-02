# 🚚 Food Delivery Data Analysis Project

This project analyzes food delivery operations using raw data imported from CSV files into MySQL, cleaned using SQL, and visualized using Python in a Jupyter Notebook. It covers data preprocessing, transformation, and insightful analysis on delivery performance, personnel, and location behavior.

## 📁 Project Structure

```
Food-delivery-data-analysis/
├── Dashboard/
├── Datasets/
├── sql/
    └── Change_data_type.sql
    └── important details.sql   
├──import_data.py
├── visualization.ipynb
└── README.md
```

## ⚙️ Setup Instructions

1. **Create a MySQL database** named `food_delivery`.

2. **Load CSVs into MySQL** using:

```bash
python scripts/import_data.py
```

3. **Clean and transform data**:

```sql
source sql/Change_data_type.sql;
```

4. **Run analysis queries**:

```sql
source sql/important_details.sql;
```

5. **Explore visualizations** in`visualization.ipynb`.


## 📊 Data Visualizations

### 1. 🚗 Average Delivery Time by Vehicle Condition
This bar chart shows the relationship between vehicle condition (rated from 0 to 3) and average delivery time. Poorer vehicle conditions (0) lead to the highest delivery times.


<img src="Dashboard/Avg Delivery Time by Vehicle Condition.png" alt="Avg Delivery Time by Vehicle Condition" width="800"/>

---


### 2. ⭐ Delivery Ratings Distribution
This histogram displays the distribution of delivery person ratings. Most ratings fall between 4.0 and 5.0, indicating generally good customer satisfaction.


<img src="Dashboard/Delivery Ratings Histogram.png" alt="Delivery Ratings Distribution" width="800"/>

---

### 3. 🧓 Deliveries by Age Group (Pie Chart)
This pie chart shows the percentage of deliveries made by different age groups. The age group **25–34** dominates the delivery workforce.


<img src="Dashboard/Deliveries by Age Group.png" alt="Deliveries by Age Group" width="800"/>


---

### 4. ⏰ Orders by Hour of Day
This bar chart shows the number of orders placed during each hour of the day. Demand spikes between **4 PM and 10 PM**, likely due to evening meal times.


<img src="Dashboard/ Orders by Hour.png" alt=" Orders by Hour" width="800"/>

---

### 5. 📅 Orders by Day of Week
This count plot illustrates how orders are spread across the week. **Wednesday and Friday** have the highest order counts.


<img src="Dashboard/ Orders by Day of Week.png" alt=" Orders by Day of Week" width="800"/>

---
### 6. 📈 Line Chart: Orders Per Day
This chart shows how daily order volume changes over time, revealing spikes on specific days.


<img src="Dashboard/ Orders Per Day.png" alt=" Orders Per Day" width="800"/>

---


## 🧰 Technologies Used

- Python (pandas, matplotlib, sqlalchemy)
- MySQL
- Jupyter Notebook
 

