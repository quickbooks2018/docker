package shoppingcart.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/cart")

public class ShoppingCartController {


    @GetMapping
    public String shoppingcart()
    {
        return "All you buy from us, will show in Shopping Cart";
    }

}
