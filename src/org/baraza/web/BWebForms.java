/**
 * @author      Dennis W. Gichangi <dennis@openbaraza.org>
 * @version     2011.0329
 * @since       1.6
 * website		www.openbaraza.org
 * The contents of this file are subject to the GNU Lesser General Public License
 * Version 3.0 ; you may use this file in compliance with the License.
 */
package org.baraza.web;

import org.apache.poi.poifs.filesystem.*;
import org.apache.poi.hssf.usermodel.*;

import java.util.logging.Logger;
import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.text.SimpleDateFormat;
import java.text.ParseException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.File;
import java.io.InputStream;
import java.io.IOException;
import java.io.PrintWriter;

import java.sql.SQLException;

import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;

import org.baraza.DB.BDB;
import org.baraza.DB.BQuery;
import org.baraza.xml.BXML;
import org.baraza.xml.BElement;
import org.baraza.utils.BNumberFormat;
import org.baraza.utils.BCipher;

public class BWebForms {
	Logger log = Logger.getLogger(BWebForms.class.getName());
	Map<String, String> answers;
	Map<String, String> subanswers;
	String fhead, ffoot;

	BDB db = null;
	String access_text = null;

	public BWebForms(String dbconfig) {
		db = new BDB(dbconfig);
	}

	public BWebForms(String dbconfig, String at) {
	    db = new BDB(dbconfig);
	    access_text = at;
	}

	public String getWebForm(String entryformid, Map<String, String[]> sParams) {

		String mystr = "";

		answers = new HashMap<String, String>();
		subanswers = new HashMap<String, String>();

		Map<String, String[]> params = new HashMap<String, String[]>(sParams);

		return mystr;
	}

	public void close() {
		if(db != null) db.close();
	}

}
