package org.nfmedia.crms.action;

import java.math.BigDecimal;
import java.util.Map;

import org.apache.struts2.util.StrutsTypeConverter;

/**
 * struts2 BigDecimal和String转换器
 * @author: hongwei
 * @CreateDate: 2014-11-25 下午2:03:58 
 */
@SuppressWarnings("rawtypes")
public class BigDecimalConverter extends StrutsTypeConverter {

	/* (non-Javadoc)
	 * @see org.apache.struts2.util.StrutsTypeConverter#convertFromString(java.util.Map, java.lang.String[], java.lang.Class)
	 */
	@Override
	public Object convertFromString(Map context, String[] values, Class toClass) {
		BigDecimal bd = null;  
        if(BigDecimal.class ==toClass){  
            String bdStr = values[0];  
            if(bdStr!=null&&!"".equals(bdStr)){  
                bd = new BigDecimal(bdStr);  
            }else{  
                //bd = BigDecimal.valueOf(-1);  
            }  
            return bd;  
        }         
        return BigDecimal.ZERO;  
	}

	/* (non-Javadoc)
	 * @see org.apache.struts2.util.StrutsTypeConverter#convertToString(java.util.Map, java.lang.Object)
	 */
	@Override
	public String convertToString(Map context, Object o) {
		if(o instanceof BigDecimal){  
            BigDecimal b = new BigDecimal(o.toString()).setScale(2,BigDecimal.ROUND_HALF_DOWN);  
            return b.toString();  
        }         
        return o.toString();
	}

}
