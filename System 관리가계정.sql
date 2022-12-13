
CREATE USER DDL IDENTIFIED BY DDL;

CREATE USER KH IDENTIFIED BY KH;

/*
    계정 생성하는 구문. 일반사용자 계정은 오직 관리자 계정에서 만들 수 있음
    생성방법[표현법]
    CREATE USER 계정명 IDENTIFIED BY 비밀번호;
*/

-- 작업을 하기 위한 최소한의 권한
-- 부여한 권한 : 접속, 데이터 관리
-- [표현법] GRANT 권한1, 권한2, 권한3, ... TO 계정명;
GRANT CONNECT , RESOURCE TO DDL;

GRANT CONNECT , RESOURCE TO KH;
/*
    관리자 계정 : DB의 생성과 관리를 담당하는 계정이며, 모든 권한과 책임을 가지는 계정
    사용자 계정 : DB에 대해서 질의, 갱신, 보고서 작성 등의 작업을 수행할 수 있는 계정, 업무에 필요한 최소한의 권한만 가지는 것을 원칙으로 함
    
...