package com.ssj.util;

import java.net.URLEncoder;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.web.servlet.view.document.AbstractExcelView;

import com.ssj.util.PageData;
import com.ssj.util.Tools;
/**
* 导入到EXCEL
* 类名称：ObjectExcelView.java
* @author 史硕俊
* @version 1.0
 */
public class ObjectExcelView extends AbstractExcelView{

	@SuppressWarnings({ "unchecked", "deprecation" })
	@Override
	protected void buildExcelDocument(Map<String, Object> model,
			HSSFWorkbook workbook, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// TODO Auto-generated method stub
		Date date = new Date();
		String filename = Tools.date2Str(date, "yyyyMMddHHmmss");
		HSSFSheet sheet;
		HSSFCell cell;
		Object title_end = model.get("title");//文件名后缀
		if(title_end !=null){
			filename = filename+"-"+title_end.toString();
		}
		filename = filename+".xls";
		filename = ObjectExcelView.encodeFilename(filename, request);//处理中文文件名  
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition", "attachment;filename="+filename);
		sheet = workbook.createSheet("sheet1");
		
		List<String> titles = (List<String>) model.get("titles");//标题
		
		int len = titles.size();
		HSSFCellStyle headerStyle = workbook.createCellStyle(); //标题样式
		headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		headerStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		HSSFFont headerFont = workbook.createFont();	//标题字体
		headerFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		headerFont.setFontHeightInPoints((short)11);
		headerStyle.setFont(headerFont);
		short width = 20,height=25*20;
		sheet.setDefaultColumnWidth(width);
		for(int i=0; i<len; i++){ //设置标题
			String title = titles.get(i);
			cell = getCell(sheet, 0, i);
			cell.setCellStyle(headerStyle);
			setText(cell,title);
		}
		sheet.getRow(0).setHeight(height);
		
		HSSFCellStyle contentStyle = workbook.createCellStyle(); //内容样式
		contentStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		List<PageData> varList = (List<PageData>) model.get("varList");
		int varCount = varList.size();
		for(int i=0; i<varCount; i++){
			PageData vpd = varList.get(i);
			for(int j=0;j<len;j++){
				String varstr = vpd.getString("var"+(j+1)) != null ? vpd.getString("var"+(j+1)) : "";
				cell = getCell(sheet, i+1, j);
				cell.setCellStyle(contentStyle);
				setText(cell,varstr);
			}
			
		}
		
	}
	public static String encodeFilename(String filename, HttpServletRequest request) {    
	      /**  
	       * 获取客户端浏览器和操作系统信息  
	       * 在IE浏览器中得到的是：User-Agent=Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; Maxthon; Alexa Toolbar)  
	       * 在Firefox中得到的是：User-Agent=Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.7.10) Gecko/20050717 Firefox/1.0.6  
	       */    
	      String agent = request.getHeader("USER-AGENT");    
	      try {    
	        if ((agent != null) && (-1 != agent.indexOf("MSIE"))) {    
	          String newFileName = URLEncoder.encode(filename, "UTF-8");    
	          newFileName = StringUtils.replace(newFileName, "+", "%20");    
	          if (newFileName.length() > 150) {    
	            newFileName = new String(filename.getBytes("GB2312"), "ISO8859-1");    
	            newFileName = StringUtils.replace(newFileName, " ", "%20");    
	          }    
	          return newFileName;    
	        }    
	        if ((agent != null) && (-1 != agent.indexOf("Mozilla")))    
	          return MimeUtility.encodeText(filename, "UTF-8", "B");    
	      
	        return filename;    
	      } catch (Exception ex) {    
	        return filename;    
	      }    
	    }   

}
