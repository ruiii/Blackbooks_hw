{ React, ReactBootstrap, FETCHING_DATA, GOT_DATA } = window
{ Grid, Col, Row, Input, Button, Accordion, Panel, DropdownButton, MenuItem } = ReactBootstrap
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

PullOff = React.createClass
  getInitialState: ->
    btnDisable: true
    bookChecked: []
    books: ''
    status: FETCHING_DATA
    types: ['书名', '作者', '出版社', '简介'] # ['文学', '小说', '传记', '少儿', '经济管理', '教育', '生活', '人文社科', '科技', '期刊', '英文原版']
    typesSQL: ['bookname', 'author', 'pubHouse', 'introduce']
    selectedKey: 0
    keyword: ''
    btnDisable: true
    searchResoults: ''
    bookid: ''
    title: ''
    body: ''
    showModal: false
    searchBtn:
        <Button onClick={@handleSearchClick} disabled={@btnDisable}>
          <FontAwesome name='search' />
        </Button>
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
  handleSearchClick: ->
    {keyword, selectedKey, typesSQL} = @state
    type = typesSQL[selectedKey]
    sendRequest [0], ["select * from BlackBooks.books where #{type} like '%#{keyword}%';"], @searchDone
  searchDone: (res) ->
    if res[0].changedRows is 1
      @handleSearchClick
      @setState
        title: '成功'
        body: '图书下架成功。'
        showModal: true
        status: FETCHING_DATA
    else
      @setState
        searchResoults: res[0]
        status: GOT_DATA
  handleDelClick: (e) ->
    bookid = parseInt e.target.parentNode.parentNode.parentNode.parentNode.childNodes[0].childNodes[0].childNodes[0].childNodes[0].innerText
    sendRequest [0], ["delete from BlackBooks.books where bookid=#{bookid};"], @searchDone
  close: ->
    @setState
      showModal: false
  render: ->
      <Grid>
        <SimpleModal title={@state.title} body={@state.body} showModal={@state.showModal} close={@close} />
        <Row>
          <Col md={4} mdOffset={2} style={display: 'flex', flexDirection: 'row', justifyContent: 'space-around', padding: '0 37px'}>
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
        <Row>
          {
            if @state.status is FETCHING_DATA
              <FontAwesome name='pulse' />
            else
              <Accordion>
                  {
                    for book, index in @state.searchResoults
                      header =
                        <Row>
                          <Col md={1}>
                            {book.bookid}
                          </Col>
                          <Col md={6}>
                            {book.bookname}
                          </Col>
                        </Row>
                      <Panel style={margin: 15} key={index} header={header} eventKey={index} key={index}>
                        <Col md={3}>
                          作者： {book.author}
                        </Col>
                        <Col md={3}>
                          出版社： {book.pubhouse}
                        </Col>
                        <Col md={2}>
                          库存： {book.inventory}
                        </Col>
                        <Col md={2}>
                          <Button onClick={@handleDelClick} block>
                            下架图书
                          </Button>
                        </Col>
                      </Panel>
                  }
              </Accordion>
          }
        </Row>
      </Grid>

module.exports = PullOff
