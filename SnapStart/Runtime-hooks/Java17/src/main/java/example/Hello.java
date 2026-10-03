package example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import org.crac.Resource;
import org.crac.Core;

record LambdaEvent(String key1, String key2, String key3) {
}

// Handler value: example.Hello::handleRequest
public class Hello implements RequestHandler<LambdaEvent, String>, Resource {
  
  public Hello() {
    Core.getGlobalContext().register(this);
  }

  @Override
  public String handleRequest(LambdaEvent event, Context context) {
    LambdaLogger logger = context.getLogger();
    logger.log("String found: " + event.key1());

    return "OK";
  }

  @Override
  public void beforeCheckpoint(org.crac.Context<? extends Resource> context)
      throws Exception {
    System.out.println("Before checkpoint");
  }

  @Override
  public void afterRestore(org.crac.Context<? extends Resource> context)
      throws Exception {
    System.out.println("After restore");
  }
}
