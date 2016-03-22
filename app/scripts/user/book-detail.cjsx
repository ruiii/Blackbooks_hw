{ React, ReactBootstrap, FETCHING_DATA, GOT_DATA, Link } = window
{ Grid, Row, Col, PageHeader, Button, Input, OverlayTrigger, Tooltip } = ReactBootstrap
globalSignal = require '../components/signal'
SimpleModal = require '../components/simple-modal'

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

BookDeatil = React.createClass
  getInitialState: ->
    console.log 'window.book', window.book
    book: window.book
    booktypes: ['', '文学', '小说', '传记', '少儿', '经济管理', '教育', '生活', '人文社科', '科技', '期刊', '英文原版']
    num: 0
    btnDisabled: true
    title: ''
    body: ''
    showModal: false
    relativeBook: []
    status: FETCHING_DATA
  componentWillMount: ->
    sendRequest [0], ["select * from BlackBooks.books where booktype=#{window.book.booktype} limit 0,4;"], @done
  componentDidMount: ->
    globalSignal.ReadBookDetail.add @handleNewBook
  handleNewBook: ->
    console.log @state.book, 's/w', window.book
    if @state.book isnt window.book
      @setState
        book: window.book
  done: (res) ->
    @setState
      relativeBook: res[0]
      status: GOT_DATA
  handleNumChange: ->
    btnDisabled = false
    num = @refs.num.getValue()
    if num is 0 or num is ''
      if !@state.btnDisabled
        btnDisabled = true
    if num < 1
      num = 0
      btnDisabled = true
    if num > 1
      num = parseInt(num)
    if num > @state.book.inventory
      num = @state.book.inventory
    @setState
      num: num
      btnDisabled: btnDisabled
  handlePicClick: (key) ->
    window.book = @state.relativeBook[key]
    globalSignal.ReadBookDetail.dispatch 'read-book-detail', {book: window.book}
  handlePayClick: ->

  handleAddToCarClick: ->
    if window.UserName.length > 0
      globalSignal.AddToCar.dispatch 'add-to-car', {num: @state.num, book: @state.book}
    else
      @setState
        title: '啊咧？'
        body: '请先登录。'
        showModal: true
  close: ->
    @setState
      showModal: false
  render: ->
    if @state.status is FETCHING_DATA
      <div style={height: 1100, width: 768}>
        <span className='fa fa-spinner fa-pulse' style={fontSize: 40, position: 'absolute', top: '45%', left: '50%'}></span>
      </div>
    else
      <Grid className='header-center'>
        <SimpleModal title={@state.title} body={@state.body} showModal={@state.showModal} close={@close}/>
        <Row>
          <Col md={12} style={marginTop: 20}>
            <h6 style={marginLeft: 37}>{@state.booktypes[@state.book.booktype]} >{@state.book.bookname}</h6>
            <hr />
          </Col>
        </Row>
        <Row style={padding: 15}>
          <Col md={7}>
            <img responsive src={@state.book.picture} alt={@state.book.bookname}
                 style={width: '100%', height: '100%'} />
          </Col>
          <Col md={5} style={padding: 25}>
            <Row>
              <h3 style={textAlign: 'center'}>{@state.book.bookname}</h3>
              <p style={padding: 7}>作者：  {@state.book.author}</p>
              <p style={padding: 7}>出版社： {@state.book.pubhouse}</p>
              <p style={padding: 7}>简介：  {@state.book.introduce}</p>
            </Row>
            <Row style={margin: 20}>
              <Col md={6}>
                <h5>价格： {@state.book.unitprice}</h5>
              </Col>
              <Col md={3}>
                <Input type='number' value={@state.num} onChange={@handleNumChange}
                       hasFeedback ref='num' id='NumInput'/>
              </Col>
              <Col md={3}>
                <h6>库存： {@state.book.inventory}</h6>
              </Col>
            </Row>
            <Row style={margin: 20}>
              <Col md={5} mdOffset={1}>
                <Button onClick={@handlePayClick} disabled={@state.btnDisabled}>
                  立即购买
                </Button>
              </Col>
              <Col md={5}>
                <Button onClick={@handleAddToCarClick} disabled={@state.btnDisabled}>
                  加入购物车
                </Button>
              </Col>
            </Row>
          </Col>
        </Row>
        <Row>
          <Row>
            <Col md={12}>
              <PageHeader><small>类似图书</small></PageHeader>
            </Col>
          </Row>
          <Row style={padding: 15}>
          {
            for book, index in @state.relativeBook
              continue if book.bookid is @state.book.bookid
              <OverlayTrigger key={index} onClick={@handlePicClick.bind(@, index)} placement='top' overlay={
                <Tooltip id='intro'>
                  {book.bookname}
                </Tooltip>
                }>
                <Col key={book.bookid} md={3}>
                  <Link to='bookdetail' params={{bookid: book.bookid}}>
                    <img responsive src={book.picture} alt={book.bookname}
                         style={width: '100%', height: '100%'} />
                  </Link>
                </Col>
              </OverlayTrigger>
          }
          </Row>
        </Row>
      </Grid>

module.exports = BookDeatil
