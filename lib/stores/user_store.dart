class UserStore {
  bool loggedIn = false;
  bool isRegister = false;


  void setLogStatus(bool status) {
    loggedIn = status;
  }
void setRegisterStatus(bool status) {
  isRegister = status;
  }
}