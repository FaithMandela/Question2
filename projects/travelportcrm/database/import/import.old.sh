pg_dump -a --column-inserts -t UserGroups galileo.old | psql -q galileo
pg_dump -a --column-inserts -t Users galileo.old | psql -q galileo
pg_dump -a --column-inserts -t audittrail galileo.old | psql -q galileo
pg_dump -a --column-inserts -t ClientAffiliates galileo.old | psql -q galileo
pg_dump -a --column-inserts -t ClientGroups galileo.old | psql -q galileo
pg_dump -a --column-inserts -t ClientSystems galileo.old | psql -q galileo
pg_dump -a --column-inserts -t ClientLinks galileo.old | psql -q galileo
pg_dump -a --column-inserts -t Clients galileo.old | psql -q galileo
pg_dump -a --column-inserts -t pccs galileo.old | psql -q galileo
pg_dump -a --column-inserts -t Consultants galileo.old | psql -q galileo
pg_dump -a --column-inserts -t AffiliateTargets galileo.old | psql -q galileo
pg_dump -a --column-inserts -t GroupTargets galileo.old | psql -q galileo
pg_dump -a --column-inserts -t ConsultantRewards galileo.old | psql -q galileo
pg_dump -a --column-inserts -t PClassifications galileo.old | psql -q galileo
pg_dump -a --column-inserts -t PTypes galileo.old | psql -q galileo
pg_dump -a --column-inserts -t PDefinitions galileo.old | psql -q galileo
pg_dump -a --column-inserts -t Stages galileo.old | psql -q galileo
pg_dump -a --column-inserts -t PLevels galileo.old | psql -q galileo
pg_dump -a --column-inserts -t ProblemLog galileo.old | psql -q galileo
pg_dump -a --column-inserts -t Helpdeskimages galileo.old | psql -q galileo
pg_dump -a --column-inserts -t Forwarded galileo.old | psql -q galileo
pg_dump -a --column-inserts -t worktypes galileo.old | psql -q galileo
pg_dump -a --column-inserts -t WorkSchedule galileo.old | psql -q galileo
pg_dump -a --column-inserts -t FieldSupport galileo.old | psql -q galileo
pg_dump -a --column-inserts -t Cars galileo.old | psql -q galileo
pg_dump -a --column-inserts -t CarServices galileo.old | psql -q galileo
pg_dump -a --column-inserts -t Transport galileo.old | psql -q galileo
pg_dump -a --column-inserts -t AssetTypes galileo.old | psql -q galileo
pg_dump -a --column-inserts -t AssetSubTypes galileo.old | psql -q galileo
pg_dump -a --column-inserts -t ERF galileo.old | psql -q galileo
pg_dump -a --column-inserts -t Assets galileo.old | psql -q galileo
pg_dump -a --column-inserts -t ClientAssets galileo.old | psql -q galileo
pg_dump -a --column-inserts -t PCConfiguration galileo.old | psql -q galileo
pg_dump -a --column-inserts -t Segments galileo.old | psql -q galileo
pg_dump -a --column-inserts -t ConsultantSegments galileo.old | psql -q galileo
pg_dump -a --column-inserts -t MIDTSegments galileo.old | psql -q galileo
pg_dump -a --column-inserts -t TKPSegments galileo.old | psql -q galileo
pg_dump -a --column-inserts -t Periods galileo.old | psql -q galileo
pg_dump -a --column-inserts -t PeriodAssetCosts galileo.old | psql -q galileo
pg_dump -a --column-inserts -t AssetSubCosts galileo.old | psql -q galileo
pg_dump -a --column-inserts -t Transactions galileo.old | psql -q galileo
pg_dump -a --column-inserts -t ConsultantTransactions galileo.old | psql -q galileo
pg_dump -a --column-inserts -t MIDTTransactions galileo.old | psql -q galileo
pg_dump -a --column-inserts -t calldumps galileo.old | psql -q galileo
pg_dump -a --column-inserts -t calls galileo.old | psql -q galileo
pg_dump -a --column-inserts -t TrainingTypes galileo.old | psql -q galileo
pg_dump -a --column-inserts -t Training galileo.old | psql -q galileo
pg_dump -a --column-inserts -t ClientTraining galileo.old | psql -q galileo
pg_dump -a --column-inserts -t dailySegments galileo.old | psql -q galileo
pg_dump -a --column-inserts -t dailyTransactions galileo.old | psql -q galileo
pg_dump -a --column-inserts -t new_Segments galileo.old | psql -q galileo
pg_dump -a --column-inserts -t incentive_types galileo.old | psql -q galileo
pg_dump -a --column-inserts -t incentive_targets galileo.old | psql -q galileo
pg_dump -a --column-inserts -t contracts galileo.old | psql -q galileo
pg_dump -a --column-inserts -t incentive_payments | psql -q galileo
