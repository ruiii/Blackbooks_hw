{ Router, Route, RouteHandler, DefaultRoute } = window

userRoutes =
  <Route name='/' path="/" handler={Pages}>
    <DefaultRoute handler={Homepage} />
    <Route name='login' path='login' handler={Login}>
      <Route name='signin' path='signin' handler={SignIn} />
      <Route name='signup' path='signup' handler={SignUp} />
    </Route>
    <Route name='index' path='index' handler={UserMain}>
      <DefaultRoute handler={Homepage} />
      <Route name='homepage' path='homepage' handler={Homepage} />
      <Route name='setting' path='setting' handler={Setting} />
      <Route name='search' path='search' handler={Search} />
      <Route name='shopcar' path='shopcar' handler={ShopCar} />
      <Route name='orders' path='orders' handler={Orders} />
    </Route>
  </Route>


adminRoutes =
  <Route name='/' path='/' handler={AdminMain}> # fix reload router() / fix pic upload
    <DefaultRoute handler={DashBoard} />
    <Route name='dashboard' path='dashboard' handler={DashBoard} />
    <Route name='newbook' path='newbook' handler={NewBook}>
      <DefaultRoute handler={PutOn} />
      <Route name='puton' path='puton' handler={PutOn} />
      <Route name='pulloff' path='pulloff' handler={PullOff} />
    </Route>
    <Route name='booknumbers' path='booknumbers' handler={BookNumbers} />
    <Route name='ordermanager' path='ordermanager' handler={OrderManager} />
    <Route name='distribution' path='distribution' handler={Distribution} />
  </Route>

module.exports = adminRoutes;
