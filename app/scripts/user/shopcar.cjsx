{ React, ReactBootstrap,async } = window
{ Grid, Col, Row, Input, Button, Panel } = ReactBootstrap
globalSignal = require '../components/signal'
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

ShopItem = React.createClass
  getInitialState: ->
    num: @props.num
    inventory: @props.book.inventory
  handleNumChange: (e) ->
    bookname = e.target.parentNode.parentNode.parentNode.childNodes[1].childNodes[0].innerText
    num = @refs.num.getValue()
    if num is 0 or num is '' or num < 1
      num = 1
    if num > 1
      num = parseInt(num)
    if num > @state.inventory
      num = @state.inventory
    @props.changeNum num, bookname
    @setState
      num: num
  componentWillReceiveProps: (nextProps) ->
    if nextProps.num isnt @state.num
      @setState
        num: nextProps.num
  render: ->
    <Row>
      <Col md={4}>
        <img style={height: 40} src={@props.book.picture} />
      </Col>
      <Col md={6}>
        <h6>{@props.book.bookname}</h6>
      </Col>
      <Col md={2}>
        <Input type='number' value={@state.num} onChange={@handleNumChange}
               hasFeedback ref='num' id='NumInput'/>
      </Col>
      <hr />
    </Row>

ShopCar = React.createClass
  getInitialState: ->
    show: false
    books: []
    shopcarid:''
  show: ->
    @setState
      show: !@state.show
  componentDidMount: ->
    globalSignal.AddToCar.add @handleAddToCar
  componentWillMount: ->
    sendRequest [0], ["select distinct blackbooks.shopcar.shopcarid from blackbooks.shopcar,blackbooks.shopcaritem where blackbooks.shopcar.username= '#{window.UserName}';"],@done
  done: (res) ->
    shopcarid = res
    @setState
      shopcarid: shopcarid
    console.log 'shopcarid',res
  handleAddToCar: (event, res) ->
    newbook = true
    {books} = @state
    for book, index in books
      if book.book.bookname is res.book.bookname
        book.num += parseInt res.num
        newbook = false
    if newbook
      books.push {
        book: res.book
        num: res.num
      }
    @setState {books}

  changeNum: (num, bookname) ->
    console.log @state.books
    {books} = @state
    for book in books
      if book.book.bookname is bookname
        book.num = parseInt num
    @setState {books}
  handleClick: ->
    return if @state.books.length <= 0
    console.log 'shopcarid', window.shopcarid
    console.log '@state.books', @state.books
    sqls = []
    tasks = []
    for item, index in @state.books
      sqls.push "INSERT INTO BlackBooks.shopcaritem (`shopcarid`, `bookid`, `num`, `unitprice`) VALUES ('#{window.shopcarid}', '#{item.book.bookid}', '#{item.num}', '#{item.book.unitprice}');"
      tasks.push index
    sendRequest tasks, sqls, @pay
  pay: (res)->
    window.payBooks = @state.books
    window.loadURL '#/pay'
  render: ->
    <Panel className={if @state.show then 'car-show' else 'car-hidden'}>
      <Row>
        <Col md={9} mdOffset={1}>
          <h4 className='admin-title'>　购物车</h4>
        </Col>
        <Col md={2}>
          <Button className='car-plus' onClick={@show}>
            {if @state.show then '-' else '+'}
          </Button>
        </Col>
        <hr />
      </Row>
      <Grid style={padding: '10px 40px', overflow: 'scroll', height: 135}>
        <Row style={marginTop: '-20px'}>
          <Col md={6} mdOffset={4}>
            <h6>书名</h6>
          </Col>
          <Col md={2}>
            <h6>数量</h6>
          </Col>
          <hr />
        </Row>
      {
        for book, index in @state.books
          <ShopItem key={index}
                    book={book.book}
                    num={book.num}
                    changeNum={@changeNum} />
      }
      </Grid>
      <Row>
        <Col md={6} mdOffset={3}>
          <Button onClick={@handleClick} block>
            结算
          </Button>
        </Col>
      </Row>
    </Panel>

module.exports = ShopCar
