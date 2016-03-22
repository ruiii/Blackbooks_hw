{ React, ReactBootstrap, FontAwesome, async, FETCHING_DATA, GOT_DATA } = window
{ Panel, Thumbnail, Button, Grid, Row, Col, Input, Button, DropdownButton, MenuItem, OverlayTrigger, Tooltip } = ReactBootstrap
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
    #window.loadURL '#/bookdetail'
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
          <h5>去看看</h5>
        </Button>
      </p>
    </Thumbnail>
#<Link to='bookdetail' params={{bookid: @props.book.bookid}}><h5>去看看</h5></Link>
Homepage = React.createClass
  getInitialState: ->
    types: ['书名', '作者', '出版社', '简介']
    selectedKey: 0
    keyword: ''
    btnDisable: true
    status: FETCHING_DATA
    searchBtn:
        <Button onClick={@handleSearchClick} disabled={@btnDisable}>
          <FontAwesome name='search' />
        </Button>
  componentDidMount: ->
    sendRequest [0], ['select * from blackbooks.books where blackbooks.books.bookid = 1 or blackbooks.books.bookid = 2 or blackbooks.books.bookid = 3;'], @done
  done: (res) ->
    @setState
      books: res[0]
      status: GOT_DATA
  handleSearchClick: ->
    {keyword, types, selectedKey} = @state
    async.waterfall([
      ((callback) ->
        window.searchKeyWord = keyword
        window.selectedKey = selectedKey
        callback(null, null)
      ),((res, callback) ->
        window.loadURL 'search'
        callback(null, null))],((err) ->
          console.log err))
  handleKeywordChange: ->
    btnDisable = true
    keyword = @refs.keyword.getValue()
    if keyword.length > 0
      btnDisable = false
    @setState
      btnDisable: btnDisable
      keyword: keyword
  handleSelect: (selectedKey) ->
    if selectedKey.target.text isnt @state.types[@state.selectedKey]
      for type, index in @state.types
        if selectedKey.target.text is type
          @setState
            selectedKey: index
  render: ->
    if @state.status is FETCHING_DATA
      <div style={height: 1100, width: 768}>
        <span className='fa fa-spinner fa-pulse' style={fontSize: 40, position: 'absolute', top: '45%', left: '50%'}></span>
      </div>
    else
      <div className='continer-center'>
        <Panel className='homepage-panel'>
          <h1>Books are to mankind what memory is to the individuanl.</h1>
          <p>书之于人类，犹如记忆于之个人</p>
          <Grid>
            <Row>
              <Col md={3} mdOffset={2} style={display: 'flex', flexDirection: 'row', justifyContent: 'space-around', padding: '0 37px'}>
                <h5 style={marginTop: '.3em'}>查找方式</h5>
                <DropdownButton title={@state.types[@state.selectedKey]} id='SearchType'>
                {
                  for type, index in @state.types
                    <MenuItem eventKey={index} key={index} onSelect={@handleSelect}>{type}</MenuItem>
                }
                </DropdownButton>
              </Col>
              <Col md={4}>
                <Input type='text' hasFeedback placeholder='关键字' ref='keyword'
                       buttonAfter={@state.searchBtn} onChange={@handleKeywordChange} />
              </Col>
            </Row>
          </Grid>
        </Panel>

        <hr className='header-center'/>

        <div className='homepage-title-continer'>
          <FontAwesome className='homepage-cup' name='trophy' />
          <span className='homepage-title'>BOOKS</span>
        </div>

        <Grid className='homepage-books-continer'>
        {
          for book, index in @state.books
            <Col md={4} key={index}>
              <BookBlock book={book} />
            </Col>
        }
        </Grid>
      </div>

module.exports = Homepage
