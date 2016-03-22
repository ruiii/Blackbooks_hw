{ React, ReactBootstrap, Link } = window
{ Grid, Col } = ReactBootstrap


Header = React.createClass
  getInitialState: ->
    active: ''
  handleUClick: ->
    @setState
      active: 'u'
  handleIClick: ->
    @setState
      active: 'i'
  handleSClick: ->
    @setState
      active: 's'
  render: ->
    <div className='header'>
      <Grid className='header-center'>
        <Col className='header-col-left' xs={12} md={8}>
          <Link to='/' className='icon'>BlackBooks</Link>
        </Col>
        <Col className='header-col-right' xs={6} md={4}>
          <Link to='/login/signup' onClick={@handleUClick} className={if @state.active is 'u' then 'header-link active' else 'header-link'}>注　册</Link>
          <Link to='/login/signin' onClick={@handleIClick} className={if @state.active is 'i' then 'header-link active' else 'header-link'}>登　录</Link>
          <Link to='/search' onClick={@handleSClick} className={if @state.active is 's' then 'header-link active' else 'header-link'}>搜　索</Link>
        </Col>
      </Grid>
    </div>

module.exports = Header;
