--SELECT * FROM DB_LOCK

--exec sp_lock

--GO
--CREATE PROCEDURE [dbo].[DBUNLOCKPROC]
--AS
--BEGIN
	
	-- �ӽ� ���̺� ����
	CREATE TABLE #tmpDBUNLOCK(
	SPID INT
	)
	-- CNT�� �ӽ����̺�
	CREATE TABLE #tmpDBUNLOCKCNT (
	SPID INT
	)

	-- ���� ����
	DECLARE @LoopCnt INT
	DECLARE @SPID INT
	DECLARE @QUERY NVARCHAR(4000)

	INSERT INTO #tmpDBUNLOCKCNT (
			[SPID]
	)
	SELECT P.SPID AS SPID 
	FROM master..SYSPROCESSES P
	WHERE (status LIKE 'RUN%'
	OR waittime > 0
	OR blocked <> 0
	OR open_tran <> 0
	OR EXISTS (SELECT * FROM master..SYSPROCESSES P1
				WHERE P.spid = P1.blocked AND P1.spid <> P1.blocked))
	AND spid > 50
	AND spid <> @@SPID
	ORDER BY CASE WHEN status LIKE 'RUN%' THEN 0 ELSE 1
	END,
	waittime DESC,
	open_tran DESC

	SET @LoopCnt = 1
	WHILE(@LoopCnt <= (SELECT COUNT(*) FROM #tmpDBUNLOCKCNT))
	BEGIN
	-- �ӽ� ���̺� SPID �� �Է�
		INSERT INTO #tmpDBUNLOCK (
			[SPID]
		 )
		SELECT TOP(1) P.SPID AS SPID 
		FROM master..SYSPROCESSES P
		WHERE (status LIKE 'RUN%'
		OR waittime > 0
		OR blocked <> 0
		OR open_tran <> 0

		OR EXISTS (SELECT * FROM master..SYSPROCESSES P1
					WHERE P.spid = P1.blocked AND P1.spid <> P1.blocked))
		AND spid > 50
		AND spid <> @@SPID
		ORDER BY CASE WHEN status LIKE 'RUN%' THEN 0 ELSE 1
		END,
		waittime DESC,
		open_tran DESC

		-- �����
		SELECT * FROM #tmpDBUNLOCK

		IF EXISTS (SELECT * FROM #tmpDBUNLOCK)
		BEGIN
			-- KILL ���� �ۼ�
			SET @QUERY = 'KILL ' + CONVERT(VARCHAR, (SELECT TOP(1) SPID FROM #tmpDBUNLOCK))
			PRINT @QUERY

			-- KILL ���� ����
			EXEC sp_executesql @QUERY
		END
		SET @LoopCnt = @LoopCnt + 1
		SELECT @LoopCnt
		
		-- ���� �� �ӽ����̺� ����
		TRUNCATE TABLE #tmpDBUNLOCK
	END
	-- �ӽ� ���̺� ����
	DROP TABLE #tmpDBUNLOCK
	DROP TABLE #tmpDBUNLOCKCNT
--END