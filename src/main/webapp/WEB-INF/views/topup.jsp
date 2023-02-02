<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>충전하기</title>
<script src="https://js.tosspayments.com/v1/payment"></script>
</head>
<body>
	<form>
		<label for="amount"> 충전금액: </label>
		<input type="number" id="amount" name="amount"> 알
		<input type="button" id="topup" value="충전하기">
		<br>현재잔액 : ${ balance } 알
	</form>
	<script>
		if("${resultMsg}"){
			alert("${resultMsg}");
		}
	    var clientKey = 'test_ck_lpP2YxJ4K87WJOXW7A28RGZwXLOb'
	    var tossPayments = TossPayments(clientKey) // 클라이언트 키로 초기화하기
	    document.getElementById("topup").onclick = function(){
	    	let topUpAmt = Number(document.getElementById("amount").value);
	    	const SAND_PRICE = 100;
	    	tossPayments.requestPayment('카드', { // 결제 수단 파라미터
	    		  // 결제 정보 파라미터
	    		  amount: topUpAmt * SAND_PRICE,
	    		  orderId: Math.random().toString(36).substring(2,12),
	    		  orderName: '모래알 충전-' + topUpAmt,
	    		  successUrl: window.location.origin + '/success',
	    		  failUrl: window.location.origin + '/fail'
	    		})
	    		.catch(function (error) {
	    		  if (error.code === 'USER_CANCEL') {
	    		    alert("사용자 결제 취소");
	    		  } else if (error.code === 'INVALID_CARD_COMPANY') {
	    		    alert("잘못된 카드사 오류");
	    		  }
	    		})
	    }
  	</script>
</body>
</html>