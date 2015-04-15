SELECT *
FROM sms_queue
WHERE (send_results = 'SVC0901')
ORDER BY sms_queue_id


UPDATE sms SET folder_id = 0, sent = false
WHERE (sms_id IN 
(SELECT sms_id
FROM sms_queue
WHERE (send_results = 'SVC0901')
ORDER BY sms_queue_id));


DELETE FROM sms_queue
WHERE (send_results = 'SVC0901');



