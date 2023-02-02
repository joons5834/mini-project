package sale;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class CartController {

    @Autowired
    @Qualifier("saleservice")
    SaleService service;


    @GetMapping("/cart")
    public ModelAndView cart(HttpSession session, @RequestParam(required=false) String resultMsg) {
        ModelAndView mv = new ModelAndView();

        if (session.getAttribute("loginid") == null) {
            mv.setViewName("user/login");
            return mv;
        }

        int userId = (int)session.getAttribute("loginid");
        int cnt = service.getNumberOfItems(userId);
        List<ItemDTO> items = service.getCartItems(userId);
        int balance = service.getBalance(userId);
        mv.addObject("cnt", cnt);
        mv.addObject("items", items);
        mv.addObject("balance", balance);
        mv.addObject("resultMsg", resultMsg);
        mv.setViewName("cart");
        return mv;
    }

    @ResponseBody
    @DeleteMapping("/cart")
    public boolean deleteCartItem(HttpSession session, int id) {
        if (session.getAttribute("loginid") == null) {
            return false;
        }
        service.deleteCartItem(id);
        return true;
    }

    @PostMapping("/buy")
    public String buyEpisodes(HttpSession session,
        HttpServletRequest request) {
        if (session.getAttribute("loginid") == null) {
            return "user/login";
        }

        Integer userId = (Integer) session.getAttribute("loginid");
        String[] strEpisodeIds = request.getParameterValues("toBuy");
        int[] episodeIds = Arrays.stream(strEpisodeIds).mapToInt(Integer::parseInt).toArray();

        try {
            service.buyEpisodes(userId, episodeIds);
        } catch (Exception e) {
            return "redirect:/cart";
        }
        return "redirect:/mypage";
    }
    
    @GetMapping("/topup")
    public String topUp(HttpSession session, 
    					Model model,
    					@RequestParam(required=false)String resultMsg) {
    	if (session.getAttribute("loginid") == null) {
            return "user/login";
        }

        Integer userId = (Integer) session.getAttribute("loginid");
        int balance = service.getBalance(userId);
        model.addAttribute("balance", balance);
        model.addAttribute("resultMsg", resultMsg);
        return "topup";
    }
    
    @GetMapping("/success")
    public String topUpSuccess(String paymentKey, 
    						   String orderId,
    						   int amount,
    						   HttpSession session) throws IOException, InterruptedException {
    	String bodyStr = String.format("{\"paymentKey\":\"%s\",\"amount\":%s,\"orderId\":\"%s\"}", paymentKey, amount, orderId);
    	HttpRequest request = HttpRequest.newBuilder()
    		    .uri(URI.create("https://api.tosspayments.com/v1/payments/confirm"))
    		    .header("Authorization", "Basic dGVzdF9za181bUJaMWdRNFlWWE9sTVA2dk9HM2wyS1BvcU5iOg==")
    		    .header("Content-Type", "application/json")
    		    .method("POST", HttpRequest.BodyPublishers.ofString(bodyStr))
    		    .build();
    		HttpResponse<String> response = HttpClient.newHttpClient().send(request, HttpResponse.BodyHandlers.ofString());
    		System.out.println(response.body());
    		int statusCode = response.statusCode();
    		String resultMsg = "";
    		int userId = (int)session.getAttribute("loginid") ;
    		if(statusCode == 200) {
    			System.out.println("==============");
    			System.out.println("결제 승인 완료");
    			System.out.println("==============");
    			int SAND_PRICE = 100;
    			service.addBalance(userId, amount / SAND_PRICE);
    			resultMsg = "충전이 완료되었습니다.";
    		}else {
    			System.out.println("==============");
    			System.out.println("결제 승인 실패");
    			System.out.println("==============");
    			resultMsg = "결제 승인에 실패하였습니다.";
    		}
    		String encMsg = URLEncoder.encode(resultMsg, "utf-8");
    		return "redirect:/topup?resultMsg=" + encMsg;
    }
    
    @GetMapping("/fail")
    public String topUpFail() {
    	System.out.println("==============");
		System.out.println("결제 요청 실패");
		System.out.println("==============");
    	return "redirect:/cart";
    }
    

}
