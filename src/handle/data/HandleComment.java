package handle.data;
import save.data.Comment;
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
public class HandleComment extends HttpServlet{
    public void init(ServletConfig config) throws ServletException{
        super.init(config);
    }
    public void service(HttpServletRequest request,HttpServletResponse response)
        throws ServletException,IOException {
        response.setCharacterEncoding("utf-8");
        Connection con = null;
        PreparedStatement sql = null;
        Comment commentBean = new Comment();
        request.setAttribute("commentBean", commentBean);
        String comment = request.getParameter("comment");
        String id = request.getParameter("id");
        String userid = request.getParameter("userid");

        if (comment == null) {
            String result = "请输入评论！";
            commentBean.setResult(result);
            RequestDispatcher dispatcher = request.getRequestDispatcher("articleServlet?articleId="+id);
            dispatcher.forward(request, response);
            return;
        }

        String result = "";
        try {
            Context context = new InitialContext();
            Context contextNeeded = (Context) context.lookup("java:comp/env");
            DataSource ds = (DataSource) contextNeeded.lookup("blogConn");
            con = ds.getConnection();
            ResultSet rs = null;
            String insertCondition = "INSERT INTO comment (articleId,userid,comment_time,comment_content) VALUES(?,?,?,?)";
            sql = con.prepareStatement(insertCondition);
            sql.setString(1, id);
            sql.setString(2, userid);
            sql.setTimestamp(3, new java.sql.Timestamp(System.currentTimeMillis()));
            sql.setString(4, comment);
            int m = sql.executeUpdate();
            if (m != 0)
                commentBean.setResult("发布成功！");
        } catch (SQLException exp) {
            commentBean.setResult("发布失败！" + exp);
        } catch (NamingException exp) {
            commentBean.setResult("没有设置连接池" + exp);
        } finally {
            try {
                con.close();
            } catch (Exception ee) {
            }
        }
        RequestDispatcher dispatcher = request.getRequestDispatcher("articleServlet?articleId="+id);
        dispatcher.forward(request, response);
    }
}