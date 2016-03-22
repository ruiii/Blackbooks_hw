{ React, ReactBootstrap } = window
{ Grid, Row, Col, Panel, Accordion, Button } = ReactBootstrap
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

order = ['ni', 'hhh']

OrderManager = React.createClass
  getInitialState: ->
    footer: <Button onClick={@handleEditClick}>编辑</Button>
    orders: ''
    detail: ''
    status: [null,'未付款','未发货','已发货','已取消','交易完成']
  componentDidMount: ->
    sendRequest [0,1], ['select * from BlackBooks.orders;','select * from BlackBooks.orders,BlackBooks.container,blackbooks.books where BlackBooks.orders.orderid = BlackBooks.container.orderid and BlackBooks.container.bookid = BlackBooks.books.bookid;'],@orderl
  orderl: (res)->
    @setState
      orders: res[0]
      detail: res[1]
    console.log '订单列表',res[0]
    console.log '图书详情',res[1]
  handleEditClick: (e) ->
    console.log e.target.parentNode.parentNode.childNodes[0].childNodes[0].innerText # orders[index]
  render: ->
    <Grid>
      <Row>
        <h3 className='admin-title'>　订单管理</h3>
        <hr />
      </Row>
      <Accordion>
      {
        if @state.orders isnt null
          for order, index in @state.orders
            <Panel key={index} footer={@state.footer} header={
              <Row>
                <Col md={4} >
                    订单号：{order.orderid}
                </Col>
              </Row>}>
              <Row>
                <Col md={4}>
                  {
                    for book,index in @state.detail
                      if order.orderid is book.orderid
                        <Col>
                          {book.bookname}
                        </Col>
                  }
                </Col>
                <Col md={3}>
                  ￥{order.price}
                </Col>
                <Col md={2}>
                  <Row>
                    {@state.status[order.orderstatus]}
                  </Row>
                </Col>
                <Col md={3}>
                </Col>
              </Row>
            </Panel>
      }
      </Accordion>
    </Grid>

module.exports = OrderManager
