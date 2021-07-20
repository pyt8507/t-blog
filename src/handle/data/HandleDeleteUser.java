package handle.data;
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
public class HandleDeleteUser extends HttpServlet{
    public void init(ServletConfig config) throws ServletException{
        super.init(config);
    }
    public void service(HttpServletRequest request,HttpServletResponse response)
        throws ServletException,IOException {
        response.setCharacterEncoding("utf-8");
        Connection con = null;
        Statement sql;
        String userId = request.getParameter("userId").trim();
        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("blogConn");
            con = ds.getConnection();
            sql = con.createStatement();
            sql.executeUpdate("delete from user where userid='"+userId+"'");
        } catch (SQLException exp) {
        } catch (NamingException exp) {
        } finally {
            try {
                con.close();
            } catch (Exception ee) {
            }
        }
            response.sendRedirect("usermanage.jsp");
    }
}