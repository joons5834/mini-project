package novel;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import episodes.EpisodesDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import main.NovelDAO;
import main.NovelDTO;
import main.NovelService;
import sale.SaleService;

@Controller
public class NovelController {

    @Autowired
    NovelDAO dao;
    @Autowired
    @Qualifier("novelservice")
    NovelService service;

    @Autowired
    @Qualifier("saleservice")
    SaleService saleService;

    @RequestMapping("/oneNovelPage") // id=novel_id
    public ModelAndView oneNovelPage(int id, int page, @RequestParam(required=false) String msg, HttpSession session) {
        ModelAndView mv = new ModelAndView();
        Object obj_user_id = session.getAttribute("loginid");
        int user_id = -1; 
        if(obj_user_id != null) {
        	user_id = (int) session.getAttribute("loginid");
        }
        NovelDTO noveldto = service.getOneNovel(id);
        int limit = (page - 1) * 7; // page처리 위해서
        int total_list = service.getTotalNovel(id); // 1번 소설 몇개인지 불러오기
        List<EpisodesDTO> list = service.getNovelList(id, limit); // 소설 리스트 불러오기
        List<Integer> myNovelList = new ArrayList<>();
        if(user_id != -1) {
        	myNovelList = service.getLibraries(user_id);
        }
        for (EpisodesDTO dto : list) {
            if (myNovelList.contains(dto.getId())) {
                dto.setPrice(0);
            }
        }
        mv.addObject("myNovelList", myNovelList);
        mv.addObject("dto", noveldto);
        mv.addObject("cnt", total_list);
        mv.addObject("list", list);
        mv.addObject("msg", msg);
        mv.setViewName("novel/oneNovelPage");
        return mv;
    }

    @PostMapping("/cartIn") // check => episode_id..
    public ModelAndView cartIn(Integer[] check, HttpServletRequest request) {
        ModelAndView mv = new ModelAndView();
        int user_id = Integer.parseInt(request.getParameter("user_id"));
        for (Integer episode_id : check) {
            service.insertCart(user_id, episode_id);
        }
        mv.setViewName("redirect:/cart?id=" + user_id);
        return mv;
    }

    @PostMapping("/buyNow")
    public ModelAndView buyNovel(int[] check, HttpServletRequest request) throws UnsupportedEncodingException {
        ModelAndView mv = new ModelAndView();
        int id = Integer.parseInt(request.getParameter("id")); //epi_id
        int user_id = Integer.parseInt(request.getParameter("user_id"));
        try {
            saleService.buyEpisodes(user_id, check);
        } catch (Exception e) {
        	String encodeResult = URLEncoder.encode("잔액 부족이거나 오류가 발생했습니다.", "UTF-8");
            mv.setViewName("redirect:/oneNovelPage?id=" + id + "&msg="+ encodeResult + "&page=1");
            return mv;
        }
        String encodeResult = URLEncoder.encode("구매에 성공했습니다.", "UTF-8");
        mv.setViewName("redirect:/oneNovelPage?id=" + id + "&msg="+ encodeResult + "&page=1");
        return mv;
    }

}















