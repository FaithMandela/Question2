/**
 * @author      Dennis W. Gichangi <dennis@openbaraza.org>
 * @version     2011.0329
 * @since       1.6
 * website		www.openbaraza.org
 * The contents of this file are subject to the GNU Lesser General Public License
 * Version 3.0 ; you may use this file in compliance with the License.
 */
package org.baraza.ide;

import java.util.logging.Logger;
import java.io.File;
import java.awt.Font;
import javax.swing.JFileChooser;
import javax.swing.JTextArea;
import javax.swing.JScrollPane;

import org.baraza.utils.Bio;

public class BFileEdit {
	Logger log = Logger.getLogger(BFileEdit.class.getName());
	public JScrollPane scrollPanes;
	File dbFile = null;
	String dbDirName = null;
	JTextArea textArea;
	Bio io;

	public BFileEdit(File lfile) {
		dbFile = lfile;
		textArea = new JTextArea();
		textArea.setTabSize(4);
		scrollPanes = new JScrollPane(textArea);

		io = new Bio();
		textArea.setText(io.loadFile(dbFile));
		textArea.setCaretPosition(0);

		textArea.setFont(new Font("Monospaced", Font.PLAIN, 12));
		Font font = textArea.getFont(); 
		//System.out.println(textArea.getTabSize() + " : " + font.getFontName());
	}

	public BFileEdit(String dbDirName) {
		this.dbDirName = dbDirName;
		textArea = new JTextArea();
		textArea.setTabSize(4);
		scrollPanes = new JScrollPane(textArea);

		io = new Bio();
	}

	public void saveFile() {
		if(dbFile == null) saveAsFile();
		else io.saveFile(dbFile, textArea.getText());
	}

	public void saveAsFile() {
		JFileChooser fc = new JFileChooser(dbDirName);
		int i = fc.showSaveDialog(textArea);
		if (i == JFileChooser.APPROVE_OPTION) {
            dbFile = fc.getSelectedFile();
			saveFile();
		}
	}

	public String getName() {
		String flName = "new.sql";
		if(dbFile != null) flName = dbFile.getName();
		return flName;
	}

	public String getText() {
		return textArea.getText();
	}

	public void setText(String mystr) {
		textArea.setText(mystr);
	}

	public void appendText(String mystr) {
		mystr += "\n" + mystr;
		textArea.append(mystr);
	}

}
