{ React, ReactBootstrap, $ } = window
{ Grid, Row, Col, Button, Panel } = ReactBootstrap

height = window.innerHeight * 0.88

NewBook = React.createClass
  getInitialState: ->
    activeBtn: 'on'
  handleOnClick: ->
    if @state.activeBtn is 'on'
      return 0
    window.loadURL '#/newbook/puton'
    @setState
      activeBtn: 'on'
  handleOffClick: ->
    if @state.activeBtn is 'off'
      return 0
    window.loadURL '#/newbook/pulloff'
    @setState
      activeBtn: 'off'
  render: ->
    <Grid>
      <Row>
        <h3 className='admin-title'>　图书上/下架</h3>
        <hr />
      </Row>
      <Row>
        <Col md={3} style={height: height}>
          <Panel style={height: '100.7%', padding: '70px 0'}>
            <Button className={if @state.activeBtn is 'on' then 'nav-btn active' else 'nav-btn'} onClick={@handleOnClick}>
              图书上架
            </Button>
            <Button className={if @state.activeBtn is 'off' then 'nav-btn active' else 'nav-btn'} onClick={@handleOffClick}>
              图书下架
            </Button>
          </Panel>
        </Col>
        <Col md={9}>
          <RouteHandler />
        </Col>
      </Row>
    </Grid>

module.exports = NewBook
