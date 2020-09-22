package shirts.controller;




import com.netflix.discovery.EurekaClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;



@RestController


public class ShirtsController {

    /**
     * DevOps Muhammad Asim
     * Tutorial to Setup an Environment Variable For AWS SECRET MANAGER
     * E-Mail: <quickbooks2018@gmail.com>
     * Youtube Channel: https://www.youtube.com/c/AWSLinuxWindows
     */
    /**
     * Environmental Variable Setup For DockerFile
     */
    @Value("${SHIRT_SIZE:wrongvalue}")
    private String shirt_size;

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private EurekaClient eurekaClient;

    /**
     *
     * Calling Environmental Variable to USE with AWS Secret Manager
     */

    @RequestMapping(value = "/shirts", method = RequestMethod.GET)
    public String getShirtSize()
    {

        return shirt_size;
    }

    @GetMapping("/calltoshoppingcart")
    public String welcome()
    {
        return restTemplate.getForObject("http://SHOPPING-CART/cart", String.class);
    }

}
