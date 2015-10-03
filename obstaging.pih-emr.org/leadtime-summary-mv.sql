/* Create the MV table */
CREATE TABLE leadtime_summary_mv AS SELECT * FROM leadtime_summary_vw;

/* Optionally add index(es) for the queries you want to speed up */
CREATE INDEX leadtime_summary_idx ON leadtime_summary_mv(product_code, project);

/* Rename the old view to save it and to avoid application re-coding */
RENAME TABLE leadtime_summary_vw TO leadtime_summary_vw_old;

/* Create the view that points to the MV */
CREATE VIEW leadtime_summary_vw AS
    SELECT * FROM leadtime_summary_mv;