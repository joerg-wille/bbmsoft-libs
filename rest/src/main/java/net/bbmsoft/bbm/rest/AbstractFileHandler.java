package net.bbmsoft.bbm.rest;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import org.eclipse.jetty.server.handler.AbstractHandler;

public abstract class AbstractFileHandler extends AbstractHandler {

	protected String readFile(String fileName) {

		try(BufferedReader reader = new BufferedReader(new FileReader(fileName))) {

			StringBuilder sb = new StringBuilder();

			reader.lines().forEach(line -> sb.append(line));

			return sb.toString();

		} catch(IOException e) {
			return "Error! Could not read file " + fileName;
		}

	}
}