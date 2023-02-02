package sale;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface SaleDAO {

    public int getNumberOfItems(int userId);

    public List<ItemDTO> getCartItems(int id);

    public void deleteCartItem(int id);

    public int getTotalPrice(int[] episodeIds);

    public int[] getCartEpisodeIds(int userId);

    public void subtractSand(@Param("userId") int userId, @Param("totalPrice") int totalPrice);

    public void addToLibrary(@Param("userId") int userId, @Param("episodeIds") int[] episodeIds);

    public void clearCart(@Param("userId") int userId, @Param("episodeIds") int[] episodeIds);

    public int getBalance(int id);

	public void addBalance(@Param("userId") int userId, @Param("amount")int amount);

}
