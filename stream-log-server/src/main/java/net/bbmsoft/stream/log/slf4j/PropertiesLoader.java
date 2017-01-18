package net.bbmsoft.stream.log.slf4j;

import java.util.Properties;

public interface PropertiesLoader {

	public static final String PROPERTY_KEY_HOST = "host";
	public static final String PROPERTY_KEY_PORT = "port";
	public static final String PROPERTY_KEY_CLIENT_NAME = "name";
	public static final String PROPERTY_KEY_LOG_LEVEL = "level";

	public abstract Properties load();

}
