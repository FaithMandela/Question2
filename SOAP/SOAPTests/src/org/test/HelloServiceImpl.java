package org.test;

import javax.jws.WebService;

import org.test.HelloService;

@WebService(endpointInterface = "org.tutorial.HelloService")
public class HelloServiceImpl implements HelloService {

	@Override
	public String hello(String name) {
		// TODO Auto-generated method stub
		return name;
	}

}
