{ React, ReactBootstrap, RouteHandler, loadURL, Route, FontAwesome } = window
{ Thumbnail, Nav, NavItem } = ReactBootstrap

AdminMain = React.createClass
  getInitialState: ->
    keys: ['#/dashboard', '#/booknumbers', '#/newbook', '#/ordermanager', '#/distribution']
    activeKey: 0
    active: ['nav-item-active', '', '', '', '']
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

  handleDirChange: (dir) ->
    @handleMenuSelect dir
  click: ->
    window.logout()
  render: ->
    <div className='flex-col'>
      <Nav className='nav-width' stacked activeKey={@state.activeKey} onSelect={this.handleMenuSelect}>
        <img className='nav-img' src='http://placehold.it/800x500' />
        <h3 className='nav-usn'>{window.UserName}</h3>
        <NavItem className={@state.active[0]} eventKey={0}>DashBoard</NavItem>
        <NavItem className={@state.active[1]} eventKey={1}>图书数量管理</NavItem>
        <NavItem className={@state.active[2]} eventKey={2}>图书上下/架</NavItem>
        <NavItem className={@state.active[3]} eventKey={3}>订单管理</NavItem>
        <NavItem className={@state.active[4]} eventKey={4}>物流管理</NavItem>
        <FontAwesome name='power-off' onClick={@click} style={fontSize: 27, paddingTop: 15} />
      </Nav>
      <div className='hun-div'>
        <RouteHandler />
      </div>
    </div>

module.exports = AdminMain
