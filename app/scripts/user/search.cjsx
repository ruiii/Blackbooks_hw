{ React, ReactBootstrap, FontAwesome, async, Link } = window
{ Grid, Row, Col, Input, DropdownButton, MenuItem, Button, Accordion, Panel, Thumbnail, ListGroup, ListGroupItem, OverlayTrigger, Tooltip } = ReactBootstrap
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

BookBlock = React.createClass
  handler: ->
    #window.Router.HashLocation.getCurrentPath()
    window.book = @props.book
    #window.loadURL '#/bookdetail:bookid'

  render: ->
    <Thumbnail src={@props.book.picture} alt={@props.book.bookname}>
      <div>
        <h5 className='book-text'>{@props.book.bookname}</h5>
        <h6 className='book-text'>作者： {@props.book.author}</h6>
      </div>
      <OverlayTrigger placement='right' overlay={
        <Tooltip id='intro'>
          {@props.book.introduce}
        </Tooltip>
        }>
        <div className='intro-text-box'>{@props.book.introduce}</div>
      </OverlayTrigger>
      <p style={display: 'flex', flexDirection: 'row', justifyContent: 'space-around', height: 40}>
        <Button bsStyle='primary' style={paddingTop: 0}><h5>￥{@props.book.unitprice}</h5></Button>
        <Button bsStyle='default' style={paddingTop: 0} onClick={@handler}>
          <Link to='bookdetail' params={{bookid: @props.book.bookid}}><h5>去看看</h5></Link>
        </Button>
      </p>
    </Thumbnail>

Search = React.createClass
  getInitialState: ->
    if window.searchKeyWord?
      keyword = window.searchKeyWord
      selectedKey = window.selectedKey
    else
      keyword = ''
      selectedKey = 0
    types: ['书名', '作者', '出版社', '简介']
    bookType: ['', '文学', '小说', '传记', '少儿', '经济管理', '教育', '生活', '人文社科', '科技', '期刊', '英文原版']
    typesCount: ['', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    typesSQL: ['bookname', 'author', 'pubHouse', 'introduce']
    selectedKey: selectedKey
    keyword: keyword
    btnDisable: true
    searchResoults: ''
    allData: ''
    inventory: ''
    title: ''
    body: ''
    old: ''
    bookid: ''
    showModal: false
    noRes: false
    searchBtn:
        <Button onClick={@handleSearchClick} disabled={@btnDisable}>
          <FontAwesome name='search' />
        </Button>
  componentWillMount: ->
    if @state.keyword.length > 0
      {keyword, selectedKey, typesSQL} = @state
      type = typesSQL[selectedKey]
      sendRequest [0], ["select * from BlackBooks.books where #{type} like '%#{keyword}%';"], @searchDone
    else
      sendRequest [0], ["select * from BlackBooks.books;"], @searchDone
  handleSelect: (selectedKey) ->
    if selectedKey.target.text isnt @state.types[@state.selectedKey]
      for type, index in @state.types
        if selectedKey.target.text is type
          @setState
            selectedKey: index
  handleKeywordChange: ->
    btnDisable = true
    keyword = @refs.keyword.getValue()
    if keyword.length > 0
      btnDisable = false
    @setState
      btnDisable: btnDisable
      keyword: keyword
  handleInventoryChange: (e) ->
    bookid = parseInt e.target.parentNode.parentNode.parentNode.parentNode.parentNode.childNodes[0].childNodes[0].childNodes[0].childNodes[0].innerText
    changeBtnDisable = true
    inventory = @refs.inventory.getValue()
    if inventory.length > 0
      changeBtnDisable = false
    @setState
      changeBtnDisable: changeBtnDisable
      inventory: inventory
      bookid: bookid
  handleSearchClick: ->
    {keyword, selectedKey, typesSQL} = @state
    type = typesSQL[selectedKey]
    sendRequest [0], ["select * from BlackBooks.books where #{type} like '%#{keyword}%';"], @searchDone
  searchDone: (res) ->
    if !res[0]?[0]?.booktype?
      @setState
        noRes: true
        searchResoults: []
    else
      typesCount = ['', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      for book in res[0]
        typesCount[book.booktype] += 1
      @setState
        searchResoults: res[0]
        allData: res[0]
        typesCount: typesCount
        noRes: false
  close: ->
    @setState
      showModal: false
  handleListGroupClick: (selectedKey) ->
    {noRes, allData} = @state
    res = []
    for book in allData
      if book.booktype is selectedKey
        res.push book
    if res.length <= 0
      noRes: true
    @setState
      searchResoults: res
      noRes: noRes
  render: ->
    <Grid className='continer-center' style={marginTop: 50}>
      <SimpleModal title={@state.title} body={@state.body} showModal={@state.showModal} close={@close}/>
      <Row>
        <Col md={3} mdOffset={2} style={display: 'flex', flexDirection: 'row', justifyContent: 'space-around', padding: '0 37px'}>
          <h5 style={marginTop: '.3em'}>查找方式</h5>
          <DropdownButton title={@state.types[@state.selectedKey]} id='SearchType'>
          {
            for type, index in @state.types
              <MenuItem eventKey={index} key={index} onSelect={@handleSelect}>{type} </MenuItem>
          }
          </DropdownButton>
        </Col>
        <Col md={4}>
          <Input type='text' hasFeedback placeholder='关键字' ref='keyword' value={@state.keyword}
                 buttonAfter={@state.searchBtn} onChange={@handleKeywordChange} />
        </Col>
      </Row>
      <hr />
      <Row>
        <Col md={3}>
          <ListGroup>
            {
              for type, index in @state.bookType
                continue if type is ''
                <ListGroupItem key={index} onClick={@handleListGroupClick.bind(@, index)}>
                  {type} ( {@state.typesCount[index]} )
                </ListGroupItem>
            }
          </ListGroup>
        </Col>
        <Col md={9}>
        {
          if @state.searchResoults.length > 0
            for book, index in @state.searchResoults
              <Col md={5} style={margin: 20, height: 400} key={index}>
                <BookBlock book={book} />
              </Col>
          else if @state.noRes
            <h5 style={position: 'absolute', left: '40%', top: '7000%'}>没有结果</h5>
        }
        </Col>
      </Row>
    </Grid>


module.exports = Search
