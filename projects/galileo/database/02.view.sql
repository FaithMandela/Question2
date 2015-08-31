-------------------------------------- Users
CREATE OR REPLACE FUNCTION getUserGroupID() RETURNS integer AS $$
	SELECT UserGroupID FROM users WHERE (username = current_user);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getUserEmail(int) RETURNS varchar(120) AS $$
	SELECT email FROM users WHERE (userid = $1);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getUserFullName(integer) RETURNS varchar AS $$
	SELECT FullName FROM users WHERE (userid = $1);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getGroupID() RETURNS integer AS $$
DECLARE
    userrec RECORD;
	groupid integer;
BEGIN
	groupid := -1;
	SELECT INTO userrec groupleader, usergroupid FROM users WHERE (username=current_user);
	IF userrec.groupleader = true THEN
		groupid := userrec.usergroupid;
	END IF;

	return groupid;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION changePass(varchar(12), varchar(12)) RETURNS varchar(50) AS $$
DECLARE
    userrec RECORD;
	username varchar(50);
BEGIN
	username := '';
	SELECT INTO userrec * FROM Users WHERE (UserID=getUserID());

	IF userrec.userpass = md5($1) THEN
		UPDATE Users SET userpass = md5($2) WHERE (UserID=getUserID());
		username := current_user;
	END IF;

	return username;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION changePass(varchar(12), varchar(12), varchar(12)) RETURNS varchar(120) AS $$
DECLARE
    userrec RECORD;
	passchange varchar(50);
BEGIN
	passchange := 'Password Error';
	SELECT INTO userrec * FROM Users WHERE (UserID = $1);

	IF userrec.userpass = md5($2) THEN
		UPDATE Users SET userpass = md5($3) WHERE (UserID = $1);
		passchange := 'Password Changed';
	END IF;

	return passchange;
END;
$$ LANGUAGE plpgsql;

CREATE VIEW UserView AS
	SELECT UserGroups.UserGroupid, UserGroups.UserGroupName, Users.UserID, Users.SuperUser,
		Users.RoleName, Users.username, Users.FullName, Users.Extension, Users.TelNo,
		Users.EMail, Users.AccountManager, Users.GroupLeader, Users.IsActive, Users.GroupUser
	FROM UserGroups INNER JOIN Users ON UserGroups.UserGroupid = Users.UserGroupid
	ORDER BY UserGroups.UserGroupName, Users.UserName;

---------------------------------------------------- Clients

CREATE OR REPLACE FUNCTION getAccountManager(integer) RETURNS integer AS $$
	SELECT userid FROM Clients WHERE (clientid = $1);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getMainPcc(int) RETURNS varchar(12) AS $$
	SELECT max(pcc) FROM pccs WHERE (ClientID = $1) AND (gds = 'G') ;
$$ LANGUAGE SQL;

CREATE VIEW tomcatusers AS 
	(SELECT username, userpass, rolename FROM users)
	UNION
	(SELECT getMainPcc(clientid), Clientpass, 'agency' FROM clients)
	UNION
	(SELECT (getMainPcc(clients.clientid) || Consultants.SON), Consultants.agentpass, 'agent'
	FROM Clients INNER JOIN Consultants ON Clients.ClientID = Consultants.ClientID);

CREATE VIEW ClientGroupView AS
	SELECT ClientAffiliates.ClientAffiliateName, ClientGroups.ClientGroupID, ClientGroups.ClientAffiliateID, ClientGroups.ClientGroupName
	FROM ClientAffiliates INNER JOIN ClientGroups ON ClientAffiliates.ClientAffiliateID = ClientGroups.ClientAffiliateID;

CREATE VIEW ClientView AS
	SELECT ClientGroupView.ClientAffiliateID, ClientGroupView.ClientAffiliateName, ClientGroupView.ClientGroupID, ClientGroupView.ClientGroupName,
 		Users.UserID, Users.FullName, ClientSystems.ClientSystemID, ClientSystems.ClientSystemName, ClientLinks.ClientLinkID, ClientLinks.ClientLinkName,
		Clients.ClientID, Clients.ClientName, Clients.Address, Clients.ZipCode, Clients.Premises, Clients.Street, Clients.Division,
		Clients.Town, Clients.Country, Clients.TelNo, Clients.FaxNo, Clients.Email, Clients.website, Clients.IATANo, Clients.IsIATA,
		Clients.clienttarget, Clients.consultanttarget, Clients.budget, Clients.DateEnroled, Clients.Connected, Clients.IsActive,
		Clients.contractdate, Clients.contractend, Clients.DateClosed, 
		getMainPcc(Clients.ClientID) as PCC, substring(Clients.clientname, '.') as aid
	FROM ((((ClientGroupView INNER JOIN Clients ON ClientGroupView.ClientGroupID = Clients.ClientGroupID)
		INNER JOIN Users ON Clients.UserID = Users.UserID)
		INNER JOIN ClientSystems ON Clients.ClientSystemID = ClientSystems.ClientSystemID)
		INNER JOIN ClientLinks ON Clients.ClientLinkID = ClientLinks.ClientLinkID);

CREATE VIEW ClientAList AS
	SELECT aid
	FROM clientview
	GROUP BY aid
	ORDER BY aid;

CREATE VIEW ClientTownView AS
	SELECT Town
	FROM clientview
	GROUP BY town
	ORDER BY town;

CREATE VIEW pccview AS
	SELECT clients.clientid, clients.clientname, pccs.pcc, pccs.gds, pccs.pccdate
	FROM pccs INNER JOIN clients ON pccs.clientid = clients.clientid;

CREATE VIEW ConsultantView AS
	SELECT Clients.ClientID, Clients.ClientName, Consultants.ConsultantID, Consultants.salutation, Consultants.firstname, Consultants.othernames,
		(COALESCE(Consultants.salutation || ', ', '')  || COALESCE(Consultants.firstname, '') || COALESCE(', ' || Consultants.othernames, '')) as consultantname,
		Consultants.JobDefination, Consultants.TelNo, Consultants.cellphone, Consultants.Email,
		Consultants.birthdate, Consultants.SON
	FROM Clients INNER JOIN Consultants ON Clients.ClientID = Consultants.ClientID;

CREATE OR REPLACE FUNCTION getGroupMin(integer, integer) RETURNS integer AS $$
	SELECT CASE WHEN max(target) is null THEN 1 ELSE max(target) + 1 END FROM GroupTargets WHERE (ClientGroupID = $1) AND (target < $2);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getAffiliateMin(integer, integer) RETURNS integer AS $$
	SELECT CASE WHEN max(target) is null THEN 1 ELSE max(target) + 1 END FROM AffiliateTargets WHERE (ClientAffiliateID = $1) AND (target < $2);
$$ LANGUAGE SQL;

CREATE VIEW AffiliateTargetView AS
	SELECT ClientAffiliates.ClientAffiliateName, ClientAffiliates.ClientAffiliateID,
		AffiliateTargets.AffiliateTargetID, AffiliateTargets.target, AffiliateTargets.marketratio,
		AffiliateTargets.costvariance, AffiliateTargets.amount, AffiliateTargets.narrative,
		getAffiliateMin(ClientAffiliates.ClientAffiliateID, target) as mintarget
	FROM ClientAffiliates INNER JOIN AffiliateTargets ON ClientAffiliates.ClientAffiliateID = AffiliateTargets.ClientAffiliateID;

CREATE VIEW GroupTargetView AS    
	SELECT ClientGroupView.ClientAffiliateID, ClientGroupView.ClientAffiliateName, ClientGroupView.ClientGroupID, ClientGroupView.ClientGroupName,  
		GroupTargets.GroupTargetID, GroupTargets.target, GroupTargets.marketratio, GroupTargets.costvariance, GroupTargets.amount, GroupTargets.narrative,
		getGroupMin(GroupTargets.ClientGroupID, target) as mintarget
	FROM ClientGroupView INNER JOIN GroupTargets ON ClientGroupView.ClientGroupID = GroupTargets.ClientGroupID;   

CREATE VIEW TargetAffilView AS
	SELECT ClientAffiliateID, getAffiliateMin(ClientAffiliateID, target) as mintarget, target, marketratio, costvariance, amount
	FROM AffiliateTargets;

CREATE VIEW TargetView AS
	(SELECT ClientGroupID, getGroupMin(ClientGroupID, target) as mintarget, target, marketratio, costvariance, amount
	FROM GroupTargets)
	UNION
	(SELECT ClientGroupID, getAffiliateMin(ClientGroups.ClientAffiliateID, target) as mintarget, target, marketratio, costvariance, amount
	FROM AffiliateTargets CROSS JOIN ClientGroups
	WHERE ClientGroups.ClientAffiliateID = AffiliateTargets.ClientAffiliateID);

---------------------------------------------------- helpdesk

CREATE OR REPLACE FUNCTION getWorkHours(timestamp, timestamp) RETURNS float AS $$
    DECLARE
		startdate date;
        lastdate date;
		fordays integer;
		curtime timestamp;

		workdays float := 0;
		dayhours float;
		workhours float;

		i integer;
    BEGIN
		if($1 is null) then
			startdate := current_date;
		else
			startdate := $1;
		end if;

		if($2 is null) then
			lastdate := current_date;
		else
			lastdate := $2;
		end if;

		fordays := lastdate - startdate - 2;

		if($1 is null) then
			curtime := localtimestamp;
		else
			curtime := $1;
		end if;

		if (extract(dow from curtime)=6) then
			dayhours := 13 - (extract(hour from curtime) + extract(minute from curtime)/60);
		else
			dayhours := 17 - (extract(hour from curtime) + extract(minute from curtime)/60);
		end if;

		if (dayhours<0) then
			dayhours := 0;
		elseif (extract(dow from curtime)=6) and (dayhours>5) then
			dayhours := 5;
		elseif (extract(dow from curtime)>0) and (dayhours>9) then
			dayhours := 9;
		elseif (extract(dow from curtime)=0) then
			dayhours := 0;
		end if;
		workhours := dayhours;

		for i in 0..fordays loop
			curtime := curtime + interval '1 day';

			if (extract(dow from curtime)=6) then
				workdays := workdays + 0.5;
			elseif (extract(dow from curtime)>0) then
				workdays := workdays + 1;
			end if;
		end loop;

		if($2 is null) then
			curtime := localtimestamp;
		else
			curtime := $2;
		end if;

		dayhours := (extract(hour from curtime) + extract(minute from curtime)/60) - 8;

		if (dayhours<0) then
			dayhours := 0;
		elseif (extract(dow from curtime)=6) and (dayhours>5) then
			dayhours := 5;
		elseif (extract(dow from curtime)>0) and (dayhours>9) then
			dayhours := 9;
		elseif (extract(dow from curtime)=0) then
			dayhours := 0;
		end if;

		workhours := workhours + dayhours;
		workhours := workhours + (workdays * 9);

		if (startdate = lastdate) then
			if (extract(dow from curtime)=6) then
				workhours := workhours - 5;
			elseif (extract(dow from curtime)>0) then
				workhours := workhours - 9;
			end if;
			if (workhours<0) then
				workhours := 0;
			end if;
		end if;

        RETURN workhours;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getDependent(integer) RETURNS boolean AS $$
    DECLARE
		isDependent boolean := false;
		myrec RECORD;
		myview RECORD;
    BEGIN
		SELECT INTO myrec * FROM forwarded WHERE forwardid = $1;

	    FOR myview IN SELECT * FROM forwarded WHERE (problemlogid = myrec.problemlogid) and (stageorder < myrec.stageorder) LOOP
			IF (myview.issolved = false) THEN
				isDependent := true;
			END IF;
	    END LOOP;

		IF (myrec.isDependent=false) THEN
			isDependent := false;
		END IF;
				
        RETURN isDependent;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getLastTime(integer) RETURNS TimeStamp AS $$
    DECLARE
		lasttime TimeStamp;
		mystageorder integer;
		isDependent boolean;
		myrec RECORD;
		myview RECORD;
    BEGIN
		SELECT INTO myrec * FROM forwarded WHERE forwardid = $1;
		mystageorder := myrec.stageorder - 1;
		isDependent := getDependent($1);

		SELECT INTO myview * FROM forwarded WHERE (problemlogid=myrec.problemlogid) and (stageorder=mystageorder) ORDER BY SolvedTime;
		IF NOT FOUND THEN
			lasttime := myrec.ForwardTime;
		ELSEIF myview.SolvedTime is null THEN
			lasttime := localtimestamp;
			IF isDependent = false THEN
				lasttime := myview.ForwardTime;
			END IF;
		ELSE
			lasttime := myview.SolvedTime;
		END IF;
				
        RETURN lasttime;
    END;
$$ LANGUAGE plpgsql;

CREATE VIEW PTypeView AS
	SELECT PClassifications.PClassificationID, PClassifications.PClassificationName, PTypes.PTypeID, PTypes.PTypeName, PTypes.Description
	FROM (PClassifications INNER JOIN PTypes ON PClassifications.PClassificationID = PTypes.PClassificationID)
	ORDER BY PClassifications.PClassificationName, PTypes.PTypeName;

CREATE VIEW PDefinitionview AS
	SELECT PClassifications.PClassificationID, PClassifications.PClassificationName, PTypes.PTypeID, PTypes.PTypeName,
		PDefinitions.PDefinitionID, PDefinitions.PDefinitionName, PDefinitions.Description, PDefinitions.Solution
	FROM (PClassifications INNER JOIN PTypes ON PClassifications.PClassificationID = PTypes.PClassificationID)
		INNER JOIN PDefinitions ON PTypes.PTypeID = PDefinitions.PTypeID
	ORDER BY PClassifications.PClassificationName, PTypes.PTypeName;

CREATE VIEW stageview AS
	SELECT Users.UserID, Users.FullName, stages.StageID, stages.PDefinitionID, stages.TimeInterval, 
		stages.StageOrder, stages.isDependent, stages.Task
	FROM Users INNER JOIN Stages ON Users.UserID = Stages.UserID
	ORDER BY stages.StageOrder;

CREATE VIEW definestageview AS
	SELECT PDefinitionview.PClassificationid, PDefinitionview.PClassificationName, PDefinitionview.PTypeid, PDefinitionview.PTypeName,
		PDefinitionview.PDefinitionid, PDefinitionview.PDefinitionName, stageview.stageid,
		stageview.FullName, stageview.TimeInterval, stageview.StageOrder, stageview.isDependent, stageview.Task
	FROM PDefinitionview INNER JOIN stageview ON PDefinitionview.PDefinitionID = stageview.PDefinitionID
	ORDER BY PDefinitionview.PClassificationName, PDefinitionview.PTypeName, PDefinitionview.PDefinitionName, stageview.StageOrder;

CREATE OR REPLACE FUNCTION getProblemDrop(integer) RETURNS bigint AS $$
	SELECT count(ForwardID)
	FROM Forwarded 
	WHERE (ProblemLogID = $1) AND (IsDrop = true);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getProblemOpen(integer) RETURNS bigint AS $$
	SELECT count(ForwardID)
	FROM Forwarded 
	WHERE (ProblemLogID = $1) AND (IsSolved = false);
$$ LANGUAGE SQL;

CREATE VIEW ProblemLogView AS
	SELECT PDefinitionview.PClassificationID, PDefinitionview.PClassificationName, PDefinitionview.PTypeID,
		PDefinitionview.PTypeName, PDefinitionview.PDefinitionID, PDefinitionview.PDefinitionName,
		Clients.ClientID, Clients.ClientName, Users.UserGroupID, Users.UserID, Users.FullName, Users.Email,
		PLevels.PLevelID, PLevels.PLevelName, PLevels.PlevelRatio,
		ProblemLog.ProblemLogID, ProblemLog.Description, ProblemLog.ReportedBy, 
		ProblemLog.RecodedTime, ProblemLog.IsSolved, ProblemLog.SolvedTime, ProblemLog.CurrAction, 
		ProblemLog.CurrStatus, ProblemLog.problem, ProblemLog.solution,
		ProblemLog.ClosedBy, getUserFullName(ProblemLog.ClosedBy) as closedbyname,
		getWorkHours(ProblemLog.RecodedTime, ProblemLog.SolvedTime) as WorkHours,
		getWorkHours(ProblemLog.RecodedTime, ProblemLog.SolvedTime) / 9 as WorkDays,
		getProblemDrop(ProblemLog.ProblemLogID) as ProblemDrop,
		getProblemOpen(ProblemLog.ProblemLogID) as ProblemOpen
	FROM (((PDefinitionview INNER JOIN ProblemLog ON PDefinitionview.PDefinitionID = ProblemLog.PDefinitionID) 
		INNER JOIN Clients ON ProblemLog.ClientID = Clients.ClientID)
		INNER JOIN Users ON ProblemLog.UserID = Users.UserID)
		INNER JOIN PLevels ON ProblemLog.PlevelID = PLevels.PLevelID;

CREATE VIEW ForwardedView AS
	SELECT Users.UserGroupID, Users.userid, Users.UserName, Users.FullName, Users.EMail, Forwarded.ForwardID, 
		Forwarded.SenderID, getUserFullName(Forwarded.SenderID) as SenderName, Forwarded.ProblemLogID,
		Forwarded.ReferenceNo, Forwarded.StageOrder, Forwarded.IsDependent, Forwarded.isDelayedAction,
		Forwarded.Description, Forwarded.ForwardTime, Forwarded.SolvedTime, Forwarded.IsSolved, Forwarded.IsDrop,
		Forwarded.TimeInterval,	Forwarded.LastEscalation, Forwarded.tobedone, Forwarded.whatisdone,
		getDependent(Forwarded.ForwardID) as dependent, getLastTime(Forwarded.ForwardID) as lasttime,
		getWorkHours(Forwarded.ForwardTime, Forwarded.SolvedTime) as ForwardHours,
		getWorkHours(getLastTime(Forwarded.ForwardID), Forwarded.SolvedTime) as EscalationHours
	FROM Users INNER JOIN Forwarded ON Users.UserID = Forwarded.UserID
	ORDER BY Forwarded.StageOrder;

CREATE VIEW ProblemForwardView AS
	SELECT ProblemLogView.PClassificationID, ProblemLogView.PClassificationName, ProblemLogView.PTypeID, ProblemLogView.PTypeName,
		ProblemLogView.PDefinitionID, ProblemLogView.PDefinitionName, ProblemLogView.ClientID, ProblemLogView.ClientName,
		ProblemLogView.UserGroupID, ProblemLogView.UserID, ProblemLogView.FullName, ProblemLogView.Email, 
		ProblemLogView.PLevelID, ProblemLogView.PLevelName,
		ProblemLogView.PlevelRatio,	ProblemLogView.ProblemLogID,  ProblemLogView.Description,
		ProblemLogView.ReportedBy, ProblemLogView.RecodedTime, ProblemLogView.IsSolved, ProblemLogView.SolvedTime, ProblemLogView.CurrAction,
		ProblemLogView.CurrStatus, ProblemLogView.problem, ProblemLogView.solution, ProblemLogView.WorkHours,
		ProblemLogView.WorkDays, ProblemLogView.ClosedBy, ProblemLogView.closedbyname,
		ForwardedView.UserGroupID as fdgroupid, ForwardedView.userid as fduserid, ForwardedView.UserName as fdusername, 
		ForwardedView.FullName as fdfullname, ForwardedView.EMail as fdemail, ForwardedView.ForwardID, 
		ForwardedView.SenderID, ForwardedView.SenderName, ForwardedView.isDelayedAction,
		ForwardedView.ReferenceNo, ForwardedView.StageOrder, ForwardedView.IsDependent,
		ForwardedView.Description as fdDescription, ForwardedView.ForwardTime, ForwardedView.SolvedTime as fdSolvedTime,
		ForwardedView.IsSolved as fdsolved, ForwardedView.TimeInterval,	ForwardedView.LastEscalation, 
		ForwardedView.tobedone, ForwardedView.whatisdone, ForwardedView.dependent, ForwardedView.IsDrop,
		ForwardedView.lasttime, ForwardedView.ForwardHours, ForwardedView.EscalationHours,
		(ForwardedView.TimeInterval * ProblemLogView.PlevelRatio / 100) as EscalationTime
	FROM ProblemLogView INNER JOIN ForwardedView ON ProblemLogView.ProblemLogID = ForwardedView.ProblemLogID;

CREATE OR REPLACE FUNCTION getCountERF(integer) RETURNS bigint AS $$
	SELECT count(ERFID)
	FROM ERF
	WHERE ProblemLogID = $1;
$$ LANGUAGE SQL;

CREATE VIEW EsclationForwardView AS
	SELECT ProblemForwardView.PClassificationID, ProblemForwardView.PClassificationName, ProblemForwardView.PTypeID, 
		ProblemForwardView.PTypeName, ProblemForwardView.PDefinitionID, ProblemForwardView.PDefinitionName,
		ProblemForwardView.ClientID, ProblemForwardView.ClientName, ProblemForwardView.UserGroupID, ProblemForwardView.UserID,
		ProblemForwardView.FullName, ProblemForwardView.Email, ProblemForwardView.PLevelID, ProblemForwardView.PLevelName, 
		ProblemForwardView.PlevelRatio,	ProblemForwardView.ProblemLogID, ProblemForwardView.Description, ProblemForwardView.ReportedBy, 
		ProblemForwardView.RecodedTime, ProblemForwardView.IsSolved, ProblemForwardView.SolvedTime, ProblemForwardView.CurrAction, 
		ProblemForwardView.CurrStatus, ProblemForwardView.problem, ProblemForwardView.solution,
		ProblemForwardView.fduserid, ProblemForwardView.fdgroupid, ProblemForwardView.fdusername, 
		ProblemForwardView.fdfullname, ProblemForwardView.ForwardID, ProblemForwardView.fdEMail, 
		ProblemForwardView.SenderID, ProblemForwardView.SenderName, ProblemForwardView.isDelayedAction,
		ProblemForwardView.ReferenceNo, ProblemForwardView.StageOrder, ProblemForwardView.IsDependent,
		ProblemForwardView.fdDescription, ProblemForwardView.ForwardTime, ProblemForwardView.fdSolvedTime, 
		ProblemForwardView.fdsolved, ProblemForwardView.TimeInterval, ProblemForwardView.LastEscalation, 
		ProblemForwardView.tobedone, ProblemForwardView.whatisdone, ProblemForwardView.EscalationTime,
		ProblemForwardView.WorkHours, ProblemForwardView.dependent, ProblemForwardView.IsDrop,
		ProblemForwardView.lasttime, ProblemForwardView.ForwardHours, ProblemForwardView.EscalationHours,		
		(ProblemForwardView.fdFullName || ' <' || ProblemForwardView.fdemail || '>') as emailaddress,
		('CRM : ' || ProblemLogID || ' : ' || ProblemForwardView.ClientName || ' : ' || ProblemForwardView.PClassificationName) as emailsubject,
		getCountERF(ProblemForwardView.ProblemLogID) as counterf
	FROM ProblemForwardView
	WHERE (ProblemForwardView.IsSolved = false) AND (ProblemForwardView.fdSolved = false) AND (ProblemForwardView.IsDrop = false) AND (ProblemForwardView.dependent = false)
	AND ((ProblemForwardView.LastEscalation is null) OR (getWorkHours(ProblemForwardView.LastEscalation, LOCALTIMESTAMP)>ProblemForwardView.TimeInterval));

CREATE OR REPLACE FUNCTION insForward() RETURNS TRIGGER AS $$
DECLARE
    myrecord RECORD;
BEGIN
	FOR myrecord IN SELECT * FROM Stages WHERE Stages.PDefinitionID = NEW.PDefinitionID LOOP
		INSERT INTO Forwarded (ProblemLogID, UserID, Description, StageOrder, isDependent, isDelayedAction, TimeInterval, SystemForward, IsForApproval)
		VALUES(NEW.ProblemLogID, myrecord.UserID, myrecord.task, myrecord.StageOrder, myrecord.isDependent,
			myrecord.isDelayedAction, myrecord.TimeInterval, true, myrecord.IsForApproval); 
	END LOOP;

	IF (NEW.PLevelID is null) THEN
		UPDATE ProblemLog SET PLevelID = 2 WHERE ProblemLogid = NEW.ProblemLogid;
	END IF;
	
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insForward AFTER INSERT ON ProblemLog
    FOR EACH ROW EXECUTE PROCEDURE insForward();

CREATE OR REPLACE FUNCTION updForward() RETURNS trigger AS $$
BEGIN
	-- Check that forward is closed
	IF (OLD.IsSolved=false) and (NEW.IsSolved = True) THEN
		UPDATE Forwarded SET SolvedTime = now() WHERE ForwardID=NEW.ForwardID;
	END IF;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER updForward AFTER UPDATE ON Forwarded
    FOR EACH ROW EXECUTE PROCEDURE updForward();

CREATE OR REPLACE FUNCTION updProblemLog() RETURNS trigger AS $$
BEGIN
	-- Check that forward is closed
	IF (OLD.IsSolved=false) and (NEW.IsSolved = True) THEN
		UPDATE ProblemLog SET SolvedTime = now() WHERE ProblemLogID=NEW.ProblemLogID;
		UPDATE ProblemLog SET ClosedBy = getUserID() WHERE ProblemLogID=NEW.ProblemLogID;
	END IF;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER updProblemLog AFTER UPDATE ON ProblemLog
    FOR EACH ROW EXECUTE PROCEDURE updProblemLog();

CREATE OR REPLACE FUNCTION updEscalation(integer) RETURNS timestamp AS $$
    UPDATE Forwarded SET LastEscalation = now() WHERE ForwardID = $1;
    SELECT LastEscalation FROM Forwarded WHERE ForwardID = $1;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION updCloseForwarded(text, integer) RETURNS varchar(250) AS $$
	UPDATE Forwarded SET whatisdone=$1, SolvedTime=now(), IsSolved=true WHERE Forwardid=$2;
	SELECT varchar 'Escalated Problem Ticket is closed' as myreply;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION updDropForwarded(text, integer) RETURNS varchar(250) AS $$
	UPDATE Forwarded SET whatisdone=$1, SolvedTime=now(), IsDrop = true WHERE Forwardid=$2;
	SELECT varchar 'Escalated Problem Ticket is Droppped' as myreply;
$$ LANGUAGE SQL;

----------------------------------------------- Field Support

CREATE VIEW WorkScheduleView AS
	SELECT Users.UserID, Users.FullName, worktypes.worktypeid, worktypes.worktypename,
		WorkSchedule.WorkScheduleID, WorkSchedule.WorkDate, WorkSchedule.narrative,
		WorkSchedule.HoursSpent, WorkSchedule.IsDone, WorkSchedule.Details
	FROM (worktypes INNER JOIN WorkSchedule ON worktypes.worktypeid = WorkSchedule.worktypeid)
		INNER JOIN Users ON WorkSchedule.UserID = Users.UserID;

CREATE VIEW FieldSupportView AS
	SELECT Clients.ClientName, Users.FullName, FieldSupport.FieldSupportID, FieldSupport.UserID, FieldSupport.ClientID,
		FieldSupport.SupportDate, FieldSupport.Reason, FieldSupport.HoursSpent, FieldSupport.timeIn, 
		FieldSupport.IsDone, FieldSupport.IsDrop, FieldSupport.IsForAction, ActionDone
	FROM (Clients INNER JOIN FieldSupport ON Clients.ClientID = FieldSupport.ClientID)
		INNER JOIN Users ON Users.UserID = FieldSupport.UserID;
	
CREATE VIEW TransportView AS
	SELECT Cars.CarName, Users.FullName, Transport.TransportID, Transport.CarID, Transport.UserID, Transport.TransportDate, 
		Transport.booktime,	Transport.timeGone, Transport.Location, Transport.IsDone, Transport.IsApproved,
		(Transport.booktime + cast(('0 ' || Transport.timegone || ':00') as interval)) as bookreturn,
		Transport.ReturnTime, Transport.HoursSpent, Transport.keysreturned, Transport.taxi,
		Transport.personalcar, Transport.SelfDriven, Transport.IsDrop
	FROM (Users INNER JOIN Transport ON Users.UserID = Transport.UserID)
		LEFT JOIN Cars on Cars.CarID = Transport.CarID;
		
CREATE VIEW CarServiceView AS
	SELECT Cars.CarID, Cars.CarName, Cars.NextService, CarServices.CarServiceID, CarServices.ServiceDate,
		CarServices.problems, CarServices.replacements
	FROM Cars INNER JOIN CarServices ON Cars.CarID = CarServices.CarID;

CREATE OR REPLACE FUNCTION getcaravailable(integer, date, time, time) RETURNS bigint AS $$
	SELECT count(transportid) FROM TransportView
	WHERE (carid=$1) AND (TransportDate=$2)
	AND (((booktime, bookreturn) OVERLAPS ($3, $4))=true)
 	AND (IsApproved=true);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getcarbooked(integer, date, time, time) RETURNS varchar(50) AS $$
	SELECT max(fullname) FROM TransportView
	WHERE (carid=$1) AND (TransportDate=$2)
	AND (((booktime, bookreturn) OVERLAPS ($3, $4))=true);
$$ LANGUAGE SQL;

CREATE VIEW hourview AS
	SELECT CAST((generate_series || ':00') AS time) as hourvalue FROM generate_series(8,17);

CREATE VIEW dayview AS
	SELECT (date '2004-01-01' + generate_series) as dayvalue FROM generate_series(0, 3000);

CREATE VIEW calendarview AS
	SELECT dayview.dayvalue, hourview.hourvalue FROM dayview CROSS JOIN hourview;

CREATE VIEW calendarcar AS
	SELECT cars.carid, cars.carname, calendarview.dayvalue, calendarview.hourvalue,
		getcaravailable(cars.carid, calendarview.dayvalue, calendarview.hourvalue, calendarview.hourvalue + interval '1 hour') as carsapproved,
		getcarbooked(cars.carid, calendarview.dayvalue, calendarview.hourvalue, calendarview.hourvalue + interval '1 hour') as carsbooked
	FROM cars CROSS JOIN calendarview;

---------------------------------------- Assets

CREATE VIEW AssetSubTypeView AS
	SELECT AssetTypes.AssetTypeID, AssetTypes.AssetTypeName, AssetSubTypes.AssetSubTypeID, AssetSubTypes.AssetSubTypeName,
		AssetSubTypes.ClientCost, AssetSubTypes.segments
	FROM AssetTypes INNER JOIN AssetSubTypes ON AssetTypes.AssetTypeID = AssetSubTypes.AssetTypeID;

CREATE OR REPLACE FUNCTION getClientAsset(integer) RETURNS bigint AS $$
	SELECT count(assetid) FROM ClientAssets 
	WHERE (assetid = $1) AND (IsIssued = true) AND (IsRetrived = false);
$$ LANGUAGE SQL;

CREATE VIEW AssetsView AS
	SELECT AssetTypes.AssetTypeID, AssetTypes.AssetTypeName,
		AssetSubTypes.AssetSubTypeID, AssetSubTypes.AssetSubTypeName, AssetSubTypes.Clientcost, AssetSubTypes.segments,
		Assets.AssetID, Assets.AssetSN, Assets.IsInStore, Assets.Purchasedate, Assets.IsOnLease, Assets.PurchaseCost, 
		Assets.MonthlyCost, Assets.MonthlyMaintenance, Assets.Condition, Assets.WarrantyPeriod,
		Assets.SingularItem, Assets.sold, Assets.Saledate, Assets.saleamount, Assets.soldto, Assets.lost,
		getClientAsset(Assets.AssetID) as ClientAssetCount,
		(Purchasedate + CAST(WarrantyPeriod || ' month' AS interval)) as WarrantyEnd 
	FROM (AssetTypes INNER JOIN AssetSubTypes ON AssetTypes.AssetTypeID = AssetSubTypes.AssetTypeID)
		INNER JOIN Assets ON AssetSubTypes.AssetSubTypeID = Assets.AssetSubTypeID;

CREATE VIEW DuplicateSNView AS
	SELECT AssetSubTypeID, AssetSubTypeName, assetsn, count(assetid)
	FROM AssetsView
	WHERE (SingularItem=true)
	GROUP BY AssetSubTypeID, AssetSubTypeName, assetsn
	HAVING count(assetid)>1;

CREATE VIEW ClientAssetView AS
	SELECT AssetsView.AssetTypeID, AssetsView.AssetTypeName, AssetsView.AssetSubTypeID, AssetsView.AssetSubTypeName, 
		AssetsView.Clientcost, AssetsView.segments, AssetsView.AssetSN, AssetsView.lost,
		AssetsView.IsInStore, AssetsView.Purchasedate, AssetsView.IsOnLease, AssetsView.PurchaseCost,
		AssetsView.WarrantyPeriod, AssetsView.SingularItem, AssetsView.ClientAssetCount, AssetsView.WarrantyEnd, 
		ClientGroups.ClientGroupid, ClientGroups.ClientGroupname, Clients.clientid, Clients.ClientName, 
		ClientAssets.ClientAssetID, ClientAssets.AssetID, ClientAssets.IsIssued, 
		ClientAssets.dateIssued, ClientAssets.IsRetrived, ClientAssets.dateRetrived, ClientAssets.Narrative,
		ClientAssets.crmrefno, ClientAssets.dnoteno, ClientAssets.rcrmrefno, ClientAssets.rdnoteno, ClientAssets.units,
		(AssetsView.Clientcost * ClientAssets.units) as assetcost, (AssetsView.segments * ClientAssets.units) as assetsegments
	FROM (AssetsView INNER JOIN ClientAssets ON AssetsView.AssetID = ClientAssets.AssetID)
	INNER JOIN (Clients INNER JOIN ClientGroups ON Clients.ClientGroupid = ClientGroups.ClientGroupid)
		ON Clients.ClientID = ClientAssets.ClientID;

CREATE VIEW clientassetcount AS
	SELECT clientid, clientname, assetsubtypeid, assetsubtypename, sum(units) as totalunits, 
		sum(assetcost) as totalcost, sum(assetsegments) as totalsegments
	FROM ClientAssetView
	WHERE (IsIssued = true) AND (IsRetrived = false)
	GROUP BY clientid, clientname, assetsubtypeid, assetsubtypename
	ORDER BY clientname;

CREATE VIEW groupassetcount AS
	SELECT clientgroupid, clientgroupname, assetsubtypeid, assetsubtypename, sum(units) as totalunits, 
		sum(assetcost) as totalcost, sum(assetsegments) as totalsegments
	FROM ClientAssetView
	WHERE (IsIssued = true) AND (IsRetrived = false)
	GROUP BY clientgroupid, clientgroupname, assetsubtypeid, assetsubtypename
	ORDER BY clientgroupname;

CREATE VIEW clientassetcost AS
	SELECT clientid, clientname, sum(assetcost) as totalcost, sum(assetsegments) as totalsegments
	FROM ClientAssetView
	WHERE (IsIssued = true) AND (IsRetrived = false)
	GROUP BY clientid, clientname
	ORDER BY clientname;

CREATE OR REPLACE FUNCTION getClientCPU(integer, date) RETURNS bigint AS $$
	SELECT count(Assets.assetsn) FROM ClientAssets INNER JOIN Assets ON ClientAssets.Assetid = Assets.Assetid
	WHERE (ClientAssets.clientid = $1) AND (Assets.assetsubtypeid = 1) AND (ClientAssets.IsIssued = true)
		AND (ClientAssets.dateIssued <= $2+14)
		AND ((ClientAssets.dateRetrived IS NULL) OR (ClientAssets.dateRetrived >= $2+14));
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getClientCPU(integer) RETURNS bigint AS $$
	SELECT count(Assets.assetsn) FROM ClientAssets INNER JOIN Assets ON ClientAssets.Assetid = Assets.Assetid
	WHERE (ClientAssets.clientid = $1) AND (Assets.assetsubtypeid = 1) AND (ClientAssets.IsIssued = true)
		AND (ClientAssets.isretrived = false);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getClientInternet(integer) RETURNS varchar(50) AS $$
	SELECT max(AssetSubTypes.AssetSubTypeName) 
	FROM (ClientAssets INNER JOIN Assets ON ClientAssets.Assetid = Assets.Assetid)
		INNER JOIN AssetSubTypes ON Assets.AssetSubTypeid = AssetSubTypes.AssetSubTypeid
	WHERE (ClientAssets.clientid = $1) AND (AssetSubTypes.assettypeid = 10) AND (ClientAssets.IsIssued = true)
		AND (ClientAssets.isretrived = false);
$$ LANGUAGE SQL;
	
CREATE VIEW PCConfigurationView AS
	SELECT Clients.ClientName, PCConfiguration.PCConfigurationID, PCConfiguration.ClientID, PCConfiguration.CPUSN,
		PCConfiguration.FPNET, PCConfiguration.FPConfig, PCConfiguration.ISP, PCConfiguration.Orderdate,
		PCConfiguration.ConfigNumber, PCConfiguration.IPAddress, PCConfiguration.SubnetMask, PCConfiguration.GIClientID,
		PCConfiguration.IWSGTID, PCConfiguration.Printer1GTID, PCConfiguration.Printer2GTID
	FROM Clients INNER JOIN PCConfiguration ON Clients.ClientID = PCConfiguration.ClientID;

CREATE VIEW ERFView AS
	SELECT Users.UserID, Users.FullName, AssetSubTypes.AssetSubTypeID, AssetSubTypes.AssetSubTypeName,
		AssetSubTypes.ClientCost, AssetSubTypes.segments, 
		ERF.ERFID, ERF.ProblemLogID, ERF.Replacement, ERF.Quantity,
		(CASE WHEN ERF.Replacement = false THEN (ERF.Quantity * AssetSubTypes.ClientCost) ELSE 0 END) as erfcost, 
		(CASE WHEN ERF.Replacement = false THEN (ERF.Quantity * AssetSubTypes.segments) ELSE 0 END) as erfsegments 
	FROM (Users INNER JOIN ERF ON Users.UserID = ERF.UserID)
	INNER JOIN AssetSubTypes ON AssetSubTypes.AssetSubTypeID = ERF.AssetSubTypeID;

CREATE VIEW ForwardERFView AS
	SELECT ForwardedView.UserGroupID, ForwardedView.userid, ForwardedView.UserName, ForwardedView.FullName, 
		ForwardedView.ForwardID, ForwardedView.ProblemLogID, ForwardedView.ReferenceNo, ForwardedView.StageOrder,
		ForwardedView.IsDependent, ForwardedView.Description, ForwardedView.ForwardTime, ForwardedView.SolvedTime,
		ForwardedView.IsSolved, ERFView.FullName AS RequestedBy, ERFView.AssetSubTypeID, ERFView.AssetSubTypeName,
		ERFView.ClientCost, ERFView.segments, ERFView.ERFID, ERFView.Quantity, ERFView.erfcost, ERFView.erfsegments
	FROM ForwardedView INNER JOIN ERFView ON ForwardedView.ProblemLogID = ERFView.ProblemLogID;

CREATE VIEW vw_client_assets AS
	SELECT AssetsView.assettypeid, AssetsView.assettypename, AssetsView.assetsubtypeid, 
		AssetsView.assetsubtypename, AssetsView.assetsn,
		AssetsView.assetid, AssetsView.purchasedate, AssetsView.isonlease, 
		(CASE WHEN AssetsView.sold = false THEN clients.clientname
		ELSE 'SOLD - ' || clients.clientname END) as clientname
	FROM (AssetsView INNER JOIN ClientAssets ON AssetsView.AssetID = ClientAssets.AssetID)
		INNER JOIN Clients ON Clients.ClientID = ClientAssets.ClientID
	WHERE (AssetsView.singularitem = true) AND (ClientAssets.isissued = true) AND (ClientAssets.isretrived = false)
		AND (AssetsView.lost = false)
	ORDER BY AssetsView.assettypename, AssetsView.assetsubtypename, AssetsView.purchasedate;

--------------------------------- Accounts
CREATE OR REPLACE FUNCTION getkqquarter(timestamp) RETURNS integer AS $$
    DECLARE
		kqquarter integer := 0;
    BEGIN
		kqquarter := trunc((date_part('month', $1)-1)/3);
		if (kqquarter=0) then
			kqquarter := 4;
		end if;
				
        RETURN kqquarter;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getPrevPeriod(date) RETURNS integer AS $$
	SELECT max(periodid) FROM periods 
	WHERE (extract(year from startdate) = (extract(year from $1)-1)) 
		AND (extract(month from startdate) = extract(month from $1));
$$ LANGUAGE SQL;

CREATE VIEW PeriodView AS
	SELECT Periods.PeriodID, Periods.AccountPeriod, Periods.Startdate, date_part('month', startdate) as monthid,
	to_char(Periods.startdate, 'YYYY') as periodyear, to_char(Periods.startdate, 'Month') as periodmonth,
	(trunc((date_part('month', startdate)-1)/3)+1) as quarter, getkqquarter(startdate) as kqquarter,
	(trunc((date_part('month', startdate)-1)/6)+1) as semister, getPrevPeriod(Periods.Startdate) as PrevPeriod,
	Periods.NASRate, Periods.CANCRates, Periods.TPRate, Periods.TARAte, Periods.IncentiveRate, Periods.CompetitionCost, Periods.BudgetRate
	FROM Periods
	ORDER BY Periods.Startdate;

CREATE VIEW PeriodYearView AS
	SELECT periodyear
	FROM PeriodView
	GROUP BY periodyear
	ORDER BY periodyear;

CREATE VIEW AccountPeriodView AS
	SELECT AccountPeriod
	FROM PeriodView
	GROUP BY AccountPeriod
	ORDER BY AccountPeriod;

CREATE VIEW PeriodquarterView AS
	SELECT quarter
	FROM PeriodView
	GROUP BY quarter
	ORDER BY quarter;

CREATE VIEW PeriodsemisterView AS
	SELECT semister
	FROM PeriodView
	GROUP BY semister
	ORDER BY semister;

CREATE VIEW PeriodMonthView AS
	SELECT monthid, periodmonth
	FROM PeriodView
	GROUP BY monthid, periodmonth
	ORDER BY monthid, periodmonth;

CREATE OR REPLACE FUNCTION insPeriodAssetCosts() RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO PeriodAssetCosts (AssetSubTypeID, PeriodID, ClientCost, segments)
	SELECT AssetSubTypeID, NEW.PeriodID, ClientCost, segments
	FROM AssetSubTypes;
	
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insPeriodAssetCosts AFTER INSERT ON periods
    FOR EACH ROW EXECUTE PROCEDURE insPeriodAssetCosts();

CREATE VIEW periodassetcostview AS
	SELECT assetsubtypeview.assettypeid, assetsubtypeview.assettypename, assetsubtypeview.assetsubtypeid, assetsubtypeview.assetsubtypename,
		periodview.periodid, periodview.accountperiod, periodview.startdate, periodview.monthid, periodview.periodyear, periodview.periodmonth,
		periodassetcosts.periodassetcostid, periodassetcosts.clientcost, periodassetcosts.segments
	FROM (periodassetcosts INNER JOIN assetsubtypeview ON periodassetcosts.assetsubtypeid = assetsubtypeview.assetsubtypeid)
		INNER JOIN periodview ON periodassetcosts.periodid = periodview.periodid;

CREATE VIEW vw_assets_costing AS
	SELECT clientview.clientgroupid, clientview.clientgroupname, clientview.clientid, clientview.clientname,
		assets.AssetSN, ClientAssets.dateIssued, ClientAssets.dateRetrived, ClientAssets.dateadded, ClientAssets.datechanged, ClientAssets.units,
		assetsubtypeview.assettypeid, assetsubtypeview.assettypename, assetsubtypeview.assetsubtypeid, assetsubtypeview.assetsubtypename,
		periodview.periodid, periodview.accountperiod, periodview.startdate, periodview.monthid, periodview.periodyear, periodview.periodmonth,
		periodassetcosts.periodassetcostid, periodassetcosts.clientcost, periodassetcosts.segments,
		(periodassetcosts.clientcost * ClientAssets.units) as t_clientcost, 
		(periodassetcosts.segments * ClientAssets.units) as t_segments
	FROM (periodassetcosts INNER JOIN assetsubtypeview ON periodassetcosts.assetsubtypeid = assetsubtypeview.assetsubtypeid)
		INNER JOIN Assets ON periodassetcosts.AssetSubTypeID = Assets.AssetSubTypeID
		INNER JOIN periodview ON periodassetcosts.periodid = periodview.periodid
		INNER JOIN ClientAssets ON Assets.Assetid = ClientAssets.Assetid
		INNER JOIN clientview ON ClientAssets.clientid = clientview.clientid
	WHERE (ClientAssets.IsIssued = true) AND (ClientAssets.dateIssued <= periodview.startdate + 14) 
		AND ((ClientAssets.dateRetrived IS NULL) OR (ClientAssets.dateRetrived >= periodview.startdate + 14));

CREATE VIEW vw_assets_changes AS
	SELECT clientview.clientgroupid, clientview.clientgroupname, clientview.clientid, clientview.clientname,
		assets.AssetSN, ClientAssets.dateIssued, ClientAssets.dateRetrived, ClientAssets.dateadded, ClientAssets.datechanged,
		assetsubtypeview.assettypeid, assetsubtypeview.assettypename, assetsubtypeview.assetsubtypeid, assetsubtypeview.assetsubtypename,
		periodview.periodid, periodview.accountperiod, periodview.startdate, periodview.monthid, periodview.periodyear, periodview.periodmonth,
		periodassetcosts.periodassetcostid, periodassetcosts.clientcost, periodassetcosts.segments,
		(periodassetcosts.clientcost * ClientAssets.units) as t_clientcost, 
		(periodassetcosts.segments * ClientAssets.units) as t_segments
	FROM (periodassetcosts INNER JOIN assetsubtypeview ON periodassetcosts.assetsubtypeid = assetsubtypeview.assetsubtypeid)
		INNER JOIN Assets ON periodassetcosts.AssetSubTypeID = Assets.AssetSubTypeID
		INNER JOIN periodview ON periodassetcosts.periodid = periodview.periodid
		INNER JOIN ClientAssets ON Assets.Assetid = ClientAssets.Assetid
		INNER JOIN clientview ON ClientAssets.clientid = clientview.clientid
	WHERE (ClientAssets.IsIssued = true) AND (ClientAssets.dateadded <= periodview.startdate + 14) 
		AND ((ClientAssets.datechanged IS NULL) OR (ClientAssets.datechanged >= periodview.startdate + 14));

CREATE OR REPLACE FUNCTION getClientCost(integer, integer, date) RETURNS float AS $$
    DECLARE
		clientcost float;
		myrec RECORD;
    BEGIN
		SELECT INTO myrec sum(periodassetcosts.segments * ClientAssets.units) as sumsegments
			FROM ((periodassetcosts INNER JOIN Assets ON periodassetcosts.AssetSubTypeID = Assets.AssetSubTypeID) 
				INNER JOIN ClientAssets ON ClientAssets.Assetid = Assets.Assetid) 
			WHERE (ClientAssets.clientid = $1) AND (periodassetcosts.periodid = $2) AND (ClientAssets.IsIssued = true) 
			AND (ClientAssets.dateIssued <= $3 + 14) 
			AND ((ClientAssets.dateRetrived IS NULL) OR (ClientAssets.dateRetrived >= $3 + 14));

		clientcost := myrec.sumsegments;
		IF (clientcost is null) THEN
			clientcost := 0;
		END IF;
				
        RETURN clientcost;
    END;
$$ LANGUAGE plpgsql;

CREATE VIEW MIDTTransactionView AS
	SELECT periodview.periodid, periodview.accountperiod, periodview.startdate, periodview.monthid, periodview.periodyear, periodview.periodmonth, periodview.quarter, periodview.kqquarter, 
		clients.clientid, clients.clientname, midttransactions.midttransactionid, midttransactions.crs, midttransactions.pcc, midttransactions.agency, midttransactions.prd
	FROM (midttransactions INNER JOIN periodview ON midttransactions.periodid = periodview.periodid)
		LEFT JOIN clients ON midttransactions.clientid = clients.clientid;

CREATE VIEW CompetitionView AS
	SELECT periodview.periodid, periodview.accountperiod, periodview.startdate, periodview.monthid, periodview.periodyear, periodview.periodmonth, periodview.quarter, periodview.kqquarter, 
		midttransactions.crs, sum(midttransactions.prd) as sumprd
	FROM (midttransactions INNER JOIN periodview ON midttransactions.periodid = periodview.periodid)
	GROUP BY periodview.periodid, periodview.accountperiod, periodview.startdate, periodview.monthid, periodview.periodyear, periodview.periodmonth, periodview.quarter, periodview.kqquarter,
		midttransactions.crs;

CREATE OR REPLACE FUNCTION getsegs(int, int, varchar(2)) RETURNS real AS $$
	SELECT CASE WHEN sum(prd) is null THEN 0 ELSE sum(prd) END
	FROM MIDTTransactions WHERE (ClientID = $1) AND (PeriodID = $2) AND (CRS = $3);
$$ LANGUAGE SQL;

CREATE VIEW TransClientView AS
	SELECT ClientAffiliates.ClientAffiliateID, ClientAffiliates.ClientAffiliateName, ClientGroups.ClientGroupID, ClientGroups.ClientGroupName,
		Users.UserID, Users.FullName, Clients.ClientID, Clients.ClientName, Clients.ClientSystemID, Clients.ClientLinkID,
		Clients.TelNo, Clients.Address, Clients.ZipCode, Clients.Town, Clients.Country, Clients.IsIATA
	FROM (ClientAffiliates INNER JOIN ClientGroups ON ClientAffiliates.ClientAffiliateID = ClientGroups.ClientAffiliateID)
		INNER JOIN (Clients INNER JOIN Users ON Clients.userid = Users.Userid) ON ClientGroups.ClientGroupID = Clients.ClientGroupID;

CREATE OR REPLACE FUNCTION getPrevSegs(int, int) RETURNS bigint AS $$
	SELECT sum(nasegs) 
	FROM Transactions
	WHERE (clientid = $1) AND (PeriodID = $2);
$$ LANGUAGE SQL;

CREATE VIEW TransactionView AS
	SELECT TransClientView.ClientAffiliateID, TransClientView.ClientAffiliateName, TransClientView.ClientGroupID, TransClientView.ClientGroupName,
		TransClientView.UserID, TransClientView.FullName, TransClientView.ClientID, TransClientView.ClientName, 
		TransClientView.ClientSystemID, TransClientView.ClientLinkID, TransClientView.IsIATA, 
		TransClientView.TelNo, TransClientView.Address, TransClientView.ZipCode, TransClientView.Town, TransClientView.Country,				
		PeriodView.PeriodID, PeriodView.AccountPeriod, PeriodView.Startdate, PeriodView.monthid, PeriodView.periodyear,
		PeriodView.periodmonth, PeriodView.quarter, PeriodView.kqquarter, PeriodView.semister, PeriodView.PrevPeriod, PeriodView.BudgetRate,
		PeriodView.NASRate, PeriodView.CANCRates, PeriodView.TPRate, PeriodView.TARate, PeriodView.IncentiveRate, PeriodView.CompetitionCost,
		Transactions.TransactionID, Transactions.PCC, 
		getsegs(Transactions.clientid, Transactions.periodid, 'M') as AmadeousSegs, 
		getsegs(Transactions.clientid, Transactions.periodid, 'W') as WorldSpanSegs,
		Transactions.NASegs, Transactions.NPSegs, Transactions.NFASegs, Transactions.NBBSegs, Transactions.NRSegs,
		Transactions.BCT, Transactions.AOTSegs, Transactions.PTSegs, Transactions.Narrative, 
		Transactions.eticket, Transactions.pticket, (Transactions.eticket + Transactions.pticket) as tickets,
		getClientCost(TransClientView.ClientID, PeriodView.PeriodID, PeriodView.Startdate) as clientcost,
		getClientCPU(TransClientView.ClientID, PeriodView.Startdate) as clientcpus,
		getPrevSegs(Transactions.Clientid, PeriodView.PrevPeriod) as prevsegs
	FROM (TransClientView INNER JOIN Transactions ON TransClientView.ClientID = Transactions.ClientID)
		INNER JOIN PeriodView ON Transactions.PeriodID = PeriodView.PeriodID
	ORDER BY PeriodView.Startdate;

CREATE VIEW ClientCostView AS
	SELECT ClientAffiliateID, ClientAffiliateName, ClientGroupID, ClientGroupName, ClientID, ClientName, UserID, FullName,
		ClientSystemID, ClientLinkID, TelNo, Address, ZipCode, Town, Country, IsIATA, 
		PeriodID, AccountPeriod, Startdate, monthid, periodyear, periodmonth, quarter, kqquarter, semister, PrevPeriod, BudgetRate,
		IncentiveRate, CompetitionCost, prevsegs, (prevsegs * (100 + BudgetRate) / 100) as budgetsegs,
		TransactionID, AmadeousSegs, WorldSpanSegs, NASegs, clientcost, clientcpus,
		(NASegs - clientcost) as clientbalance,		
		(CASE WHEN clientcpus = 0 THEN 0 ELSE (NASegs / clientcpus) END) as spc,
		(CASE WHEN clientcost = 0 THEN 100 ELSE 100 * ((NASegs - clientcost) / clientcost) END) as pbalance,
		(CASE WHEN (AmadeousSegs + NASegs) = 0 THEN 0 ELSE (100 * AmadeousSegs / (AmadeousSegs + NASegs)) END) as compratio
	FROM TransactionView;

CREATE VIEW ClientQuarterView AS
	SELECT ClientAffiliateID, ClientAffiliateName, ClientGroupID, ClientGroupName, ClientID, ClientName,
		ClientSystemID, ClientLinkID, UserID, FullName, periodyear, quarter, semister, 
		sum(AmadeousSegs) as SumAmadeousSegs, Sum(WorldSpanSegs) as SumWorldSpanSegs, Sum(NASegs) as SumNASegs,
		sum(clientcost) as sumclientcost, sum(NASegs - clientcost) as sumclientbalance, 
		(CASE WHEN SUM(clientcost) = 0 THEN 100 ELSE 100 * (sum(NASegs - clientcost) / sum(clientcost)) END) as pbalance,
		(CASE WHEN (SUM(AmadeousSegs) + sum(NASegs)) = 0 THEN 0 ELSE (100 * SUM(AmadeousSegs) / (SUM(AmadeousSegs) + sum(NASegs))) END) as compratio
	FROM TransactionView
	GROUP BY ClientAffiliateID, ClientAffiliateName, ClientGroupID, ClientGroupName, ClientID, ClientName,
		ClientSystemID, ClientLinkID, UserID, FullName, periodyear, quarter, semister;

CREATE VIEW ClientSemisterView AS
	SELECT ClientAffiliateID, ClientAffiliateName, ClientGroupID, ClientGroupName, ClientID, ClientName,
		ClientSystemID, ClientLinkID, UserID, FullName, periodyear, semister, 
		sum(AmadeousSegs) as SumAmadeousSegs, Sum(WorldSpanSegs) as SumWorldSpanSegs, Sum(NASegs) as SumNASegs,
		sum(clientcost) as sumclientcost, sum(NASegs - clientcost) as sumclientbalance, 
		(CASE WHEN SUM(clientcost) = 0 THEN 100 ELSE 100 *(sum(NASegs - clientcost) / sum(clientcost)) END) as pbalance,
		(CASE WHEN (SUM(AmadeousSegs) + sum(NASegs)) = 0 THEN 0 ELSE (100 * SUM(AmadeousSegs) / (SUM(AmadeousSegs) + sum(NASegs))) END) as compratio
	FROM TransactionView
	GROUP BY ClientAffiliateID, ClientAffiliateName, ClientGroupID, ClientGroupName, ClientID, ClientName,
		ClientSystemID, ClientLinkID, UserID, FullName, periodyear, semister;

CREATE VIEW ClientYearView AS
	SELECT ClientAffiliateID, ClientAffiliateName, ClientGroupID, ClientGroupName, ClientID, ClientName,
		ClientSystemID, ClientLinkID, UserID, FullName, periodyear, 
		sum(AmadeousSegs) as SumAmadeousSegs, Sum(WorldSpanSegs) as SumWorldSpanSegs, Sum(NASegs) as sumNASegs,
		sum(clientcost) as sumclientcost, sum(NASegs - clientcost) as sumclientbalance, 
		(CASE WHEN SUM(clientcost)=0 THEN 100 ELSE 100 *(sum(NASegs - clientcost) / sum(clientcost)) END) as pbalance,
		(CASE WHEN (SUM(AmadeousSegs) + sum(NASegs)) = 0 THEN 0 ELSE (100 * SUM(AmadeousSegs) / (SUM(AmadeousSegs) + sum(NASegs))) END) as compratio
	FROM TransactionView
	GROUP BY ClientAffiliateID, ClientAffiliateName, ClientGroupID, ClientGroupName, ClientID, ClientName,
		ClientSystemID, ClientLinkID, UserID, FullName, periodyear;

CREATE VIEW ClientAccYearView AS
	SELECT ClientAffiliateID, ClientAffiliateName, ClientGroupID, ClientGroupName, ClientID, ClientName,
		ClientSystemID, ClientLinkID, UserID, FullName, AccountPeriod, 
		sum(AmadeousSegs) as SumAmadeousSegs, Sum(WorldSpanSegs) as SumWorldSpanSegs, Sum(NASegs) as sumNASegs,
		sum(clientcost) as sumclientcost, sum(NASegs - clientcost) as sumclientbalance, 
		(CASE WHEN SUM(clientcost) = 0 THEN 100 ELSE 100 *(sum(NASegs - clientcost) / sum(clientcost)) END) as pbalance,
		(CASE WHEN (SUM(AmadeousSegs) + sum(NASegs)) = 0 THEN 0 ELSE (100 * SUM(AmadeousSegs) / (SUM(AmadeousSegs) + sum(NASegs))) END) as compratio
	FROM TransactionView
	GROUP BY ClientAffiliateID, ClientAffiliateName, ClientGroupID, ClientGroupName, ClientID, ClientName,
		ClientSystemID, ClientLinkID, UserID, FullName, AccountPeriod;

CREATE OR REPLACE VIEW GroupCostView AS
	(SELECT FullName, ClientID, ClientName, PeriodID, AccountPeriod, Startdate, monthid, periodyear, periodmonth, quarter, kqquarter, semister,
		IncentiveRate, CompetitionCost,	AmadeousSegs, WorldSpanSegs, NASegs, 
		clientcost, (NASegs - clientcost) as clientbalance, clientcpus,
		(CASE WHEN clientcost = 0 THEN 100 ELSE 100 *((NASegs - clientcost) / clientcost) END) as pbalance,
		(CASE WHEN (AmadeousSegs + NASegs) = 0 THEN 0 ELSE (100 * AmadeousSegs / (AmadeousSegs + NASegs)) END) as compratio
	FROM TransactionView
	WHERE (ClientGroupID=0))
	UNION
	(SELECT FullName, ClientGroupID, ClientGroupName, PeriodID, AccountPeriod, Startdate, monthid, periodyear, periodmonth, quarter, kqquarter, semister,
		IncentiveRate, CompetitionCost,
		sum(AmadeousSegs) as AmadeousSegs, sum(WorldSpanSegs) as WorldSpanSegs, sum(NASegs) as NASegs,
		sum(clientcost) as clientcost, sum(NASegs - clientcost) as clientbalance, sum(clientcpus) as clientcpus,
		(CASE WHEN SUM(clientcost)=0 THEN 100 ELSE 100 *(sum((NASegs - clientcost)) / sum(clientcost)) END) as pbalance,
		(CASE WHEN SUM(AmadeousSegs + NASegs) = 0 THEN 0 ELSE 100 * SUM(AmadeousSegs) / SUM(AmadeousSegs + NASegs) END) as compratio
	FROM TransactionView
	WHERE (ClientGroupID<>0)
	GROUP BY FullName, ClientGroupID, ClientGroupName, PeriodID, AccountPeriod, Startdate, monthid, periodyear, periodmonth, quarter, kqquarter, semister, IncentiveRate, CompetitionCost);

CREATE OR REPLACE VIEW vw_accmanagersegs AS
	(SELECT FullName, ClientID, ClientName, PeriodID, AccountPeriod, Startdate, monthid, periodyear, periodmonth, quarter, kqquarter, semister,
		IncentiveRate, CompetitionCost,	AmadeousSegs, WorldSpanSegs, NASegs, 
		clientcost, (NASegs - clientcost) as clientbalance, clientcpus,
		(CASE WHEN clientcost = 0 THEN 100 ELSE 100 *((NASegs - clientcost) / clientcost) END) as pbalance,
		(CASE WHEN (AmadeousSegs + NASegs) = 0 THEN 0 ELSE (100 * AmadeousSegs / (AmadeousSegs + NASegs)) END) as compratio
	FROM TransactionView
	WHERE (ClientGroupID=0))
	UNION
	(SELECT FullName, ClientGroupID, ClientGroupName, PeriodID, AccountPeriod, Startdate, monthid, periodyear, periodmonth, quarter, kqquarter, semister,
		IncentiveRate, CompetitionCost,
		sum(AmadeousSegs) as AmadeousSegs, sum(WorldSpanSegs) as WorldSpanSegs, sum(NASegs) as NASegs,
		sum(clientcost) as clientcost, sum(NASegs - clientcost) as clientbalance, sum(clientcpus) as clientcpus,
		(CASE WHEN SUM(clientcost)=0 THEN 100 ELSE 100 *(sum((NASegs - clientcost)) / sum(clientcost)) END) as pbalance,
		(CASE WHEN SUM(AmadeousSegs + NASegs) = 0 THEN 0 ELSE 100 * SUM(AmadeousSegs) / SUM(AmadeousSegs + NASegs) END) as compratio
	FROM TransactionView
	WHERE (ClientGroupID<>0)
	GROUP BY FullName, ClientGroupID, ClientGroupName, PeriodID, AccountPeriod, Startdate, monthid, periodyear, periodmonth, quarter, kqquarter, semister, IncentiveRate, CompetitionCost);

CREATE VIEW GroupQuarterView AS
	SELECT ClientID, ClientName, periodyear, quarter, semister, 
		sum(AmadeousSegs) as SumAmadeousSegs, Sum(WorldSpanSegs) as SumWorldSpanSegs, Sum(NASegs) as SumNASegs,
		sum(clientcost) as sumclientcost, sum(NASegs - clientcost) as sumclientbalance, 
		(CASE WHEN SUM(clientcost)=0 THEN 100 ELSE 100 *(sum(NASegs - clientcost) / sum(clientcost)) END) as pbalance,
		(CASE WHEN (SUM(AmadeousSegs) + sum(NASegs)) = 0 THEN 0 ELSE (100 * SUM(AmadeousSegs) / (SUM(AmadeousSegs) + sum(NASegs))) END) as compratio
	FROM GroupCostView
	GROUP BY ClientID, ClientName, periodyear, quarter, semister;

CREATE VIEW GroupSemisterView AS
	SELECT ClientID, ClientName, periodyear, semister, 
		sum(AmadeousSegs) as SumAmadeousSegs, Sum(WorldSpanSegs) as SumWorldSpanSegs, Sum(NASegs) as SumNASegs,
		sum(clientcost) as sumclientcost, sum(NASegs - clientcost) as sumclientbalance, 
		(CASE WHEN SUM(clientcost)=0 THEN 100 ELSE 100 *(sum(NASegs - clientcost) / sum(clientcost)) END) as pbalance,
		(CASE WHEN (SUM(AmadeousSegs) + sum(NASegs)) = 0 THEN 0 ELSE (100 * SUM(AmadeousSegs) / (SUM(AmadeousSegs) + sum(NASegs))) END) as compratio
	FROM GroupCostView
	GROUP BY ClientID, ClientName, periodyear, semister;

CREATE VIEW GroupYearView AS
	SELECT ClientID, ClientName, periodyear, 
		sum(AmadeousSegs) as SumAmadeousSegs, Sum(WorldSpanSegs) as SumWorldSpanSegs, Sum(NASegs) as sumNASegs,
		sum(clientcost) as sumclientcost, sum(NASegs - clientcost) as sumclientbalance,
		(CASE WHEN SUM(clientcost)=0 THEN 100 ELSE 100 *(sum(NASegs - clientcost) / sum(clientcost)) END) as pbalance,
		(CASE WHEN (SUM(AmadeousSegs) + sum(NASegs)) = 0 THEN 0 ELSE (100 * SUM(AmadeousSegs) / (SUM(AmadeousSegs) + sum(NASegs))) END) as compratio
	FROM GroupCostView
	GROUP BY ClientID, ClientName, periodyear;

CREATE VIEW GroupsCostView AS
	SELECT ClientGroupID, ClientGroupName, PeriodID, AccountPeriod, Startdate, monthid, periodyear, periodmonth, quarter, kqquarter, semister,
		sum(AmadeousSegs) as AmadeousSegs, sum(WorldSpanSegs) as WorldSpanSegs, sum(NASegs) as NASegs,
		sum(clientcost) as clientcost, sum(NASegs - clientcost) as clientbalance, 
		(CASE WHEN SUM(clientcost)=0 THEN 100 ELSE 100 *(sum((NASegs - clientcost)) / sum(clientcost)) END) as pbalance,
		(CASE WHEN (SUM(AmadeousSegs) + sum(NASegs)) = 0 THEN 0
			WHEN SUM(AmadeousSegs) < 0 THEN 0
			ELSE (100 * SUM(AmadeousSegs) / (SUM(AmadeousSegs) + sum(NASegs))) END) as compratio
	FROM TransactionView
	WHERE (ClientGroupID<>0)
	GROUP BY ClientGroupID, ClientGroupName, PeriodID, AccountPeriod, Startdate, monthid, periodyear, periodmonth, quarter, kqquarter, semister;

CREATE VIEW AffiliateCostView AS
	SELECT ClientAffiliateID, ClientAffiliateName, PeriodID, AccountPeriod, Startdate, monthid, periodyear, periodmonth, quarter, kqquarter, semister,
		sum(AmadeousSegs) as AmadeousSegs, sum(WorldSpanSegs) as WorldSpanSegs, sum(NASegs) as NASegs,
		sum(clientcost) as clientcost, sum(NASegs - clientcost) as clientbalance, 
		(CASE WHEN SUM(clientcost) = 0 THEN 100 
			WHEN SUM(AmadeousSegs) < 0 THEN 0
			ELSE 100 *(sum(NASegs - clientcost) / sum(clientcost)) END) as pbalance,
		(CASE WHEN (SUM(AmadeousSegs) + sum(NASegs)) = 0 THEN 0 ELSE (100 * SUM(AmadeousSegs) / (SUM(AmadeousSegs) + sum(NASegs))) END) as compratio
	FROM TransactionView	
	GROUP BY ClientAffiliateID, ClientAffiliateName, PeriodID, AccountPeriod, Startdate, monthid, periodyear, periodmonth, quarter, kqquarter, semister;  

CREATE VIEW ConsultantTransactionView AS
	SELECT Clients.ClientID, Clients.ClientName, ConsultantTransactions.ConsultantTransactionID, ConsultantTransactions.PeriodID, 
		ConsultantTransactions.PCC,	ConsultantTransactions.SON,	ConsultantTransactions.prd1, ConsultantTransactions.prd2, 
		ConsultantTransactions.prd3, ConsultantTransactions.modprod, ConsultantTransactions.target,
		ConsultantTransactions.Narrative
	FROM Clients INNER JOIN ConsultantTransactions ON Clients.ClientID = ConsultantTransactions.ClientID
	ORDER BY ConsultantTransactions.prd3 DESC;

CREATE OR REPLACE FUNCTION getYTD(integer, varchar(12), int) RETURNS bigint AS $$
	SELECT sum(NASegs) FROM Transactions INNER JOIN PeriodView ON Transactions.Periodid = PeriodView.Periodid
	WHERE (Transactions.clientid = $1) AND (PeriodView.AccountPeriod = $2) AND (PeriodView.kqquarter = $3);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getYTD(integer, varchar(12), date) RETURNS bigint AS $$
	SELECT sum(NASegs) FROM Transactions INNER JOIN Periods ON Transactions.Periodid = Periods.Periodid
	WHERE (Transactions.clientid = $1) AND (Periods.AccountPeriod = $2) AND (Periods.Startdate <= $3);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getYTD(integer, date) RETURNS bigint AS $$
	SELECT sum(NASegs) FROM Transactions INNER JOIN Periods ON Transactions.Periodid = Periods.Periodid
	WHERE (Transactions.clientid = $1) AND EXTRACT(YEAR FROM Periods.Startdate) = EXTRACT(YEAR FROM $2) AND (Periods.Startdate <= $2);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getMIDTYTD(varchar(12), date) RETURNS real AS $$
	SELECT sum(MIDTTransactions.prd) FROM MIDTTransactions INNER JOIN Periods ON MIDTTransactions.Periodid = Periods.Periodid
	WHERE (MIDTTransactions.pcc = $1) AND EXTRACT(YEAR FROM Periods.Startdate) = EXTRACT(YEAR FROM $2) AND (Periods.Startdate <= $2);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getCGIncentive(integer) RETURNS bigint AS $$
	SELECT count(GroupTargetID)
	FROM GroupTargets
	WHERE ClientGroupID = $1;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getGIncentive(integer, bigint) RETURNS float AS $$
	SELECT sum(amount * (CASE WHEN (target < $2) THEN 1 + target - mintarget WHEN (mintarget < $2) THEN ($2 - mintarget + 1) ELSE 0 END))
	FROM TargetView
	WHERE ClientGroupID = $1;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getTIncentive(integer, bigint) RETURNS float AS $$
	SELECT sum(amount * (CASE WHEN (target < $2) THEN 1 + target - mintarget WHEN (mintarget < $2) THEN ($2 - mintarget + 1) ELSE 0 END))
	FROM TargetAffilView
	WHERE ClientAffiliateID = $1;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getGQIncentive(integer, bigint) RETURNS float AS $$
	SELECT sum(amount * (CASE WHEN ((target / 4) < $2) THEN 1 + (target / 4) - (mintarget / 4) WHEN ((mintarget / 4) < $2) THEN ($2 - (mintarget / 4) + 1) ELSE 0 END))
	FROM TargetView
	WHERE ClientGroupID = $1;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getTQIncentive(integer, bigint) RETURNS float AS $$
	SELECT sum(amount * (CASE WHEN ((target / 4) < $2) THEN 1 + (target / 4) - (mintarget / 4) WHEN ((mintarget / 4) < $2) THEN ($2 - (mintarget / 4) + 1) ELSE 0 END))
	FROM TargetAffilView
	WHERE ClientAffiliateID = $1;
$$ LANGUAGE SQL;

CREATE VIEW QuarterTransView AS
	(SELECT ClientID, ClientName, AccountPeriod, periodyear, quarter, kqquarter,
		sum(AmadeousSegs) as AmadeousSegs, sum(WorldSpanSegs) as WorldSpanSegs, sum(NASegs) as NASegs,
		sum(clientcost) as clientcost, sum(NASegs - clientcost) as clientbalance, 
		(CASE WHEN SUM(clientcost) = 0 THEN 100 ELSE 100 *(sum(NASegs - clientcost) / sum(clientcost)) END) as pbalance,
		(100 * SUM(AmadeousSegs) / (SUM(AmadeousSegs) + sum(NASegs))) as compratio,
		sum((NASegs - clientcost) * IncentiveRate) as incentives
	FROM TransactionView
	WHERE (ClientGroupID=0)
	GROUP BY ClientID, ClientName, AccountPeriod, periodyear, quarter, kqquarter)
	UNION
	(SELECT ClientAffiliateID, ClientAffiliateName, AccountPeriod, periodyear, quarter, kqquarter,
		sum(AmadeousSegs) as AmadeousSegs, sum(WorldSpanSegs) as WorldSpanSegs, sum(NASegs) as NASegs,
		sum(clientcost) as clientcost, sum(NASegs - clientcost) as clientbalance, 
		(CASE WHEN SUM(clientcost) = 0 THEN 100 ELSE 100 *(sum(NASegs - clientcost) / sum(clientcost)) END) as pbalance,
		(100 * SUM(AmadeousSegs) / (SUM(AmadeousSegs) + sum(NASegs))) as compratio,
		getTQIncentive(ClientAffiliateID, sum(NASegs)) as incentives
	FROM TransactionView
	WHERE (ClientAffiliateID <> 0)	
	GROUP BY ClientAffiliateID, ClientAffiliateName, AccountPeriod, periodyear, quarter, kqquarter)
	UNION
	(SELECT ClientGroupID, ClientGroupName, AccountPeriod, periodyear, quarter, kqquarter,
		sum(AmadeousSegs) as AmadeousSegs, sum(WorldSpanSegs) as WorldSpanSegs, sum(NASegs) as NASegs,
		sum(clientcost) as clientcost, sum(NASegs - clientcost) as clientbalance, 
		(CASE WHEN SUM(clientcost) = 0 THEN 100 ELSE 100 *(sum(NASegs - clientcost) / sum(clientcost)) END) as pbalance,
		(100 * SUM(AmadeousSegs) / (SUM(AmadeousSegs) + sum(NASegs))) as compratio,
		(CASE WHEN getCGIncentive(ClientGroupID) = 0 THEN sum((NASegs - clientcost) * IncentiveRate) ELSE getGQIncentive(ClientGroupID, sum(NASegs)) END) as incentives
	FROM TransactionView
	WHERE (ClientGroupID <> 0) AND (ClientAffiliateID = 0)
	GROUP BY ClientGroupID, ClientGroupName, AccountPeriod, periodyear, quarter, kqquarter);  

CREATE VIEW AllTransView AS
	(SELECT ClientID, ClientName, AccountPeriod,
		sum(AmadeousSegs) as AmadeousSegs, sum(WorldSpanSegs) as WorldSpanSegs, sum(NASegs) as NASegs,
		sum(clientcost) as clientcost, sum(NASegs - clientcost) as clientbalance, 
		(CASE WHEN SUM(clientcost) = 0 THEN 100 ELSE 100 *(sum(NASegs - clientcost) / sum(clientcost)) END) as pbalance,
		(100 * SUM(AmadeousSegs) / (SUM(AmadeousSegs) + sum(NASegs))) as compratio,
		sum((NASegs - clientcost) * IncentiveRate) as incentives
	FROM TransactionView
	WHERE (ClientGroupID=0)
	GROUP BY ClientID, ClientName, AccountPeriod)
	UNION
	(SELECT ClientAffiliateID, ClientAffiliateName, AccountPeriod,
		sum(AmadeousSegs) as AmadeousSegs, sum(WorldSpanSegs) as WorldSpanSegs, sum(NASegs) as NASegs,
		sum(clientcost) as clientcost, sum(NASegs - clientcost) as clientbalance, 
		(CASE WHEN SUM(clientcost) = 0 THEN 100 ELSE 100 *(sum(NASegs - clientcost) / sum(clientcost)) END) as pbalance,
		(100 * SUM(AmadeousSegs) / (SUM(AmadeousSegs) + sum(NASegs))) as compratio,
		getTIncentive(ClientAffiliateID, sum(NASegs)) as incentives
	FROM TransactionView
	WHERE (ClientAffiliateID <> 0)	
	GROUP BY ClientAffiliateID, ClientAffiliateName, AccountPeriod)
	UNION
	(SELECT ClientGroupID, ClientGroupName, AccountPeriod,
		sum(AmadeousSegs) as AmadeousSegs, sum(WorldSpanSegs) as WorldSpanSegs, sum(NASegs) as NASegs,
		sum(clientcost) as clientcost, sum(NASegs - clientcost) as clientbalance, 
		(CASE WHEN SUM(clientcost) = 0 THEN 100 ELSE 100 *(sum(NASegs - clientcost) / sum(clientcost)) END) as pbalance,
		(100 * SUM(AmadeousSegs) / (SUM(AmadeousSegs) + sum(NASegs))) as compratio,
		(CASE WHEN getCGIncentive(ClientGroupID) = 0 THEN sum((NASegs - clientcost) * IncentiveRate) ELSE getGIncentive(ClientGroupID, sum(NASegs)) END) as incentives
	FROM TransactionView
	WHERE (ClientGroupID <> 0) AND (ClientAffiliateID = 0)
	GROUP BY ClientGroupID, ClientGroupName, AccountPeriod);  

CREATE OR REPLACE FUNCTION getgkmonthyear(date) RETURNS varchar(4) AS $$
	SELECT to_char($1, 'yy') || to_char($1, 'mm');
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getperiodid(varchar(4)) RETURNS integer AS $$
	SELECT periodid FROM periods WHERE (getgkmonthyear(startdate)=lpad($1, 4, '0'));
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getclientid(varchar(12), varchar(2)) RETURNS integer AS $$
	SELECT clientid FROM pccs WHERE (pcc = upper(trim($1))) AND (gds = upper(trim($2)));
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getTransactionid(integer, integer) RETURNS integer AS $$
	SELECT Transactionid FROM Transactions WHERE (clientid=$1) AND (periodid=$2);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getIATAclientid(varchar(12)) RETURNS integer AS $$
	SELECT clientid FROM clients WHERE (substring(iatano from 1 for 7) = upper(trim($1)));
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION insTransactions() RETURNS varchar(50) AS $$
BEGIN
	INSERT INTO Transactions (PeriodID, ClientID, PCC, UserID, Productivity, NPSegs, NASegs, NFASegs, NBBSegs, NRSegs, BCT, AOTSegs, PTSegs)
	SELECT periods.periodid, getclientid(upper(trim(pcc)), 'G'), upper(trim(pcc)), getAccountManager(getclientid(upper(trim(pcc)), 'G')),
		cast(NAAB as int), cast(NPAB as int), 0, 0, 0, 0, 0, 0, 0
	FROM new_Segments INNER JOIN periods ON new_Segments.month_year = to_char(periods.startdate, 'MMYY')
	WHERE (periods.periodid is not null) AND (getclientid(upper(trim(pcc)), 'G') is not null);

	INSERT INTO Transactions (PeriodID, ClientID, UserID, Productivity, NPSegs, NFASegs, NBBSegs, NRSegs, BCT, AOTSegs, PTSegs, NASegs)
	(SELECT periods.periodid, clients.clientid, getAccountManager(clients.clientid), 0, 0, 0, 0, 0, 0, 0, 0, 0
	FROM periods CROSS JOIN clients
	WHERE (periods.startdate > '2008-12-30') AND (clients.IsActive = true))
	EXCEPT
	(SELECT Transactions.periodid, Transactions.clientid, getAccountManager(Transactions.clientid), 0, 0, 0, 0, 0, 0, 0, 0, 0
	FROM Transactions);

	DELETE FROM new_Segments USING periods
	WHERE month_year = to_char(periods.startdate, 'MMYY')
	AND (getclientid(upper(trim(pcc)), 'G') is not null);
	
	RETURN 'Done';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insCompetitionTransactions() RETURNS varchar(50) AS $$
DECLARE
    myrecord RECORD;
	myperiodid integer;
	myclientid integer;
	mytransid integer;
BEGIN
	UPDATE MIDTSegments SET CRS = 'G' WHERE trim(CRS) = '1G';
	UPDATE MIDTSegments SET CRS = 'G' WHERE trim(CRS) = 'IG';
	UPDATE MIDTSegments SET CRS = 'M' WHERE trim(CRS) = '1A';
	UPDATE MIDTSegments SET CRS = 'S' WHERE trim(CRS) = '1S';

	FOR myrecord IN SELECT MIDTSegmentID, cast(YearMonth as varchar) as YearMonth, CRS, trim(split_part(pcc, ' ', 1)) as PCC, Agency, IATANo, cast(prd as int) as prd, Downloaddate
	FROM MIDTSegments WHERE IsUploaded = False LOOP
		myperiodid = getperiodid(myrecord.YearMonth);
		IF(upper(myrecord.CRS) = 'M') THEN
			IF(getIATAclientid(myrecord.IATANo) is null) THEN
				myclientid = getclientid(myrecord.PCC, upper(myrecord.CRS));
			ELSE
				myclientid = getIATAclientid(myrecord.IATANo);
			END IF;
		ELSE
			myclientid = getclientid(myrecord.PCC, upper(myrecord.CRS));
		END IF;
		
		INSERT INTO MIDTTransactions (ClientID, PeriodID, CRS, PCC, Agency, prd, IATANo)
		VALUES (myclientid, myperiodid, myrecord.CRS, myrecord.PCC, myrecord.Agency, myrecord.prd, myrecord.IATANo);
		UPDATE MIDTSegments SET IsUploaded = true WHERE MIDTSegmentID = myrecord.MIDTSegmentID;

		IF(upper(myrecord.CRS) = 'G') THEN
			UPDATE Transactions SET NASegs = myrecord.prd
			WHERE (ClientID = myclientid) AND (PeriodID = myperiodid) AND (pcc = myrecord.PCC);
		END IF;
	END LOOP;

	INSERT INTO Transactions (PeriodID, ClientID, UserID, Productivity, NPSegs, NFASegs, NBBSegs, NRSegs, BCT, AOTSegs, PTSegs, NASegs)
	(SELECT periods.periodid, clients.clientid, getAccountManager(clients.clientid), 0, 0, 0, 0, 0, 0, 0, 0, 0
	FROM periods CROSS JOIN clients
	WHERE (periods.startdate > '2009-12-30') AND (clients.IsActive = true))
	EXCEPT
	(SELECT Transactions.periodid, Transactions.clientid, getAccountManager(Transactions.clientid), 0, 0, 0, 0, 0, 0, 0, 0, 0
	FROM Transactions);

	UPDATE MIDTTransactions SET clientid = pccs.clientid
	FROM pccs WHERE (MIDTTransactions.pcc = pccs.pcc) AND (MIDTTransactions.clientid is null);

	DELETE FROM MIDTSegments WHERE IsUploaded = true;
	
	RETURN 'Done';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insConsultantTransactions() RETURNS varchar(50) AS $$
DECLARE
    myrecord RECORD;
	myperiodid integer;
	myclientid integer;
BEGIN
	
	FOR myrecord IN SELECT * FROM ConsultantSegments WHERE ConsultantSegments.IsUploaded = False LOOP
		myperiodid = getperiodid(myrecord.YearMonth);
		myclientid = getclientid(myrecord.PCC, 'G');

		IF (myperiodid is not null) and (myclientid is not null) THEN
			INSERT INTO ConsultantTransactions (ClientID, PeriodID, PCC, SON, prd1, prd2, prd3)
			VALUES (myclientid, myperiodid, myrecord.PCC, myrecord.SON, myrecord.prd1, myrecord.prd2, myrecord.prd3);

			UPDATE ConsultantSegments SET IsUploaded = true WHERE ConsultantSegmentID = myrecord.ConsultantSegmentID;
		END IF;
	END LOOP;

	DELETE FROM ConsultantSegments WHERE IsUploaded = true;
	
	RETURN 'Done';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insTicketedTransactions() RETURNS varchar(50) AS $$
DECLARE
    myrecord RECORD;
	myperiodid integer;
	myclientid integer;
	mytransid integer;
BEGIN
	
	FOR myrecord IN SELECT * FROM TKPSegments WHERE IsUploaded = False LOOP
		myperiodid = getperiodid(substr(myrecord.RYear, 3, 2) || myrecord.RMonth);
		myclientid = getclientid(trim(myrecord.PCC));
		mytransid = getTransactionid(myclientid, myperiodid);

		IF (mytransid is not null) THEN
			UPDATE Transactions SET eticket = myrecord.prd1, pticket = myrecord.prd5 WHERE TransactionID = mytransid;
			UPDATE TKPSegments SET IsUploaded = true WHERE TKPSegmentID = myrecord.TKPSegmentID;
		END IF;
	END LOOP;

	DELETE FROM TKPSegments WHERE IsUploaded = true;
	
	RETURN 'Done';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getnegseg(integer, integer) RETURNS bigint AS $$    
	SELECT sum(prd3) FROM ConsultantTransactions 
	WHERE (ClientID = $1) AND (PeriodID = $2) AND (prd3<0);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getairseg(integer, integer) RETURNS bigint AS $$
	SELECT sum(prd3) FROM ConsultantTransactions 
	WHERE (ClientID = $1) AND (PeriodID = $2) AND (son = '%%');
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getnaseg(integer, integer) RETURNS bigint AS $$
	SELECT sum(nasegs) FROM Transactions 
	WHERE (ClientID = $1) AND (PeriodID = $2);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION gettkpseg(integer, integer) RETURNS bigint AS $$
	SELECT sum(AOTSegs) FROM Transactions 
	WHERE (ClientID = $1) AND (PeriodID = $2);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getdistribution(integer) RETURNS float AS $$
	DECLARE
		myrec RECORD;
		negseg real;
		airseg real;
		naseg real;
		base real;
		ratio real;
		distvalue real;
	BEGIN
		SELECT INTO myrec * FROM ConsultantTransactions WHERE ConsultantTransactionID = $1;
		negseg := getnegseg(myrec.clientid, myrec.periodid);
		if (negseg is null) then negseg := 0; end if;
		airseg := getairseg(myrec.clientid, myrec.periodid);
		if (airseg is null) then airseg := 0; end if;
		naseg := getnaseg(myrec.clientid, myrec.periodid);
		if (naseg is null) then naseg := 0; end if;

		if (airseg<0) then
			negseg := negseg - airseg;
		end if;
		base := naseg - airseg - (negseg * 2);

		ratio := 0;
		if (base <> 0) then
			ratio := abs(airseg * myrec.prd3 / base);
		end if;
		if (airseg<0) then
			ratio := ratio * (-1);          
		end if;

		distvalue := 0;
		if (myrec.son <> '%%') then
			distvalue := (myrec.prd3 + ratio);
		end if;

		RETURN distvalue;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION gettkpdistribution(integer) RETURNS float AS $$
	DECLARE
		myrec RECORD;
		consseg real;   
		naseg real;
		tkpseg real;
		distvalue real;
	BEGIN
		SELECT INTO myrec * FROM ConsultantTransactions WHERE ConsultantTransactionID = $1;

		consseg := getdistribution(myrec.ConsultantTransactionid);
		naseg := getnaseg(myrec.clientid, myrec.periodid);
		if (naseg is null) then naseg := 0; end if;
		tkpseg := gettkpseg(myrec.clientid, myrec.periodid);
		if (tkpseg is null) then tkpseg := 0; end if;

		distvalue := 0;
		if (naseg <> 0) then
			distvalue := consseg * tkpseg / naseg;
		end if;
        
		RETURN distvalue;
	END;
$$ LANGUAGE plpgsql;

CREATE VIEW consdistributionview AS
	SELECT clientview.clientgroupid, clientview.clientgroupname, clientview.clientid, clientview.clientname, 
		consultanttransactions.consultanttransactionid, consultanttransactions.pcc, consultanttransactions.son, 
		consultanttransactions.prd3, consultanttransactions.periodid, 
		getdistribution(consultanttransactions.consultanttransactionid) AS distribution, 
		gettkpdistribution(consultanttransactions.consultanttransactionid) AS tkpdistribution
	FROM clientview INNER JOIN consultanttransactions ON clientview.clientid = consultanttransactions.clientid
	ORDER BY clientview.clientid;

CREATE VIEW totalproductivityview AS 
	SELECT periods.periodid, periods.startdate, sum(transactions.nasegs) AS segments, 
		sum(getClientCost(transactions.ClientID, Periods.PeriodID, Periods.Startdate)) AS cost,
		sum(transactions.nasegs - getClientCost(transactions.ClientID, Periods.PeriodID, Periods.Startdate)) AS balance
	FROM periods INNER JOIN transactions ON periods.periodid = transactions.periodid
	GROUP BY periods.periodid, periods.startdate 
	ORDER BY periods.startdate;

CREATE VIEW vw_contracts AS
	SELECT incentive_types.incentive_type_id, incentive_types.incentive_type_name, 
		ClientGroups.ClientGroupID, ClientGroups.ClientGroupName, clients.clientid, clients.clientname,
		contracts.contract_id, contracts.after_cost, contracts.market_share,
		contracts.business_volume, contracts.contract_date, contracts.contract_end,
		contracts.details
	FROM ((incentive_types INNER JOIN contracts ON incentive_types.incentive_type_id = contracts.incentive_type_id)
		LEFT JOIN ClientGroups ON contracts.ClientGroupID = ClientGroups.ClientGroupID)
		LEFT JOIN clients ON contracts.clientid = clients.clientid;

CREATE VIEW calldumpview AS
	(SELECT (cast(replace(calldate, ' ', '') as date) + 30) as newcalldate, callmarker, cast(calltime as time) as newcalltime,
		extension, callline, calldetails, 
		(cast(substring(talktime from 1 for 2) as float) * 60 + cast(substring(talktime from 4 for 2) as float) + (cast(substring(talktime from 7 for 2) as float)/60)) as newtalktime,
		callcode
	FROM calldumps
	WHERE (calldate not ilike '%date%') and (calldate not ilike '%---%'))
	EXCEPT
	(SELECT calldate, callmarker, calltime, extension, callline, calldetails, talktime, callcode
	FROM calls);

CREATE OR REPLACE FUNCTION insCalls() RETURNS varchar(50) AS $$
BEGIN
	
	INSERT INTO calls (calldate, callmarker, calltime, extension, callline, calldetails, talktime, callcode)
	(SELECT newcalldate, callmarker, newcalltime, extension, callline, calldetails, newtalktime, callcode FROM calldumpview);

	DELETE FROM calldumps;
	
	RETURN 'Done';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getincentive(integer, bigint) RETURNS float AS $$
DECLARE
    myrecord RECORD;
    incentrec RECORD;
	incentive float;
BEGIN
	incentive := 0;

	SELECT INTO incentrec sum(amount * (target - mintarget + 1) / 12) as sumamount FROM TargetView WHERE (ClientGroupID = $1) and (mintarget < ($2*12));
	SELECT INTO myrecord min(amount) as maxamount, mintarget FROM TargetView WHERE (ClientGroupID = $1) and (target >= ($2*12));

	IF (myrecord.maxamount IS NOT NULL) THEN
		incentive := incentrec.sumamount + (myrecord.maxamount * (mintarget/12 - $2));
	END IF;
	
	RETURN incentive;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insDailyTransactions() RETURNS varchar(50) AS $$
DECLARE
	myrecord RECORD;
	myperiodid integer;
	myclientid integer;
BEGIN
	
	INSERT INTO dailyTransactions (PRDDate, clientid, PCC, DailyNetSegments, MTDNetSegments, YTDNetSegments)
	SELECT cast(split_part(dailysegments.prddate, '/', 3) || '-' || split_part(dailysegments.prddate, '/', 2) || '-' || split_part(dailysegments.prddate, '/', 1) as date), 
		pccs.clientid,  dailysegments.pcc,
		cast(dailysegments.dailynetsegments as integer), cast(dailysegments.mtdnetsegments as integer),
		cast(dailysegments.ytdnetsegments as integer)
	FROM dailysegments INNER JOIN pccs ON dailysegments.pcc = pccs.pcc;

	DELETE FROM dailysegments USING pccs WHERE dailysegments.pcc = pccs.pcc;
	
	RETURN 'Done';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION getClientCost(integer) RETURNS float AS $$
	SELECT CASE WHEN (sum(AssetSubTypes.segments) is null) THEN 0 ELSE sum(AssetSubTypes.segments) END
	FROM (AssetSubTypes INNER JOIN assets ON AssetSubTypes.AssetSubTypeID = Assets.AssetSubTypeID)
		INNER JOIN ClientAssets ON assets.assetid = ClientAssets.assetid
	WHERE (ClientAssets.clientid = $1) AND (ClientAssets.IsIssued = true) AND (IsRetrived = false);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION getBudgetSegs(int, date) RETURNS double precision AS $$
	SELECT CASE WHEN sum(Transactions.nasegs) > 0 THEN sum(Transactions.nasegs * (periods.BudgetRate + 100) / 100)
		ELSE sum(Transactions.nasegs * (100 - periods.BudgetRate) / 100) END 
	FROM Transactions INNER JOIN periods ON Transactions.periodid = periods.periodid 
	WHERE (Transactions.clientid = $1) 
		AND (extract(year from startdate) = (extract(year from $2)-1)) 
		AND (extract(month from startdate) = extract(month from $2));
$$ LANGUAGE SQL;

CREATE VIEW daylistview AS
	SELECT dailytransactions.prddate
	FROM dailytransactions
	GROUP BY dailytransactions.prddate
	ORDER BY dailytransactions.prddate;

CREATE VIEW dailytransactionview AS
SELECT clientview.clientaffiliateid, clientview.clientaffiliatename, clientview.clientgroupid, clientview.clientgroupname,
	clientview.userid, clientview.fullname, clientview.clientid, clientview.clientname, dailytransactions.dailytransactionid,
	dailytransactions.prddate, dailytransactions.pcc, dailytransactions.dailynetsegments, dailytransactions.mtdnetsegments,
	dailytransactions.ytdnetsegments, getClientCost(clientview.clientid) as clientcost
FROM dailytransactions INNER JOIN clientview ON dailytransactions.clientid = clientview.clientid;

CREATE OR REPLACE FUNCTION getClientCost(integer, date, date) RETURNS float AS $$
    DECLARE
		clientcost float;
		myrec RECORD;
    BEGIN
		SELECT INTO myrec sum(periodassetcosts.segments) as sumsegments
			FROM ((periodassetcosts INNER JOIN Assets ON periodassetcosts.AssetSubTypeID = Assets.AssetSubTypeID) 
				INNER JOIN ClientAssets ON ClientAssets.Assetid = Assets.Assetid) 
			WHERE (ClientAssets.clientid = $1) AND (periodassetcosts.periodid = $2) AND (ClientAssets.IsIssued = true) 
			AND (ClientAssets.dateIssued <= $3 + 14) AND ((ClientAssets.dateRetrived IS NULL) OR (ClientAssets.dateRetrived >= $3 + 14));

		clientcost := myrec.sumsegments;
		IF (clientcost is null) THEN
			clientcost := 0;
		END IF;
				
        RETURN clientcost;
    END;
$$ LANGUAGE plpgsql;

------------------------------------------------- Training
CREATE VIEW TrainingView AS
	SELECT Users.FullName, Training.TrainingID, Training.UserID, Training.TrainingTypeID, Training.StartDate, 
		Training.StopDate, Training.IsDone, Training.Amount, TrainingTypes.TrainingTypeName
	FROM (Users INNER JOIN Training ON Users.UserID = Training.UserID)
	INNER JOIN TrainingTypes ON Training.TrainingTypeID = TrainingTypes.TrainingTypeID;

CREATE VIEW ClientTrainingView AS
	SELECT ConsultantView.ClientID, ConsultantView.ClientName, ConsultantView.consultantid, ConsultantView.consultantname, 
		ClientTraining.ClientTrainingID, ClientTraining.TrainingID,	ClientTraining.IsDone,
		ClientTraining.IsPaid, ClientTraining.IsCert, ClientTraining.IsCompleted, ClientTraining.Marks
	FROM ConsultantView INNER JOIN ClientTraining ON ConsultantView.ConsultantID = ClientTraining.ConsultantID;

CREATE VIEW ConsultantTrainingView AS
	SELECT TrainingView.FullName, TrainingView.TrainingTypeName, TrainingView.TrainingID, TrainingView.UserID,
		TrainingView.TrainingTypeID,
		TrainingView.StartDate, TrainingView.StopDate, TrainingView.IsDone as trainingdone, TrainingView.Amount,
		ClientTrainingView.ClientID, ClientTrainingView.ClientName, ClientTrainingView.consultantid, ClientTrainingView.consultantname, 
		ClientTrainingView.ClientTrainingID, ClientTrainingView.IsDone,
		ClientTrainingView.IsPaid, ClientTrainingView.IsCert, ClientTrainingView.IsCompleted, ClientTrainingView.Marks
	FROM TrainingView INNER JOIN ClientTrainingView ON TrainingView.TrainingID = ClientTrainingView.TrainingID;


--------------------------------------------------- Charity Additions

CREATE VIEW vw_transaction_cg AS
	SELECT TransClientView.ClientAffiliateID, TransClientView.ClientAffiliateName, TransClientView.ClientGroupID, TransClientView.ClientGroupName,
		TransClientView.UserID, TransClientView.FullName, TransClientView.ClientID, TransClientView.ClientName, 
		TransClientView.ClientSystemID, TransClientView.ClientLinkID, TransClientView.IsIATA, 
		TransClientView.TelNo, TransClientView.Address, TransClientView.ZipCode, TransClientView.Town, TransClientView.Country,				
		PeriodView.PeriodID, PeriodView.AccountPeriod, PeriodView.Startdate, PeriodView.monthid, PeriodView.periodyear,
		PeriodView.periodmonth, PeriodView.quarter, PeriodView.kqquarter, PeriodView.semister, PeriodView.PrevPeriod, PeriodView.BudgetRate,
		PeriodView.NASRate, PeriodView.CANCRates, PeriodView.TPRate, PeriodView.TARate, PeriodView.IncentiveRate, PeriodView.CompetitionCost,
		Transactions.TransactionID, Transactions.PCC, 
		getsegs(Transactions.clientid, Transactions.periodid, 'M') as AmadeousSegs, getsegs(Transactions.clientid, Transactions.periodid, 'W') as WorldSpanSegs,
		Transactions.NASegs, Transactions.NPSegs, Transactions.NFASegs, Transactions.NBBSegs, Transactions.NRSegs,
		Transactions.BCT, Transactions.AOTSegs, Transactions.PTSegs, Transactions.productivity, Transactions.Narrative, 
		Transactions.eticket, Transactions.pticket, (Transactions.eticket + Transactions.pticket) as tickets,
		getClientCost(TransClientView.ClientID, PeriodView.PeriodID, PeriodView.Startdate) as clientcost,
		getClientCPU(TransClientView.ClientID, PeriodView.Startdate) as clientcpus,
		getPrevSegs(Transactions.Clientid, PeriodView.PrevPeriod) as prevsegs
	FROM (TransClientView INNER JOIN Transactions ON TransClientView.ClientID = Transactions.ClientID)
		INNER JOIN PeriodView ON Transactions.PeriodID = PeriodView.PeriodID
	ORDER BY PeriodView.Startdate;

CREATE VIEW vw_clientcost_cg AS
	SELECT ClientAffiliateID, ClientAffiliateName, ClientGroupID, ClientGroupName, ClientID, ClientName, UserID, FullName,
		ClientSystemID, ClientLinkID, TelNo, Address, ZipCode, Town, Country, IsIATA, 
		PeriodID, AccountPeriod, Startdate, monthid, periodyear, periodmonth, quarter, kqquarter, semister, PrevPeriod, BudgetRate,
		IncentiveRate, CompetitionCost, prevsegs, (prevsegs * (100 + BudgetRate) / 100) as budgetsegs,
		TransactionID, AmadeousSegs, WorldSpanSegs, NASegs, productivity, clientcost, clientcpus,
		(NASegs - clientcost) as clientbalance,		
		(CASE WHEN clientcpus = 0 THEN 0 ELSE (NASegs / clientcpus) END) as spc,
		(CASE WHEN clientcost = 0 THEN 100 ELSE 100 * ((NASegs - clientcost) / clientcost) END) as pbalance,
		(CASE WHEN (AmadeousSegs + NASegs) = 0 THEN 0 ELSE (100 * AmadeousSegs / (AmadeousSegs + NASegs)) END) as compratio
	FROM vw_transaction_cg;

CREATE OR REPLACE VIEW vw_groupcost_cg AS
	(SELECT ClientID, ClientName, PeriodID, AccountPeriod, Startdate, monthid, periodyear, periodmonth, quarter, kqquarter, semister,
		IncentiveRate, CompetitionCost,	productivity, AmadeousSegs, WorldSpanSegs, NASegs, 
		clientcost, (NASegs - clientcost) as clientbalance, clientcpus,
		(CASE WHEN clientcost = 0 THEN 100 ELSE 100 *((NASegs - clientcost) / clientcost) END) as pbalance,
		(CASE WHEN (AmadeousSegs + NASegs) = 0 THEN 0 ELSE (100 * AmadeousSegs / (AmadeousSegs + NASegs)) END) as compratio
	FROM vw_transaction_cg
	WHERE (ClientGroupID=0))
	UNION
	(SELECT ClientGroupID, ClientGroupName, PeriodID, AccountPeriod, Startdate, monthid, periodyear, periodmonth, quarter, kqquarter, semister,
		IncentiveRate, CompetitionCost, sum(productivity) as productivity,
		sum(AmadeousSegs) as AmadeousSegs, sum(WorldSpanSegs) as WorldSpanSegs, sum(NASegs) as NASegs,
		sum(clientcost) as clientcost, sum(NASegs - clientcost) as clientbalance, sum(clientcpus) as clientcpus,
		(CASE WHEN SUM(clientcost)=0 THEN 100 ELSE 100 *(sum((NASegs - clientcost)) / sum(clientcost)) END) as pbalance,
		(CASE WHEN SUM(AmadeousSegs + NASegs) = 0 THEN 0 ELSE 100 * SUM(AmadeousSegs) / SUM(AmadeousSegs + NASegs) END) as compratio
	FROM vw_transaction_cg
	WHERE (ClientGroupID<>0)
	GROUP BY ClientGroupID, ClientGroupName, PeriodID, AccountPeriod, Startdate, monthid, periodyear, periodmonth, quarter, kqquarter, semister, IncentiveRate, CompetitionCost);

CREATE VIEW vw_midt_summary AS
	SELECT t_trans.periodid, t_trans.accountperiod, t_trans.startdate,
		t_trans.periodyear, t_trans.periodmonth, t_trans.t_segs, g_trans.g_segs, m_trans.m_segs,
		(t_trans.t_segs - g_trans.g_segs - m_trans.m_segs) as o_segs,
		100 * (g_trans.g_segs / t_trans.t_segs) as m_share
	FROM 
		(SELECT periods.periodid, periods.accountperiod, periods.startdate,
		to_char(Periods.startdate, 'YYYY') as periodyear, to_char(Periods.startdate, 'Month') as periodmonth,
		sum(MIDTTransactions.prd) as t_segs
		FROM periods INNER JOIN MIDTTransactions ON periods.periodid = MIDTTransactions.periodid
		GROUP BY periods.periodid, periods.accountperiod, periods.startdate,
		to_char(Periods.startdate, 'YYYY'), to_char(Periods.startdate, 'Month')
		ORDER BY periods.startdate) as t_trans
	LEFT JOIN
		(SELECT MIDTTransactions.periodid,  sum(MIDTTransactions.prd) as g_segs
		FROM MIDTTransactions 
		WHERE (MIDTTransactions.crs = 'G')
		GROUP BY MIDTTransactions.periodid) as g_trans
	ON t_trans.periodid = g_trans.periodid
	LEFT JOIN
		(SELECT MIDTTransactions.periodid,  sum(MIDTTransactions.prd) as m_segs 
		FROM MIDTTransactions 
		WHERE (MIDTTransactions.crs = 'M')
		GROUP BY MIDTTransactions.periodid) as m_trans
	ON t_trans.periodid = m_trans.periodid;


--------------------------------------------------
CREATE VIEW vw_consultanttransactions AS
	SELECT clientid, periodid, pcc, sum(prd3) as prod
	FROM consultanttransactions
	GROUP BY clientid, periodid, pcc;

CREATE VIEW vw_group_segments AS
	SELECT clients.clientgroupid, consultanttransactions.periodid, sum(consultanttransactions.prd3) as prod
	FROM consultanttransactions INNER JOIN clients ON consultanttransactions.clientid = clients.clientid
	GROUP BY clients.clientgroupid, consultanttransactions.periodid;


