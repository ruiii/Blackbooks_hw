{ React, ReactBootstrap, Link } = window
{ Grid, Col } = ReactBootstrap


Header = React.createClass
  getInitialState: ->
    active: ''
  handleBackClick: ->
    window.loadURL '/'
    @setState
      active: 'back'
  handleSearchClick: ->
    window.loadURL '/search'
    @setState
      active: 'search'
  handleHomepageClick: ->
    window.loadURL '/userhomepage'
    @setState
      active: 'userhomepage'
  handleOutClick: ->
    window.logout()
    @setState
      active: 'out'
  render: ->
    <div className='header'>
      <Grid className='header-center'>
        <Col className='header-col-left' md={3}>
          <Link to='/' className='icon'>BlackBooks</Link>
        </Col>
        <Col className='header-col-right' md={9}>
          <p onClick={@handleOutClick} className={if @state.active is 'out' then 'header-link active' else 'header-link'}>退出登录</p>
          <p onClick={@handleHomepageClick} className={if @state.active is 'userhomepage' then 'header-link active' else 'header-link'}>{window.UserName}</p>
          <p onClick={@handleSearchClick} className={if @state.active is 'search' then 'header-link active' else 'header-link'}> 搜  索 </p>
          <p onClick={@handleBackClick} className={if @state.active is 'back' then 'header-link active' else 'header-link'}>返回首页</p>
        </Col>
      </Grid>
    </div>

module.exports = Header;
