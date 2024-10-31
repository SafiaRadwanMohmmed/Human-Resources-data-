select * from [HR]

------------ create column age --------
alter table [HR]
add age int
 update [HR]
 set age = DATEDIFF(year,birthdate,GETDATE())

 select min(age),max(age) from [HR]

  --------save data 
 begin transaction

 
   update  [HR] 
set termdate= case when termdate is not null then termdate
  else  '0000-00-00'
  end

  alter table [HR]
  add term varchar(10)

  update [HR]
  set term =CONVERT (varchar(10) ,termdate,105)
 
 alter table [HR]
 alter column term date

 ----------------analysis--------

 --------What is the gender breakdown of employees in the company?

 select gender ,count (gender)as count  from [HR]
 where termdate = '0000-00-00' or GETDATE()<=term
 group by gender 
 order by COUNT(gender)desc


  ---What is the race breakdown of employees in the company?
select race,COUNT(*) as count  from [HR] 
 where termdate = '0000-00-00' or GETDATE()<=term
group by race order by COUNT(race) DESC


---What is the age distribution of employees in the company?
select-- gender,
     case 
	 when age >=20 and age <=24 then '20-24'
	 when age >=25 and age <=34 then '25-34'
	 when age >=35 and age <=44 then '35-44'
	 when age >=45 and age <=54 then '45-54'
	 when age >=55 and age <=64 then '55-64'
	 else '65+'
	 end as age_group ,count (*)as count 
	 from [HR]
	 where termdate ='0000-00-00' or GETDATE()<=term
	 group by-- gender,
	 case 
	 when age >=20 and age <=24 then '20-24'
	 when age >=25 and age <=34 then '25-34'
	 when age >=35 and age <=44 then '35-44'
	 when age >=45 and age <=54 then '45-54'
	 when age >=55 and age <=64 then '55-64'
	 else '65+'
	 end 
	 
	 order by age_group --,gender

	  ----- How many employees work at headquater versus remote location?
	  
	  select location ,count (*) as count from [HR] 
	   where termdate ='0000-00-00' or GETDATE()<=term
	  group by location
	  --------------------

----------- what average length of employees who have been terminated?

	select avg(DATEDIFF(YEAR,hire_date,term)) as avg_length_employment from [HR] 
	where termdate <> '0000-00-00' and term <= GETDATE()

	-------- How does the gender distribution vary across departments ?
	 select department,gender,count(* ) as count  from [HR]
	  where termdate ='0000-00-00' or GETDATE()<=term
	 group by gender,  department 
	 order by department

	 ---------- what is the distribution of jop title in the company?

	 	 select jobtitle,gender,count(* ) as count  from [HR]
	  where termdate ='0000-00-00' or GETDATE()<=term
	 group by gender,  jobtitle 
	 order by jobtitle desc

	 --------------which department has the highest turnover rate?
		 select department ,
		 Total_count ,
		 terminat_count,
		round( ( cast(terminat_count as float(2))/cast(Total_count as float(2) )),3) as terminat_rat  from
		 (select department, 
		 count(*) as Total_count ,
		 sum(case when  term <>'0000-00-00' and term <=GETDATE() then 1 else 0 end) as terminat_count
		 from [HR] 
		 group by department 
		 ) as supquery
		 order by terminat_rat desc

		 ---- what the distribution of employees across location by state ?

		 select location_state, count(*) as count from [HR]
		 where termdate ='0000-00-00' or GETDATE()<=term
		 group by location_state
		 order by count desc
		 
		 -------how has the company's employee count changed over time  basd on hire and term date?
		 select year , hires ,terminates , (hires- terminates) as net_change,round( ( (hires- terminates)/cast(hires as float)*100),2) as net_change_precent
		 from
	     ( select year(hire_date) as year , 
		  count(*) as hires,
		    sum (case when  termdate <>'0000-00-00' and  GETDATE()>=term then 1 else 0 end) as terminates
		  from [HR]
		   group by year(hire_date)
		  ) as supquery
		  order by year asc

		  ------what is the tenure distribution of each department?

		   select department, avg(DATEDIFF(YEAR,hire_date ,term)) as avg_tenure
		   from [HR]
           where termdate <>'0000-00-00' and GETDATE()>=term
		   group by department
		   order by department

		   -----------
				




