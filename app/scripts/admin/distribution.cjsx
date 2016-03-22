{ React, ReactBootstrap, FETCHING_DATA, GOT_DATA } = window
{ Grid, Row, Col, Button, Panel, Accordion } = ReactBootstrap

SimpleModal = require '../components/simple-modal'

sendRequest = (tasks, sqls, done) ->
  async.waterfall([ ((callback) ->
    window.sendRequest(tasks, sqls, ((res) ->
      callback null, res
    ))
  ),
  ((res, callback) ->
    done res
    callback null, res
  )], ((err, res) ->
    console.log 'err', err
  ))

Distribution = React.createClass
  getInitialState: ->
    orderStatus: ['', '未付款', '未发货', '已发货', '已取消', '已完成']
    orders: []
    order: ''
    orderid: ''
    check: false
    title: ''
    body: ''
    showModal: false
    status: FETCHING_DATA
  componentWillMount: ->
    sendRequest [0], ['select * from Blackbooks.orders where orderstatus=2;'], @done
  done: (res) ->
    console.log 'res', res
    if res[0].changedRows is 1
      @reSend()
      @setState
        title: '成功'
        body: '发货成功。'
        showModal: true
        status: FETCHING_DATA
        check: false
    else if res[0]?[0]?.addressdetail?
      @setState
        order: res
        status: GOT_DATA
        check: true
    else
      @setState
        orders: res[0]
        status: GOT_DATA
  reSend: ->
    sendRequest [0], ['select * from Blackbooks.orders where orderstatus=2;'], @done
  handleClick: ->
    sendRequest [0], ["UPDATE BlackBooks.orders SET orderstatus='3' WHERE orderid=#{@state.orderid};"], @done
  close: ->
    @setState
      showModal: false
  handleOrderClose: ->
    @setState
      check: false
  handleCheckOrders: (orderid) ->
    for order in @state.orders
      if order.orderid is orderid
        addressid = order.addressid
    sendRequest [0, 1], ["SELECT username, receivername, receivertel , addressdetail FROM BlackBooks.addressitem where addressid=#{addressid};", "SELECT * FROM BlackBooks.container where orderid=#{orderid};"], @done
    @setState
      orderid: orderid
  render: ->
    <Grid>
      <SimpleModal title={@state.title} body={@state.body} showModal={@state.showModal} close={@close} />
      <Row>
        <h3 className='admin-title'>　物流管理</h3>
        <hr />
      </Row>
      <Row>
        <Accordion style={paddingLeft: '10%'}>
        {
          if @state.status is FETCHING_DATA
            <span className='fa fa-spinner fa-pulse' style={fontSize: 40, position: 'absolute', top: '45%', left: '50%'}></span>
          else
            for order, index in @state.orders
              header = <h6>订单号： {order.orderid} 下单时间： {order.orderdate} 用户名： {order.username}</h6>
              <Panel header={header} key={index} style={width: '80%', margin: 15}>
                <Button onClick={@handleCheckOrders.bind(@, order.orderid)}>查看</Button>
              </Panel>
        }
        </Accordion>
      </Row>
      {
        if @state.order.length > 0
          <Grid className={if @state.check then 'order-show' else 'hidden'}>
            <div className='order-baks'>
              <Row style={margin: 45, padding: 15}>
                <Col md={2} mdOffset={2}>
                  <h6>用户名： {@state.order[0][0].username}</h6>
                </Col>
                <Col md={2}>
                  <h6>收货人： {@state.order[0][0].receivername}</h6>
                </Col>
                <Col md={3}>
                  <h6>电话： {@state.order[0][0].receivertel}</h6>
                </Col>
                <Col md={2}>
                  <Button className='car-plus' onClick={@handleOrderClose}>
                    X
                  </Button>
                </Col>
              </Row>
              <Row style={margin: 45, padding: 15}>
                  <h6>地址： {@state.order[0][0].addressdetail}</h6>
              </Row>
              <Grid style={marginLeft: '20%'}>
                <Row>
                  <Col md={4} mdOffset={1}>图书编号</Col>
                  <Col md={6}>图书数量</Col>
                </Row>
                {
                  for book, idx in @state.order[1]
                    <Row key={idx}>
                      <Col md={4} mdOffset={1}>{book.bookid}</Col>
                      <Col md={6}>{book.num}</Col>
                    </Row>
                }
                <Row>
                  <Col md={6}>
                    <Button onClick={@handleClick} block>发货</Button>
                  </Col>
                </Row>
              </Grid>
            </div>
          </Grid>
      }
    </Grid>

module.exports = Distribution
