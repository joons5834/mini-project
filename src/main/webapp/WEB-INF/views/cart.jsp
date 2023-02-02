<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>장바구니</title>
    <style>
		form, h1 {
		  text-align: center;
		}
		table{
			    table-layout: fixed;
			    width:100%;
			    margin-left: auto;
			    margin-right: auto;
		      	border-collapse: collapse;
  				border: 1px solid grey;
		}
		tfoot tr{
			height: 64px;
			background-color: #F5F5DC;
			border: 1px solid grey;
		}
		thead tr{
        	background-color: #F5F5DC;
        	border: 1px solid grey;
		}
		tbody tr{
			height: 32px;
		}
		input[type=button] {
        height: 30px;
        border-radius: 5px;
        background: #012A5E;
        color: white;
        cursor: pointer;
      	}

      	input[type=button]:hover {
        border-color: lightslategray;
        background: lightslategray;
      	}
      	
      	input[type=submit] {
        height: 30px;
        border-radius: 5px;
        background: #012A5E;
        color: white;
        cursor: pointer;
      	}

      	input[type=submit]:hover {
        border-color: lightslategray;
        background: lightslategray;
      	}
      	
      	input[type=submit]:disabled{
      	border-color: grey;
        background: grey;
      	}
		
	</style>
</head>
<body>
<!-- 상단바  -->
<jsp:include page="header.jsp">
    <jsp:param value="false" name="login"/>
</jsp:include>
<h1>장바구니</h1>
<c:if test="${empty items }">
	<h1>장바구니가 텅~텅~ 비어있어요</h1>
</c:if>

<c:if test="${ not empty items }">
<h1>총 <span id="totalCount">${ cnt }</span>개</h1>
<form action="/buy" method="post">
    <table>
        <thead>
        <tr>
            <th>선택</th>
            <th>소설제목</th>
            <th>회차</th>
            <th>회차제목</th>
            <th>가격(모래알)</th>
            <th>삭제</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${ items }" var="item">
            <tr id="${ item.id }">
                <td><input type="checkbox" id="ch${ item.id }" name="toBuy"
                           value="${ item.episodeId }" class="rowCheckbox"
                           data-item-id="${ item.id }" checked="checked"></td>
                <td>${ item.novelTitle }</td>
                <td>${ item.sequence }</td>
                <td>${ item.episodeTitle }</td>
                <td class="price" id="price${ item.id }">${ item.price }</td>
                <td><input type="button" class="delete" data-item-id="${ item.id }" value="삭제"></td>
            </tr>
        </c:forEach>
        </tbody>
        <tfoot>
        <tr>
            <th scope="row" colspan="4">선택된 작품의 총 가격</th>
            <td id="total"></td>
            <th></th>
        </tr>
        </tfoot>

    </table>

    <h1>결제 후 잔액</h1>
    <span id="balance">${ balance }</span>(현재 잔액) - <span id="total2">0</span>(구매 예정)
    = <span id="futureBalance"></span>(예정 잔액)
    <div id="balanceWarning"></div>
    <input type="submit" id="buy" value="결제하기">
</form>
</c:if>
<jsp:include page="footer.jsp"/>
<script src="/resources/js/jquery-3.6.1.min.js"></script>
<script>
	if("${resultMsg}"){
		alert("${resultMsg}");
	}
  function updateTotalPrice() {
    let priceCells = [...document.getElementsByClassName('price')];
    let totalPrice = priceCells.reduce(
        (acc, cur) => acc + Number(cur.innerText)
        , 0);

    $("#total").html(totalPrice);
    $("#total2").text(totalPrice);
  }

  function updateTotalCount() {
    $("#totalCount").html($("tbody>tr").length);
  }

  function calculateFutureBalance() {
    let newNum = Number($("#balance").text()) - Number($("#total2").text());
    $("#futureBalance").text(newNum);
    if (newNum < 0 || Number($("#total2").text()) == 0) {
      $("#buy").prop("disabled", true);
      $("#buy").val("결제불가");
      if(newNum < 0){
      	$("#balanceWarning").text("잔액이 부족합니다.");
      }
    } else {
      $("#buy").prop("disabled", false);
      $("#buy").val("결제");
      $("#balanceWarning").text("");
    }
  }

  updateTotalPrice();
  calculateFutureBalance();

  $(".rowCheckbox").change(function () {
    let oldNum = Number($("#total").text());
    let oldCount = Number($("#totalCount").text());
    if ($(this).is(":checked")) {
      var newNum = oldNum + Number($("#price" + this.dataset.itemId).text());
      let newCount = oldCount + 1;
      $("#totalCount").text(newCount);
    } else {
      var newNum = oldNum - Number($("#price" + this.dataset.itemId).text());
      let newCount = oldCount - 1;
      $("#totalCount").text(newCount);
    }
    $("#total").text(newNum);
    $("#total2").text(newNum);
    calculateFutureBalance();
  });

  $(".delete").on("click", function (e) {
    $.ajax({
      method: 'DELETE',
      url: '/cart',
      data: {id: e.target.dataset.itemId}
    }).done(function (result) {
    	if(result == false){
    		alert("로그인 후 이용하세요");
    		return false;
    	}
      //AJAX 성공시 실행 코드
      if ($("#ch" + e.target.dataset.itemId).is(":checked")) {
        let oldNum = Number($("#total").text());
        var newNum = oldNum - Number($("#price" + e.target.dataset.itemId).text());
        $("#total").text(newNum);
        $("#total2").text(newNum);

        let oldCount = Number($("#totalCount").text());
        let newCount = oldCount - 1;
        $("#totalCount").text(newCount);
        calculateFutureBalance();
      }
      $("#" + e.target.dataset.itemId).remove();
    })
  });


</script>
</body>
</html>