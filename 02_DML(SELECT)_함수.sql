CREATE USER WORKBOOK IDENTIFIED BY WORKBOOK;

GRANT RESOURCE , CONNECT TO WORKBOOK;
/*
함수 FUNCTION
자바로 따지면 메소드와 같은 존내
매개변수로 전달딘 값들을 읽어서 계산한 결과를 반환-> 호출해서 쓴다.
단일행 함수: N개의 값을 읽어서 N개의 결과를 리턴(매 행다마 함수 실행 후 결과 반환)
그룹함수: N개의 값을 읽어서 1개의 결과를 리턴(하나의 그룹별로 함수 실행 후 결과 반환)
단일행 함수와 그룹함수는 함께 사용할수 없음: 결과 행의 갯수가 다르기 때문
*/
--단일행 함수
/*
문자열과 관련된 함수
LENGTH/LENGTHB
LENGTH(문자열):해당 전달된 문자열의 글자 수 반환
LENTGJB(문자열): 매개변수로 전달된 문자열의 바이트수 반환
 결과값은 숫자로 반환한다->NUMBER 데이터 타입
 문자열:문자열 형식의 리터럴 혹은 문자열에 해당하는 칼럼
 한글->'김'->'ㄱ','ㅣ','ㅁ',=>한글자당 3바이트 취급
 영문,숫자,특수문자:한글자당 1BYTE로 취급
*/
SELECT LENGTH('오라클 쉽네'), LENGTHB('오라클 쉽네')
FROM DUAL;--가상테이블(DUMMY TABLE):산술연산이나 가상칼럼값등 한번만 출력하고 싶을때 사용하는 테이블

SELECT '오라클',1,2,3,'AAAAAA',SYSDATE
FROM DUAL;
/*
INSTR
INSTR(문자열,특정문자,찾을위치의 시작값, 순번): 문자열로부터 특정 문자의 위치값 반환
찾을 위치의 시작값과, 순번은 생략이 가능하다.
결과값은 NUMBER타입으로 반환.

찾을위치에 시작값(1/-1)
1:앞에서부터 찾겠다(생략시 기본값)
-1:뒤에서부터 찾겠다.
*/
SELECT INSTR('AABAACAABBAA','B') FROM DUAL;
--앞에서부터 B를찾아서 첫번째로 찾는 B의 위치를 반환해줌.
SELECT INSTR('AABAACAABBAA','B',1)FROM DUAL;
--위와 동일

SELECT INSTR('AABAACAABBAA','B',-1) FROM DUAL;
--뒤에서부터 첫번째에 위치하는 B의값을 앞에서부터세서 알려준것
SELECT INSTR('AABAACAABBAA','B',-1,2)FROM DUAL;
SELECT INSTR('AABAACAABBAA','B',1,2)FROM DUAL;
SELECT INSTR('AABAACAABBAA','B',-1,0)FROM DUAL;
--범위를 벗어난 순번을 제시하면 오류발생
--인덱스처럼 글자의 위치를 찾는것은 맞다
--자바처럼 0부터가아니라 1부터 찾는다.

--EMPLOYEE테이블에서 EMAIL칼럼에서 @의 위치찾기
SELECT EMP_NAME, EMAIL,INSTR(EMAIL, '@') AS "@의 위치"
FROM EMPLOYEE;

/*
SUBSTR
문자열로부터 특정문자열을 추출하는 함수
-SUBSTR(문자열,처음위치,추출할문자갯수)
--결과값은 CHARACTER타입으로 반환(문자열형태)
추출할 문자갯수 생략 가능(생략시에는 문자열 끝까지 추출하겠다)
처음위치는 음수로 제시가능: 뒤에서부터 N번째 위치로부터 문자를 추출하겠다는 뜻
*/
SELECT SUBSTR('ORACLEDATABASE',7)FROM DUAL;

SELECT SUBSTR('ORACLEDATABASE',7,4)FROM DUAL;

SELECT SUBSTR('ORACLEDATABASE',-8,3)FROM DUAL;

--주민등록번호에서 성별부분을 추출해서 남자(1,3)/여자(2,4)인지를 체그
SELECT EMP_NAME, SUBSTR(EMP_NO,8,1)AS 성별
FROM EMPLOYEE;

--이메일에서 ID부분만 추출해서 조회
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL,'@')-1)AS ID
FROM EMPLOYEE
--남자사원들만 조회(모든칼럼)
SELECT *  
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1)IN('1','3');
--여자사원들만 조회(모든칼럼)
SELECT *  
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1)IN('2','4');
/*
LPAD RPAD
LPAD/RPAD문자열, 최종적으로 반환할 문자의 길이(BYTE), 덧붙이고자 하는 문자
제시한 문자열에 덫붙이고자하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종N길이만큼의 문자열 반환.
결과값은 CHARACTER 타입으로 반환
덧붙이고자 하는 문자: 생략가능
*/
SELECT LPAD(EMAIL, 16,'*'), LENGTH (EMAIL) FROM EMPLOYEE;
--덫붙이고자하는 문자 생략시 공백이 문자열값의 왼쪽에 붙어서 반환
SELECT RPAD(EAMIL, 20,'#')
FROM EMPLOYEE;
--주민등록번호 조회:123456-1234567=>123456-1******;
SELECT EMP_NAME, EMP_NO
FROM EMPLOYEE;
--1단계
SELECT RPAD('123456-1',14,'*')AS 주민번호 FROM DUAL;
--2단계
SELECT EMP_NAME, SUBSTR(EMP_NO,1,8)AS "주민번호 앞자리"
FROM EMPLOYEE;

SELECT EMP_NAME,RPAD(SUBSTR(EMP_NO,1,8),14,'*')AS주민번호
FROM EMPLOYEE
/*
LTRIM/RTRIM
LTRIM,RTRIM(문자열,제거시키고자하는 문자)
문자열의 왼쪽 또는 오른쪽에서 제거시키고자 하는 문자들을 찾아서 제거한 나머지 문자열을 반환
결과값은 CHARACTER형태로 나옴.
제거시키고자하는 문자 생략가능=>' ' 이제거됨.
*/
SELECT LTRIM('   민경민   ')
FROM DUAL;
SELECT RTRIM('0001230456000','0')
FROM DUAL;
SELECT LTRIM('123123KH123','123')
FROM DUAL;--제거시키고자 하는 문자열을 통으로 지워주는게 아니라 문자 하나하나 검사르 하면서 현재 문자가 지우고자하는
--문자에 있다면 지워줌
/*
TRIM
TRIM(BOTH/LEADING/TRAILING *제거하고자하는문자*FROM '문자열')
:문자열에서 양쪽/앞쪽/뒤쪽에 있는 특정문자를 제거한 나머지 문자열을 반환

결과값은 당연히 CHARACTER 타입으로 반환
BOTH/LEADING/TAILING은 생략가능하며 기본값은 BOTH
*/
SELECT TRIM('            K    H                 ')
FROM DUAL;
SELECT TRIM(BOTH 'Z'FROM'ZZZKHZZZ')
FROM DUAL;
SELECT TRIM(TRAILING 'Z'FROM 'ZZZKHZZZZ')
FROM DUAL;
/*
LOWER/UPER/INICAP
-LOWER(문자열)
:소문자로변경
-UPPER(문자열)
:문자열을 대문자로 변경
INITCAP(문자열)
:각 단어의 앞글자만 대문자로 반환
결과값은 동일한 CHARATER형태임
*/
SELECT LOWER('WELCOME TO C CLASS'),UPPER('welcome to c class'), INITCAP('welcome to c class')
FROM DUAL;
/*
CONCAT
CONCAT(문자열1,문자열2)
:전달된 문자열 두개를 하나의 문자열로 합쳐서 반환.
결과값은 CHARACTER.
*/
SELECT CONCAT('가나다','라마바사')FROM DUAL;
SELECT '가나다'||'라마바사' FROM DUAL;

SELECT CONCAT (CONCAT('가나다','라마바사'),'아')FROM DUAL;
SELECT '가나다'||'라마바사'||'아' FROM DUAL;
 
/*
REPLACE
-RPLACE(문자열, 찾을문자, 바꿀문자)
:문자열로부터 찾을 문자열을 찾아서 바꿀문자로 치환.
*/
SELECT REPLACE ('서울시 강남구 역삼동 테해란로 6번길 남도빌딩 3층','3층','2층')
FROM DUAL;

SELECT EMP_NAME, EAMIL, REPLACE(EAMIL,'kh.or.kr','iei.or.kr')
FROM EMPLOYEE;


/*
숫자관련 함수
ABS(숫자):절대값을 구해주는 함수
결과값은 NUMBER.
*/
SELECT ABS(-10) FROM DUAL;
SELECT ABS(-10.9)FROM DUAL;
/*
MOD->모듈러 연산->%
MOD(숫자, 나눌값):두수를 나눈'나머지' 값을 반환해주는 함수
결과값은 NUMBER
*/
SELECT MOD(10,3) FROM DUAL;
SELECT MOD(-10,3) FROM DUAL;
SELECT MOD(10.9,3)FROM DUAL;

/*
ROUND(반올림하고자하는 숫자, 반올림 위치)
반올림해주는 함수
반올림할 위치: 소수점 기준으로 아래 N번째 수에서 반올림 하겠다.
            생략가능(기본값은 0, 소숫점 첫번째자리에서 반올림 하겠다.->소수점이 0개다.
*/
SELECT ROUND(123.456)FROM DUAL;
SELECT ROUND(123.456, -1)FROM DUAL;
/*
CEIL(올림처리숫자):소숫점아래의 수를 무조건 올림처리해주는 함수
반환형 NUMBER타입
FLOOR(버림처리하고자하는 숫자):소숫점아래 수를 무조건 버림처리
*/
SELECT CEIL(123.11111111)FROM DUAL;
SELECT FLOOR(207.999999999999999999)FROM DUAL;
--각직원별로 근무일수 구하기(오늘날짜-고용일=>소숫점
SELECT EMP_NAME, HIRE_DATE, CONCAT(FLOOR(SYSDATE-HIRE_DATE,'일')AS 근무일수
FROM EMPLOYEE;
/*
 TRUNC(버림처리할 숫자, 위치):위치가 지정가능한 버림처리를 해주는 함수
 결과값은 NUMBER
 위치:생략가능 생략시 기본값은 0==FLOOR함수
*/
SELECT TRUNC(123.786, -1) FROM DUAL;
/*
날짜 관련 함수
DATE 타입:년도, 월, 일, 시분, 초를 다포함하고 있는 자료형
*/
--SYSDATE:현재시스템 날짜 반환
SELECT SISDATE FROM DUAL;
--1.MONTHS_BETWEEN(DATE1, DATE2): 두 날짜 사이의 개월수를 반환(결과값은 NUMBER)
--DATE2가 미래일경우 음수가 나옴.
--각 직원별 근무일수, 근무 개월수
SELECT EMP_NAME,
FLOOR(SYSDATE-HIRE_DATE)||'일' 근무일수, 
FLOOR(MONTHS_BETWEEN(SYSDATE,HIRE_DATE))||'개월'근무개월수
FROM EMPLOYEE;
--2.ADD_MONTH(DATE,NUMBER):특정날짜에 해당 숫자만큼 개월수를 더한 날짜 반환(결과값은 DATE)
--오늘 날짜로부터 5개월 후
SELECT ADD_MONTHS(SYSDATE, 5) FROM DUAL;
--전체사원들의 1년 근속일(==입사일기준 1주년)
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE,12)FROM EMPLOYEE;
--3.NEXT_DAY(DATE, 요일(문자/숫자)):특정날짜에 가장 가까운 요일을 찾아 그 날짜를 반환
SELECT NEXT_DAY(SYSDATE,'토')FROM DUAL;
--1.일요일,2:월요일,3:화요일....5:목요일
--토요일은 가능한데 SATURDAY에서는 오류남 :현재 컴퓨터 세팅이 KOREAN이기 때문에
--언어를 변경하는 방법
--DDL(데이터 정의언어):CREATE,ALTER,DROP
ALTER SESSION SET NLS_LANGUAGE=AMERICAN;
SELECT NEXT_DAY(SYSDATE,'SUN')FROM DUAL;
--한국어로 변경
ALTER SESSION SET NLS_LANGUAGE=KOREAN;

--4. LAST_DAY(DATE):해당특정날짜달의 마지막 날짜를구해서 반환.
SELECT LAST_DAY(SYSDATE)FROM DUAL;
--이름,입사일,입사한날의 마지막날 날짜 조회
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)FROM EMPLOYEE;
--5.EXTRACT:년도 월, 일정보를 추출해서 반환(결과값은 NUMBER)
/*
    -EXTRACT(YEAR FROM 날짜) :특징 날짜로부터 년도만 추출
    -EXTRACT(MONTH FROM 날짜) :특징 날짜로부터 월만 추출
    -EXTRACT(DAY FROM 날짜) :특징 날짜로부터 일만 추출
*/
SELECT EXTRACT(YEAR FROM SYSDATE),
EXTRACT(MONTH FROM SYSDATE),
EXTRACT(DAY FROM SYSDATE)
FROM DUAL;

---------------------------------------------------------
/*
형변환 함수
NUMBER/DATE=>CHARACTER
TO_CAHR(NUMBER/DATE,포맷)
:숫자형 또는 날짜형 데이터를 문자형 타입으로 반환
*/
SELECT TO_CHAR(123456)FROM DUAL;
SELECT TO_CHAR(123,'00000')FROM DUAL;
--빈칸을 0으로 채움
SELECT TO_CHAR(1234,'99999')FROM DUAL;
--1234에 빈칸을 ' '으로채움
SELECT TO_CHAR(1234,'L00000')FROM DUAL;
--L:LOCAL->현재설정괸 나라의 화폐
--1234=>\01234
SELECT TO_CHAR(1234,'L99,999')FROM DUAL;
--급여정보를 3자리마다,를 추가해서 확인
SELECT EMP_NAME,TO_CHAR(SALARY,'L999,999,999')AS 급여
FROM EMPLOYEE;
--날짜를 문자열로
SELECT TO_CHAR(SYSDATE) FROM DUAL;
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD')FROM DUAL;
--HH24: 23시간 형식
SELECT TO_CHAR(SYSDATE,'HH24:MI:SS')FROM DUAL;
--MON:몇 '월' 형식, DY요일을 알려주는데 금요일에서 요일을 뺌
SELECT TO_CHAR(SYSDATE, 'MON DY,YYYY')FROM DUAL;

SELECT TO_CHAR(HIRE_DATE, 'YYYY'),
 TO_CHAR(HIRE_DATE, 'RRRR'),
 TO_CHAR(HIRE_DATE, 'YY'),
 TO_CHAR(HIRE_DATE, 'RR'),
 TO_CHAR(HIRE_DATE, 'YEAR')
FROM EMPLOYEE;
--YY와 RR의차이점
--R이뜻하는 단어:ROUND(반올림)
--YY:앞자리에 무조건 20이붙음=>(20)21
--RR:50년 기준 작으면 20이붙음, 크면19가 붙음.=>19(89)
--월로써 쓸수있는 포맷
SELECT TO_CHAR(HIRE_DATE, 'MM'),
 TO_CHAR(HIRE_DATE, 'MON'),
 TO_CHAR(HIRE_DATE, 'MONTH'),
 TO_CHAR(HIRE_DATE, 'RM')
FROM EMPLOYEE;
--일로써 쓸수있는 포맷
SELECT TO_CHAR(HIRE_DATE, 'D'),
 TO_CHAR(HIRE_DATE, 'DD'),
 TO_CHAR(HIRE_DATE, 'DDD')
FROM EMPLOYEE;
--D:1주일 기준으로 일요일부터 며칠째인지 알려주는 포맷
--DD:1달 기준으로 1일부터 몇일째인지 알려주는 포맷
--DDD:1년 기준으로 1월1일부터 며칠째인지 알려주는 포맷

-- 요일로써 쓸수있는 포맷
SELECT TO_CHAR(SYSDATE,'DAY'),
TO_CHAR(SYSDATE,'DAY')
FROM DUAL;
--'2022년12월14일(수)'포맷으로 적용하기
SELECT TO_CHAR(SYSDATE, 'YYYY')||'년'||TO_CHAR(SYSDATE, 'MM')||'월'||TO_CHAR(SYSDATE, 'DD')||'일'||
TO_CHAR(SYSDATE, '(DY)')
 FROM dual;
SELECT TO_CHAR(SYSDATE,'YYYY"년" MM"월" DD"일" (DY)')
FROM DUAL;
--2010SUS 이후에 입사한사원들의 사원명, 입사일 포멧은 위의 형식대로
SELECT EMP_NAME, TO_CHAR(HIRE_DATE ,'YYYY"년" MM"월" DD"일"(DY)')
FROM EMPLOYEE
WHERE HIRE_DATE>='10/01/01';--자동형변환
--WHERE EXTRACT(YEAR FROM HIRE DATE)>=2010
/*
NUMBER/CHARACTER=>DATE
-TO_DATE(NUMBER/CHARACTER,포맷):숫자형,문자형 데이터를날짜로 변환.
*/

SELECT TO_DATE('20221104')
FROM DUAL;--기본폼에 YY/MM/DD로 변환.
SELECT TO_DATE(000101)--정수값중에 0으로 시작하는 숫자는 없기때문에 에러발생
FROM DUAL;

SELECT TO_DATE('000101')
FROM DUAL;--0으로 시작하는 년도를 다룰때는 반드시 ' '를붙여서 문자열처럼 다뤄줘야함.
