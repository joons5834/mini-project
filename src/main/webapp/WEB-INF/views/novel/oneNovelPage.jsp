<%@page import="episodes.EpisodesDTO" %>
<%@page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상세 페이지</title>
	<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@48,400,0,0" />
    <script src="<%=request.getContextPath() %>resources/js/jquery-3.6.1.min.js"></script>
    <script>
      /* 체크박스 전체 선택 */
      $(document).ready(function(){
    	if("${msg}"){
    		alert("${msg}");
    	}
    	  
        $("#all").click(function(){
          if($("#all").prop("checked")){
            $("input:checkbox[name='check']").prop("checked", true);
          } else{
            $("input:checkbox[name='check']").prop("checked", false);
          }
        });

        //체크된 소설 장바구니 넘기기
        $("#cart").click(function(e){
        	if($("input:checkbox[name='check']").is(":checked") == true){
	          var chk = confirm("선택한 소설 "+$("input:checkbox[name='check']:checked").length+"개를 담으시겠습니까?");
	          if(chk){
	            alert("담았습니다. 장바구니로 이동합니다.");
	            $("form").attr("action","/cartIn");
	          }else{
	            e.preventDefault();
	          }
        		
        	}else{
        		alert("소설을 선택하세요.");
        	}
        });

        //구매
        $("#buy").click(function(e){
        	if($("input:checkbox[name='check']").is(":checked") == true){
	          var chk = confirm("선택한 소설 "+$("input:checkbox[name='check']:checked").length+"개를 구매하시겠습니까?");
	          if(chk){
	            $("form").attr("action","/buyNow");
	          }else{
	            e.preventDefault();
	          }
        	}else{
        		alert("소설을 선택하세요.");
        	}
        });

        //순서 정렬
//         $("#orderby").click(function(){
//         	alert('${list}')
//         	$("form").attr("action","/orderBy");
//         });
        
      });
    </script>
    <style type="text/css">
      #detail {
        width: 63%;
        height: 430px;
        float: right;
      }
      #check {
        width: 53px;
      }
      #first_tr {
        border: 1px solid grey;
        background-color: #F7F5EB;
      }
      #second_tr {
        height: 32px;
      }
      #page {
        width: 100%;
        height: 30px;
        text-align: center;
      }
      /* 모래 아이콘 */
      #sand {
        width: 20px;
        height: 18px;
      }
      #btn {
        width: auto;
        height: auto;
        text-align: right;
      }
      #b2 {
        color: #055375;
      }
      #title {
        width: 25%;
        height: 425px;
        float: left;
      }
      /* 좋아요 버튼 */
      #like{
      	width:30px;
      	height: 30px;
      }
      /* 좋아요 이미지*/
      #liked_img{ 
      	width:21px;
      	height: 25px;
      }
      /* 소설목록 테이블 */
      table { 
        border: 1px solid grey;
        border-collapse: collapse;
        width: 100%;
        text-align: center;
      }
      b {
        color: #012A5E;
      }
      /* 공지 글 */
      #h{ 
      width:77px;
      text-align: center;
      }
      /* 접은 글 */
      #show{ 
      width:44px;
      text-align: center;
      
      color: red;
      }
      /* 공지 빨간색 칸 디자인*/
	.BookDetailNotice_List_Header-notices {
	    background: #fce8e6;
	    color: #ed6d5e;}
	  /* 장바구니, 구매 버튼 */
      #cart, #buy{ 
      border-radius:5px;
        border-color: #f0f0f0;
        background: #e3e3e3;
      }
      #xxx{
      color:red;
      }
      #review_title{
      margin-left: 20px;
      text-align: left;
      }
      #second_tbl_tr{
      border: 1px solid grey;
      }
      #review_submit{
      text-align: right;
      }
      #edit{
      padding-top: 20px;
      }
    </style>
</head>
<body>
<!-- 상단바 -->
<jsp:include page="../header.jsp">
    <jsp:param value="false" name="login"/>
</jsp:include>
<!-- 웹소설 표지 /cart -->
<form action="<%=request.getContextPath() %>" id="f" method="post">
    <img id="title" src="resources/images/novel/${dto.id}.jpg">
    <!-- 웹소설 설명란 -->
    <div id="detail">
    	<br><b>>${dto.genre }</b>
        <h1> ${dto.title} </h1>
        <b>연재중&nbsp;&nbsp;|&nbsp;&nbsp;작가 ${dto.author}&nbsp;&nbsp;</b><br>
        <b>${dto.indate }&nbsp;&nbsp;|
            &nbsp;&nbsp;조회수 ${dto.viewcount}&nbsp;&nbsp;|
            &nbsp;&nbsp;좋아요&nbsp;&nbsp;<button type="button" id="like" name="like"><img id="liked_img" src="resources/images/liked.png"></button></b>
        <hr /><br>
        ${dto.description}
        <br><br>
        <div>
        <h4 class="BookDetailNotice_List_Header BookDetailNotice_List_Header-notices" id="h">
        &lt;공지&gt;</h4></div>
        <div>
        본 작품은 12세 미만의 청소년이 열람하기에 부적절한 내용을 포함하고 있습니다. 보호자의 지도 하에 작품을 감상해주시기 바랍니다.</div>
        
        <br><hr /><br>
        <b>1화 소장: 모래 2알 <img id="sand" src="resources/images/sand.png"></b>
    </div>

    <div id="blank" style="clear:both;"></div>
    <!-- 에피소드 목록 -->
    <h4>총 회차 ${cnt}화</h4>
<%--     <input type="hidden" value="${list.sequence}" name="sequence"> --%>
<%--     <input type="hidden" value="${list.novel_id}" name="novel_id"> --%>
<!--     <input type="submit" name="orderby" id="orderby" value="신간부터"> -->
    
    <table>
        <tr id="first_tr">
            <td style="width:55px;">회차</td>
            <td style="width:70%;">제목</td>
            <td id="check"><input type="checkbox" id="all" name="all"></td>
            <td>가격</td>
        </tr>
        <!-- 에피소드 출력 -->
        <c:if test="${fn:length(list)!=0}">
	        <c:forEach items="${list}" var="epi">
	            <tr id="second_tr"><td>${epi.sequence }화</td><td>${epi.title }</td>
	                <td>
	                    <c:if test="${epi.price !=0}">
	                        <input type="checkbox" name="check" value="${epi.id}">
	                    </c:if>
	                    <c:if test="${epi.price ==0}">
	                        <b id="b2"><c:out value="소장중"/></b>
	                    </c:if>
	                </td>
	                <td>
	                    <c:if test="${epi.price ==0}">
	                        <c:out value="-"/>
	                    </c:if>
	                    <c:if test="${epi.price !=0}">
	                        <c:out value="모래 ${epi.price }알"/>
	                    </c:if>
	                </td>
	            </tr>
	        </c:forEach>        	
        </c:if>
        <tr>
        <td></td>
        <td>
        <c:if test="${fn:length(list)==0}">
       		<h2><c:out value="런칭중입니다!"/></h2>
        </c:if></td></tr>
    </table><br>
    
    <!-- 장바구니, 구매 버튼 -->
    <div id="btn">
        <input type="hidden" value="${dto.id}" name="id">
        <input type="hidden" value=<%=session.getAttribute("loginid") %> name="user_id">
        <input type="submit" value="장바구니" id="cart" name="cart">
        <input type="submit" value="소장하기" id="buy" name="buy"><br><br>
    </div>
    
    <!-- 페이징 -->
    <div id="page">
        <%
            int totalCnt = (int) request.getAttribute("cnt");
            int totalPage = 0;
            if (totalCnt % 7 == 0) {
                totalPage = totalCnt / 7;
            } else {
                totalPage = totalCnt / 7 + 1;
            }
            for (int i = 1; i <= totalPage; i++) {
        %>
        <a href="oneNovelPage?id=${dto.id}&page=<%=i%>"><%=i%>페이지</a>
        <%
            }
        %>
    </div>
    <div>
    <table>
    <tr id="second_tbl_tr"><td><h3 id="review_title">리뷰창</h3></td></tr>
    <tr><td>작성자</td><td>내용</td><td>작성시간</td></tr>
    <tr><td>dd</td><td>소설 재밌다.</td><td>2023.01.27 11:39</td></tr>
    <div>
    <tr>
    <td></td>
   	<td id="edit">
    	<textarea id="input_review" cols="110" rows="3"></textarea></td><td><input type="submit" value="리뷰작성" id="review_submit"></td>
    </tr>
    </div>
    </table>
    </div>
</form>
<div id="blank" style="clear:both;"></div><br><br>
<jsp:include page="../footer.jsp"/>
</body>
</html>

 
 






