package shionn.ubk.cache;

import java.lang.reflect.Method;

import org.springframework.cache.interceptor.KeyGenerator;
import org.springframework.stereotype.Component;

@Component("MethodNameKeyGenerator")
public class MethodNameKeyGenerator implements KeyGenerator {

	@Override
	public Object generate(Object target, Method method, Object... params) {
		return target.getClass().getSimpleName() + "." + method.getName();
	}

}
