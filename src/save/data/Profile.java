package save.data;
public class Profile {
    int userid;
    String result,username,role,gender,birthday,email,phone;
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
    public void setGender(String gender){
        this.gender=gender;
    }
    public String getGender(){
        return this.gender;
    }
    public void setBirthday(String birthday){
        this.birthday=birthday;
    }
    public String getBirthday(){
        return this.birthday;
    }
    public void setEmail(String email){
        this.email=email;
    }
    public String getEmail(){
        return this.email;
    }
    public void setPhone(String phone){
        this.phone=phone;
    }
    public String getPhone(){
        return this.phone;
    }
    public void setUserid(int userid){
        this.userid=userid;
    }
    public int getUserid(){
        return this.userid;
    }
}