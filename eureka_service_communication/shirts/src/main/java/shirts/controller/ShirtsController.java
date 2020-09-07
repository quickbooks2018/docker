package shirts.controller;




import com.netflix.discovery.EurekaClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;



@RestController
@RequestMapping("/shirts")

public class ShirtsController {


    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private EurekaClient eurekaClient;

    @GetMapping
    public String shirts()
    {

        return "Best Shirts In Pakistan";
    }

    @GetMapping("/calltoshoppingcart")
    public String welcome()
    {
        return restTemplate.getForObject("http://SHOPPING-CART/cart", String.class);
    }

}
