ENV = require './env'
ENV.init()

{React, ReactDOM, ReactBootstrap, Router, Route, RouteHandler, DefaultRoute, $} = window
{Grid, Col} = ReactBootstrap

Login = require './login/login'
SignIn = require './login/signin'
SignUp = require './login/signup'

AdminMain = require './admin/index'
DashBoard = require './admin/dashboard'
NewBook = require './admin/new-book'
PutOn = require './admin/put-on'
PullOff = require './admin/pull-off'
BookNumbers = require './admin/book-numbers'
OrderManager = require './admin/order-manager'
Distribution = require './admin/distribution'

UserMain = require './user/index'
Homepage = require './user/homepage'
Infomanager = require './user/info-manager'
Addrmanager = require './user/addr-manager'
Shopcaritem = require './user/shopcaritem'
Search = require './user/search'
BookDeatil = require './user/book-detail'
ShopCar = require './user/shopcar'
Pay = require './user/pay'
Orders = require './user/orders'
UserHomepage = require './user/userhomepage'

Footer = require './components/footer'
Header = require './components/header'

DefaultPage = React.createClass
  render: ->
    <div>
      <Header />
      <RouteHandler />
      <Footer />
    </div>


window.defaultRoutes =
  <Route name='/' path="/" handler={DefaultPage}>
    <DefaultRoute handler={Homepage} />
    <Route name='homepage' path='homepage' handler={Homepage} />
    <Route name='search' path='search' handler={Search} />
    <Route name='bookdetail' path='bookdetail/:bookid' handler={BookDeatil} />
    <Route name='login' path='login' handler={Login}>
      <Route name='signin' path='signin' handler={SignIn} />
      <Route name='signup' path='signup' handler={SignUp} />
    </Route>
  </Route>

window.userRoutes =
  <Route name='/' path='/' handler={UserMain}>
    <DefaultRoute handler={Homepage} />
    <Route name='homepage' path='homepage' handler={Homepage} />
    <Route name='search' path='search' handler={Search} />
    <Route name='pay' path='pay' handler={Pay} />
    <Route name='bookdetail' path='bookdetail/:bookid' handler={BookDeatil} />
    <Route name='userhomepage' path='userhomepage' handler={UserHomepage}>
      <DefaultRoute handler={Infomanager} />
      <Route name='infomanager' path='infomanager' handler={Infomanager} />
      <Route name='addrmanager' path='addrmanager' handler={Addrmanager} />
      <Route name='shopcaritem' path='shopcaritem' handler={Shopcaritem} />
      <Route name='orders' path='orders' handler={Orders} />
    </Route>
  </Route>

window.adminRoutes =
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

Router.run window.defaultRoutes, Router.HashLocation, (Root) ->
  ReactDOM.render <Root />, $('app')
