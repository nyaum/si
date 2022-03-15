--SELECT * FROM DB_LOCK

--exec sp_lock

--GO
--CREATE PROCEDURE [dbo].[DBUNLOCKPROC]
--AS
--BEGIN
	
	-- 임시 테이블 생성
	CREATE TABLE #tmpDBUNLOCK(
	SPID INT
	)
	-- CNT용 임시테이블
	CREATE TABLE #tmpDBUNLOCKCNT (
	SPID INT
	)

	-- 변수 선언
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
	-- 임시 테이블에 SPID 값 입력
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

		-- 디버그
		SELECT * FROM #tmpDBUNLOCK

		IF EXISTS (SELECT * FROM #tmpDBUNLOCK)
		BEGIN
			-- KILL 쿼리 작성
			SET @QUERY = 'KILL ' + CONVERT(VARCHAR, (SELECT TOP(1) SPID FROM #tmpDBUNLOCK))
			PRINT @QUERY

			-- KILL 쿼리 실행
			EXEC sp_executesql @QUERY
		END
		SET @LoopCnt = @LoopCnt + 1
		SELECT @LoopCnt
		
		-- 루프 후 임시테이블 비우기
		TRUNCATE TABLE #tmpDBUNLOCK
	END
	-- 임시 테이블 삭제
	DROP TABLE #tmpDBUNLOCK
	DROP TABLE #tmpDBUNLOCKCNT
--END