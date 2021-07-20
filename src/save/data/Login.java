package save.data;
public class Login {
    String result=null,username=null,role=null;
    int id;
    public void setResult(String result){
        this.result=result;
    }
    public String getResult(){
        return this.result;
    }
    public void setUsername(String username){
        this.username=username;
    }
    public String getUsername(){
        return this.username;
    }
    public void setRole(String role){
        this.role=role;
    }
    public String getRole(){
        return this.role;
    }
    public void setId(int id){
        this.id=id;
    }
    public int getId(){
        return this.id;
    }
}