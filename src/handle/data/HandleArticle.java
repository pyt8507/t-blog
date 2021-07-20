package handle.data;
import save.data.Article;
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
public class HandleArticle extends HttpServlet{
    public void init(ServletConfig config) throws ServletException{
        super.init(config);
    }
    public void service(HttpServletRequest request,HttpServletResponse response)
        throws ServletException,IOException {
        request.setCharacterEncoding("utf-8");
        Connection con = null;
        Statement sql;
        Article articleBean = new Article();
        request.setAttribute("articleBean", articleBean);
        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("blogConn");
            con = ds.getConnection();
            String condition = "select * from article where id='"+request.getParameter("articleId")+"'";
            articleBean.setId(request.getParameter("articleId"));
            sql = con.createStatement();
            ResultSet rs = sql.executeQuery(condition);
            if (rs.next()){
                articleBean.setTitle(rs.getString(2));
                articleBean.setUserId(rs.getInt(3));
                articleBean.setPostTime(rs.getString(4));
                articleBean.setKeywords(rs.getString(7));
                articleBean.setContent(rs.getString(8));
                articleBean.setComment(rs.getString(6));
                ResultSet rs2 = sql.executeQuery("select * from user where userid='"+rs.getInt(3)+"'");
                String username="";
                if (rs2.next())
                    username = rs2.getString(2);
                articleBean.setUserName(username);
            }
        }
        catch (SQLException exp){
        }
        catch (NamingException exp){
        }
        finally {
            RequestDispatcher dispatcher = request.getRequestDispatcher("article.jsp");
            dispatcher.forward(request, response);
            try {
                con.close();
            }
            catch (Exception ee){
            }
        }
    }
}