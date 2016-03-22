{ React, ReactBootstrap, RouteHandler, Link, FontAwesome } = window
{ Grid, Col } = ReactBootstrap

Footer = require './footer'
Header = require './header'
ShopCar = require './shopcar'

UserMain = React.createClass
  render: ->
    <div>
      <Header />
      <RouteHandler />
      <Footer />
      <ShopCar />
    </div>

module.exports = UserMain
