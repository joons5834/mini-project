package sale;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("saleservice")
@Transactional
public class SaleServiceImpl implements SaleService {

    @Autowired
    SaleDAO dao;

    @Override
    public int getNumberOfItems(int userId) {
        return dao.getNumberOfItems(userId);
    }
 
    @Override
    public List<ItemDTO> getCartItems(int id) {
        return dao.getCartItems(id);
    }

    @Override
    public void deleteCartItem(int id) {
        dao.deleteCartItem(id);
    }

    @Override
    public void buyEpisodes(int userId, int[] episodeIds) throws Exception {
        int totalPrice = dao.getTotalPrice(episodeIds);
        int balance = dao.getBalance(userId);
        if (totalPrice > balance) {
            throw new Exception("Not enough Balance");
        }
        dao.subtractSand(userId, totalPrice);
        dao.addToLibrary(userId, episodeIds);
        dao.clearCart(userId, episodeIds);
    }

    @Override
    public int getBalance(int id) {
        return dao.getBalance(id);
    }

	@Override
	public int addBalance(int userId, int amount) {
		try {
			dao.addBalance(userId, amount);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return -1;
		}
		return 0;
	}
    
    


}
