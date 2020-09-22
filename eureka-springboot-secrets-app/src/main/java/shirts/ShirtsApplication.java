package shirts;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.client.loadbalancer.LoadBalanced;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@EnableDiscoveryClient
@SpringBootApplication
public class ShirtsApplication {

	public static void main(String[] args) {
		SpringApplication.run(ShirtsApplication.class, args);
	}

}

@Configuration

class ConfigShirts {

//	@Bean
//	@LoadBalanced
//	public RestTemplate restTemplate()
//	{
//		return new RestTemplate();
//	}

	@Bean
	@LoadBalanced
	public RestTemplate restTemplate(RestTemplateBuilder builder) {
		return builder.build();
	}
}
