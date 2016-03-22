{ React, ReactBootstrap, RouteHandler, loadURL, Route } = window
{ Thumbnail, Nav, NavItem, Col, Grid, Row } = ReactBootstrap

UserHomepage = React.createClass
  getInitialState: ->
    keys: ['#/userhomepage/infomanager', '#/userhomepage/addrmanager', '#/userhomepage/orders', '#/userhomepage/shopcaritem']
    activeKey: 0
    active: ['nav-item-active', '', '', '']
  #componentWillMount: ->
  #  console.log 'willmount', window.activeKey
  #  @handleMenuSelect window.activeKey

  handleMenuSelect: (selectedKey) ->
    if selectedKey isnt @state.activeKey
      {active} = @state
      active[@state.activeKey] = ''
      active[selectedKey] = 'nav-item-active'
      loadURL @state.keys[selectedKey]
      @setState
        activeKey: selectedKey
        active: active

  render: ->
    <div style={display: 'flex', width: '100%', height: '100%'}>
      <Nav className='nav-width' stacked activeKey={@state.activeKey} onSelect={this.handleMenuSelect}>
        <img className='nav-img' src='http://placehold.it/800x500' />
        <h3 className='nav-usn'>{window.UserName}</h3>
        <NavItem className={@state.active[0]} eventKey={0}>个人信息</NavItem>
        <NavItem className={@state.active[1]} eventKey={1}>收货地址</NavItem>
        <NavItem className={@state.active[2]} eventKey={2}>个人订单</NavItem>
        <NavItem className={@state.active[3]} eventKey={3}>购物车</NavItem>
      </Nav>
      <div style={width: '80%'}>
        <RouteHandler />
      </div>
    </div>

module.exports = UserHomepage
