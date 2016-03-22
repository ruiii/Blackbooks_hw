{ React, ReactBootstrap } = window
{ form, Grid, Row, Col, Input, Button, Alert } = ReactBootstrap
$ = require '../components/jquery.min.js'
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
ShowSpan = React.createClass
  render: ->
    <div style={display: 'flex', padding: 15, flexDirection: 'row'}>
      <h5>{@props.title}</h5>
      <h6>{@props.content}</h6>
    </div>

PutOn = React.createClass
  getInitialState: ->
    resoults: ''
    ID: ''
    type: ''
    bookName: ''
    author: ''
    pubHouse: ''
    price: ''
    total: ''
    introduce: ''
    pic: ''
    picBase64: ''
    formShow: true
    showAlert: false
  done: (res) ->
    @setState
      resoults: res
  handleIDChange: ->
    ID = @refs.ID.getValue()
    @setState {ID}
  handleTypeChange: ->
    type = @refs.type.getValue()
    @setState {type}
  handleBookNameChange: ->
    bookName = @refs.bookName.getValue()
    @setState {bookName}
  handleAuthorChange: ->
    author = @refs.author.getValue()
    @setState {author}
  handlePubHouseChange: ->
    pubHouse = @refs.pubHouse.getValue()
    @setState {pubHouse}
  handlePriceChange: ->
    price = @refs.price.getValue()
    @setState {price}
  handleTotalChange: ->
    total = @refs.total.getValue()
    @setState {total}
  handleIntroduceChange: ->
    introduce = @refs.introduce.getValue()
    @setState {introduce}

  handlePreClick: ->
    inputs = [@state.ID, @state.type, @state.bookName, @state.author, @state.pubHouse, @state.price, @state.total, @state.introduce]
    allPass = true
    for input in inputs
      if input is '' or input.length <= 0
        allPass = false
    if allPass
      @setState
        formShow: false
        showAlert: false
    else
      @setState
        showAlert: true
  handleAddClick: ->
    sendRequest [0], ["insert into BlackBooks.books (bookid, bookname, author, pubhouse, booktype, unitprice, total, inventory, introduce) values(null,#{@state.bookName},#{@state.author},#{@state.pubHouse},#{@state.type},#{@state.price},#{@state.total},#{@state.total},#{@state.introduce});"],@done
  handleBackClick: ->
    @setState
      formShow: true
  change: (e) ->
    console.log 'change', e
    #@setState
    #  picBase64: e.target.currentUrl
    @readURL e

  readURL: (input) ->
    if input.files && input.files[0]
      reader = new FileReader()
      reader.onload = (e) ->
        console.log(e.target.result)
        $('#put-on-img').attr('src', e.target.result)
      reader.readAsDataURL(input.files[0])

  render: ->
    <form>
      <Alert bsStyle='danger' className={if @state.showAlert then 'form-show' else 'form-hidden'} style={margin: 15}>
        信息输入不完整。
      </Alert>
      <Grid className={if @state.formShow then 'form-show' else 'form-hidden'}>
        <Row>
          <Col md={4}>
            <Input type='text' label='ID' placeholder='ID'
                   value={@state.ID} hasFeedback ref='ID'
                   onChange={@handleIDChange} />
          </Col>
          <Col md={4}>
            <Input type='text' label='类型' placeholder='类型'
                   value={@state.type} hasFeedback ref='type'
                   onChange={@handleTypeChange} />
          </Col>
          <Col md={4}>
            <Input type='text' label='作者' placeholder='作者'
                   value={@state.author} hasFeedback ref='author'
                   onChange={@handleAuthorChange} />
          </Col>
        </Row>
        <Row>
          <Col md={6}>
            <Input type='text' label='书名' placeholder='书名'
                   value={@state.bookName} hasFeedback ref='bookName'
                   onChange={@handleBookNameChange} />
          </Col>
          <Col md={6}>
            <Input type='text' label='出版社' placeholder='出版社'
                   value={@state.pubHouse} hasFeedback ref='pubHouse'
                   onChange={@handlePubHouseChange} />
          </Col>
        </Row>
        <Row>
          <Col md={6}>
            <Row style={padding: '0px 15px'}>
              <Input type='text' label='价格' placeholder='价格'
                     value={@state.price} hasFeedback ref='price'
                     onChange={@handlePriceChange} />
              <Input type='text' label='总量' placeholder='总量'
                     value={@state.total} hasFeedback ref='total'
                     onChange={@handleTotalChange} />
            </Row>
            <Row style={padding: '0px 15px'}>
              <Input type='textarea' label='介绍' placeholder='介绍'
                     value={@state.introduce} hasFeedback ref='introduce'
                     style={height: 200}
                     onChange={@handleIntroduceChange} />
            </Row>
          </Col>
          <Col md={6}>
            <Row>
              <input id='put-on-input' type='file' label='图片' accept='.jpg' onChange={@change}/>
            </Row>
            <Row>
              <img style={width: '100%'} id='put-on-img' src='#' alt='图片' />
            </Row>
          </Col>
        </Row>
        <Row>
          <Col md={4} mdOffset={4}>
            <Button onClick={@handlePreClick} block>
              预览
            </Button>
          </Col>
        </Row>
      </Grid>
      <Grid className={if @state.formShow then 'form-hidden' else 'form-show'}>
        <Row>
          <Col md={4} mdOffset={4}>
            <Button onClick={@handleBackClick} block>
              返回
            </Button>
        </Col>
        </Row>
        <Row>
          <Col md={4}>
            <ShowSpan title='ID' content={@state.ID}/>
          </Col>
          <Col md={4}>
            <ShowSpan title='类型' content={@state.type}/>
          </Col>
          <Col md={4}>
            <ShowSpan title='作者' content={@state.author}/>
          </Col>
        </Row>
        <Row>
          <Col md={6}>
            <ShowSpan title='书名' content={@state.bookName}/>
          </Col>
          <Col md={6}>
            <ShowSpan title='出版社' content={@state.pubHouse}/>
          </Col>
        </Row>
        <Row>
          <Col md={6}>
            <Row style={padding: '0px 15px'}>
              <ShowSpan title='价格' content={@state.price}/>
              <ShowSpan title='总量' content={@state.total}/>
            </Row>
            <Row style={padding: '0px 15px'}>
              <ShowSpan title='介绍' content={@state.introduce}/>
            </Row>
          </Col>
          <Col md={6}>
            <img style={width: '100%'} src={@state.picBase64} alt='图片' />
          </Col>
        </Row>
        <Row>
          <Col md={4} mdOffset={4}>
            <Button onClick={@handleAddClick} block>
              添加
            </Button>
          </Col>
        </Row>
      </Grid>
    </form>

module.exports = PutOn
