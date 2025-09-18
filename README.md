# COVID-19 Data Exploration with SQL

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![SQL Server](https://img.shields.io/badge/SQL%20Server-2019+-red.svg)](https://www.microsoft.com/en-us/sql-server/)
[![Data Analysis](https://img.shields.io/badge/Data-Analysis-blue.svg)](https://github.com/Mazenibrahem1/COVID-Portfolio-Project.sql)

A comprehensive SQL-based data exploration project analyzing COVID-19 pandemic data to uncover insights about infection rates, mortality patterns, vaccination progress, and global trends. This project demonstrates advanced SQL techniques and data analysis methodologies applied to real-world pandemic data.

## 🎯 Project Overview

This project performs in-depth analysis of COVID-19 data using Microsoft SQL Server, exploring various aspects of the pandemic including:

- **Infection Rate Analysis**: Understanding how COVID-19 spread across different populations
- **Mortality Pattern Investigation**: Analyzing death rates and their variations by geography and time
- **Vaccination Progress Tracking**: Monitoring global vaccination rollout and coverage
- **Comparative Analysis**: Comparing pandemic impact across countries and continents
- **Temporal Trend Analysis**: Identifying patterns and trends over time

## 🛠️ Technical Skills Demonstrated

- **Complex SQL Joins**: Multi-table analysis combining deaths and vaccination datasets
- **Common Table Expressions (CTEs)**: Simplifying complex queries and improving readability
- **Temporary Tables**: Efficient data processing for complex calculations
- **Window Functions**: Advanced analytical functions for running totals and rankings
- **Aggregate Functions**: Statistical analysis and data summarization
- **Data Type Conversions**: Proper handling of different data formats
- **View Creation**: Preparing data for visualization tools
- **Query Optimization**: Efficient data retrieval and processing techniques

## 📊 Key Insights Generated

### Global Impact Analysis
- Worldwide infection and death rates
- Countries with highest impact relative to population size
- Continental comparison of pandemic severity

### Temporal Trends
- Evolution of infection rates over time
- Seasonal patterns and waves of infection
- Vaccination rollout timeline and effectiveness

### Demographic Insights
- Population-adjusted infection and death rates
- Geographic distribution of pandemic impact
- Vaccination coverage by region

## 📋 Prerequisites

- Microsoft SQL Server 2019 or later
- SQL Server Management Studio (SSMS) or Azure Data Studio
- COVID-19 datasets (CovidDeaths and CovidVaccinations tables)

## 🗃️ Data Sources

The analysis uses two primary datasets:

1. **CovidDeaths Table**: Contains daily COVID-19 case and death data by country
   - Location, Date, Total Cases, New Cases, Total Deaths, Population
   
2. **CovidVaccinations Table**: Contains vaccination progress data
   - Location, Date, New Vaccinations, Total Vaccinations

*Note: Data sourced from reputable organizations tracking COVID-19 statistics globally*

## 🚀 Getting Started

### Database Setup

1. **Create Database**
   ```sql
   CREATE DATABASE PortfolioProject;
   USE PortfolioProject;
   ```

2. **Import Data Tables**
   - Import `CovidDeaths` and `CovidVaccinations` tables into your database
   - Ensure proper data types and relationships are established

3. **Execute Analysis**
   ```sql
   -- Run the complete analysis script
   EXEC xp_cmdshell 'sqlcmd -S your_server -d PortfolioProject -i covid_data_exploration.sql'
   ```

### Running Individual Queries

The SQL script is organized into sections for modular execution:

```sql
-- Section 1: Initial Data Exploration
-- Section 2: Death Rate Analysis  
-- Section 3: Infection Rate Analysis
-- Section 4: Mortality Analysis by Country
-- Section 5: Continental Analysis
-- Section 6: Global Statistics
-- Section 7: Vaccination Analysis
-- Section 8: Advanced Calculations using CTE
-- Section 9: Temporary Table Approach
-- Section 10: View Creation for Visualization
```

## 📈 Sample Queries and Results

### Death Rate Analysis
```sql
-- Calculate death percentage by country
SELECT 
    Location, 
    date, 
    total_cases,
    total_deaths, 
    (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1, 2;
```

### Vaccination Progress Tracking
```sql
-- Rolling vaccination count with CTE
WITH PopvsVac AS (
    SELECT 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(CONVERT(INT,vac.new_vaccinations)) OVER (
            PARTITION BY dea.Location 
            ORDER BY dea.Date
        ) AS RollingPeopleVaccinated
    FROM CovidDeaths dea
    JOIN CovidVaccinations vac ON dea.location = vac.location
)
SELECT *, (RollingPeopleVaccinated/Population)*100 AS VaccinationPercentage
FROM PopvsVac;
```

## 📁 Project Structure

```
COVID-Portfolio-Project.sql/
├── covid_data_exploration.sql    # Main analysis script
├── README.md                     # Project documentation
├── LICENSE                       # MIT License
└── docs/                        # Additional documentation
    ├── data_dictionary.md       # Data structure documentation
    └── insights_summary.md      # Key findings summary
```

## 🔍 Analysis Highlights

### Most Affected Countries
The analysis identifies countries with the highest infection and death rates, both in absolute numbers and relative to population size.

### Vaccination Effectiveness
Tracking vaccination rollout progress and its correlation with infection rate reduction across different regions.

### Temporal Patterns
Identifying waves of infection, seasonal patterns, and the impact of public health interventions.

## 📊 Visualization Ready

The project creates views and structured outputs that can be easily connected to visualization tools:

- **Tableau**: Direct connection to SQL Server views
- **Power BI**: Import data from generated views
- **Excel**: Export query results for pivot table analysis
- **Python/R**: Connect to database for advanced statistical analysis

## 🤝 Contributing

Contributions are welcome! Areas for enhancement include:

- Additional statistical analysis techniques
- Integration with more recent COVID-19 data
- Expansion to include economic impact data
- Advanced predictive modeling queries

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-analysis`)
3. Add your SQL queries with proper documentation
4. Test your queries with sample data
5. Submit a pull request with detailed description

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Mazen Ibrahim**
- GitHub: [@Mazenibrahem1](https://github.com/Mazenibrahem1)
- LinkedIn: [Connect with me](https://linkedin.com/in/mazen-ibrahim)

## 🙏 Acknowledgments

- COVID-19 data providers and health organizations worldwide
- Microsoft SQL Server documentation and community
- Open source data analysis community for inspiration and best practices

## 📚 Learning Resources

For those interested in learning the SQL techniques used in this project:

- [Microsoft SQL Server Documentation](https://docs.microsoft.com/en-us/sql/)
- [Window Functions Tutorial](https://docs.microsoft.com/en-us/sql/t-sql/queries/select-over-clause-transact-sql)
- [Common Table Expressions Guide](https://docs.microsoft.com/en-us/sql/t-sql/queries/with-common-table-expression-transact-sql)

---

*This project serves as a demonstration of SQL data analysis capabilities and provides insights into one of the most significant global health events of the 21st century.*

