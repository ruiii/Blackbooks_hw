{ React, ReactBootstrap, FontAwesome, Link, FETCHING_DATA, GOT_DATA } = window
{ Grid, Col, Row, Panel } = ReactBootstrap

sendRequest = (tasks, sqls, done) ->
  async.waterfall([ ((callback) ->
    window.sendRequest(tasks, sqls, ((res) ->
      callback null, res
    ))
  ),
  ((res, callback) ->
    console.log res
    done res
    callback null, res
  )], ((err, res) ->
    console.log 'err', err
  ))

orders = 0
dists = 0

OrderHeader_wait =
    <Row>
      <Col md={3}>
        <FontAwesome className='panel-fontawsome' name='shopping-cart' />
      </Col>
      <Col md={9} className='panel-numbers-continer'>
        <Row>
          <span className='fa fa-spinner fa-pulse'></span>
        </Row>
        <Row>
          <span className='panel-text'>新订单!</span>
        </Row>
      </Col>
    </Row>

DistHeader_wait =
    <Row>
      <Col md={3}>
        <FontAwesome className='panel-fontawsome' name='tasks' />
      </Col>
      <Col md={9} className='panel-numbers-continer'>
        <Row>
          <i className="fa fa-spinner fa-pulse"></i>
        </Row>
        <Row>
          <span className='panel-text'>需发货!</span>
        </Row>
      </Col>
    </Row>

OrderFooter =
  <div>
    <p className='panel-check y'>查看详情</p>
    <p className='panel-arrow y'> <FontAwesome name='arrow-circle-right' /> 订单管理</p>
  </div>

DistFooter =
  <div>
    <p className='panel-check r'>查看详情</p>
    <p className='panel-arrow r'> <FontAwesome name='arrow-circle-right' /> 物流管理</p>
  </div>

DashBoard = React.createClass
  getInitialState: ->
    status: FETCHING_DATA
    OrderHeader: ''
    DistHeader: ''
  componentDidMount: ->
    sendRequest [0, 1], ['select * from BlackBooks.orders;', 'select * from BlackBooks.orders where orderstatus=1;'], @orDone
  orDone: (res) ->
    if res[0]? and res[1]?
      orders = res[0].length
      dists = res[1].length
      @setState
        status: GOT_DATA
        OrderHeader:
            <Row>
              <Col md={3}>
                <FontAwesome className='panel-fontawsome' name='shopping-cart' />
              </Col>
              <Col md={9} className='panel-numbers-continer'>
                <Row>
                  <span className='panel-numbers'>{orders}</span>
                </Row>
                <Row>
                  <span className='panel-text'>新订单!</span>
                </Row>
              </Col>
            </Row>
        DistHeader:
            <Row>
              <Col md={3}>
                <FontAwesome className='panel-fontawsome' name='tasks' />
              </Col>
              <Col md={9} className='panel-numbers-continer'>
                <Row>
                  <span className='panel-numbers'>{dists}</span>
                </Row>
                <Row>
                  <span className='panel-text'>需发货!</span>
                </Row>
              </Col>
            </Row>
  render: ->
    <Grid>
      <Row>
        <h3 className='admin-title'>　DashBoard</h3>
        <hr />
      </Row>
      <Row style={position: 'absolute', top: '30%', left: '30%', width: '100%', height: '100%'}>
        <Col md={3}>
          {
            if @state.status is FETCHING_DATA
              <Panel bsStyle='warning' header={OrderHeader_wait} footer={OrderFooter} />
            else
              <Panel bsStyle='warning' header={@state.OrderHeader} footer={OrderFooter} />
          }
        </Col>
        <Col md={3}>
          {
            if @state.status is FETCHING_DATA
              <Panel bsStyle='danger' header={DistHeader_wait} footer={DistFooter} />
            else
              <Panel bsStyle='danger' header={@state.DistHeader} footer={DistFooter} />
          }
        </Col>
        <Col md={6}>
        </Col>
      </Row>
    </Grid>

module.exports = DashBoard
