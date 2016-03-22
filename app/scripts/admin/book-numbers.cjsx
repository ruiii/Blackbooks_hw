{ React, ReactBootstrap, FontAwesome, async } = window
{ Grid, Row, Col, Input, DropdownButton, MenuItem, Button, Accordion, Panel } = ReactBootstrap
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

BookNumbers = React.createClass
  getInitialState: ->
    types: ['书名', '作者', '出版社', '简介'] # ['文学', '小说', '传记', '少儿', '经济管理', '教育', '生活', '人文社科', '科技', '期刊', '英文原版']
    typesSQL: ['bookname', 'author', 'pubHouse', 'introduce']
    selectedKey: 0
    keyword: ''
    btnDisable: true
    changeBtnDisable: true
    searchResoults: ''
    inventory: ''
    title: ''
    body: ''
    old: ''
    bookid: ''
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
  handleInventoryChange: (e) ->
    console.log e
    old = parseInt e.target.parentNode.parentNode.parentNode.childNodes[2].childNodes[1].innerText
    bookid = parseInt e.target.parentNode.parentNode.parentNode.parentNode.parentNode.childNodes[0].childNodes[0].childNodes[0].childNodes[0].innerText
    changeBtnDisable = true
    inventory = @refs.inventory.getValue()
    if inventory.length > 0
      changeBtnDisable = false
    @setState
      changeBtnDisable: changeBtnDisable
      inventory: inventory
      old: old
      bookid: bookid
  handleSearchClick: ->
    {keyword, selectedKey, typesSQL} = @state
    type = typesSQL[selectedKey]
    sendRequest [0], ["select * from BlackBooks.books where #{type} like '%#{keyword}%';"], @searchDone
  searchDone: (res) ->
    if res[0].changedRows is 1
      @setState
        title: '成功'
        body: '库存修改成功。'
        showModal: true
      @handleSearchClick
    else
      @setState
        searchResoults: res[0]
  handleChangeClick: ->
    {inventory, old, bookid} = @state
    if parseInt(inventory) is parseInt(old)
      @setState
        title: '错误'
        body: '库存数量与原来一致。'
        showModal: true
    else
      sendRequest [0], ["update BlackBooks.books set inventory=#{inventory} where bookid=#{bookid};"], @searchDone
  close: ->
    @setState
      showModal: false
  render: ->
    <Grid>
      <SimpleModal title={@state.title} body={@state.body} showModal={@state.showModal} close={@close} />
      <Row style={padding: '27px 15px'}>
        <h3 className='admin-title'>　图书数量管理</h3>
        <hr />
      </Row>
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
      <Row>
        <Accordion>
        {
          if @state.searchResoults.length > 0
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
              <Panel key={index} header={header} eventKey={index} key={index}>
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
                  <Input type='text' hasFeedback placeholder='库存' ref='inventory' onChange={@handleInventoryChange} />
                </Col>
                <Col md={2}>
                  <Button onClick={@handleChangeClick} disabled={@state.changeBtnDisable} block>
                    修改
                  </Button>
                </Col>
              </Panel>
        }
        </Accordion>
      </Row>
    </Grid>


module.exports = BookNumbers
