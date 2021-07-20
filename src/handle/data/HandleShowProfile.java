package handle.data;
import save.data.Profile;
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
public class HandleShowProfile extends HttpServlet{
    public void init(ServletConfig config) throws ServletException{
        super.init(config);
    }
    public void service(HttpServletRequest request,HttpServletResponse response)
        throws ServletException,IOException {
        request.setCharacterEncoding("utf-8");
        Connection con = null;
        Statement sql;
        Profile profileBean = new Profile();
        request.setAttribute("profileBean", profileBean);
        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("blogConn");
            con = ds.getConnection();
            String condition = "select * from user where userid='"+request.getParameter("userid").trim()+"'";
            sql = con.createStatement();
            ResultSet rs = sql.executeQuery(condition);
            if (rs.next()){
                profileBean.setUserid(rs.getInt(1));
                profileBean.setUsername(rs.getString(2));
                profileBean.setRole(rs.getString(4));
                profileBean.setBirthday(rs.getString(6));
                profileBean.setGender(rs.getString(7));
                profileBean.setEmail(rs.getString(8));
                profileBean.setPhone(rs.getString(9));
            }
        }
        catch (SQLException exp){
        }
        catch (NamingException exp){
        }
        finally {
            RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
            dispatcher.forward(request, response);
            try {
                con.close();
            }
            catch (Exception ee){
            }
        }
    }
}