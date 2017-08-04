---function to get new visits per health worker
CREATE OR REPLACE FUNCTION get_newVisits(integer) RETURNS integer AS $$
   SELECT COALESCE(count(health_worker_id), 0)::integer
	FROM vw_surveys 
		WHERE (survey_status = 0) AND (health_worker_id = $1);
$$ LANGUAGE SQL; 

---function to get followups per health worker
CREATE OR REPLACE FUNCTION get_followups(integer) RETURNS integer AS $$
   SELECT COALESCE(count(health_worker_id), 0)::integer
	FROM vw_surveys 
		WHERE (survey_status = 4) AND (health_worker_id = $1);
$$ LANGUAGE SQL; 