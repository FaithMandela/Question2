DROP TRIGGER upd_passengers ON passengers;

CREATE TRIGGER upd_passengers  BEFORE UPDATE OF approved ON passengers
FOR EACH ROW  EXECUTE PROCEDURE upd_passengers();
