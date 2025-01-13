package example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestHandler;


record LambdaEvent(String key1, String key2, String key3) {
}

// Handler value: example.Hello::handleRequest
public class Hello implements RequestHandler<LambdaEvent, String> {

  @Override
  public String handleRequest(LambdaEvent event, Context context) {
    LambdaLogger logger = context.getLogger();
    logger.log("String found: " + event.key1());

    return "OK";
  }
}
