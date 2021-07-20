package handle.data;
import save.data.Register;
import save.data.Space;
import java.sql.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.sql.DataSource;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import java.util.*;
import java.text.*;
public class HandleSpace extends HttpServlet{
    public void init(ServletConfig config) throws ServletException{
        super.init(config);
    }
    public void service(HttpServletRequest request,HttpServletResponse response)
        throws ServletException,IOException {
        request.setCharacterEncoding("utf-8");
        Connection con = null;
        Statement sql;
        Space spaceBean = new Space();
        request.setAttribute("spaceBean", spaceBean);
        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("blogConn");
            con = ds.getConnection();
            String condition = "select * from user where userid='"+request.getParameter("userid").trim()+"'";
            sql = con.createStatement();
            ResultSet rs = sql.executeQuery(condition);
            if (rs.next()){
                spaceBean.setUserId(rs.getInt(1));
                spaceBean.setUsername(rs.getString(2));
                spaceBean.setRole(rs.getString(4));
                spaceBean.setRegisterTime(rs.getString(5));
                spaceBean.setBirthday(rs.getString(6));
                spaceBean.setGender(rs.getString(7));
                spaceBean.setEmail(rs.getString(8));
                spaceBean.setPhone(rs.getString(9));
            }
        }
        catch (SQLException exp){
        }
        catch (NamingException exp){
        }
        finally {
            RequestDispatcher dispatcher = request.getRequestDispatcher("space.jsp");
            dispatcher.forward(request, response);
            try {
                con.close();
            }
            catch (Exception ee){
            }
        }
    }
}