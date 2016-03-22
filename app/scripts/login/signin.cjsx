{ React, ReactBootstrap, Link, async } = window
{ Button, Input, Grid, Row, Col, Panel } = ReactBootstrap
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

SignIn = React.createClass
  getInitialState: ->
    title: ''
    body: ''
    showModal: false
    resoults: ''
    lUsername: ''
    lPassword: ''
  handleLUChange: ->
    lUsername = @refs.lUsername.getValue()
    @setState {lUsername}
  handleLPChange: ->
    lPassword = @refs.lPassword.getValue()
    @setState {lPassword}
  close: ->
    @setState
      showModal: false
  done: (res) ->
    {title, body, showModal} = @state
    if res.res is 1
      window.loginSuccess(@state.lUsername, @state.lPassword, res.level)
      window.loadURL '/'
    else if res.res is 0
      title = '错误'
      body = '密码错误'
      showModal = true
    else if res.res is -1
      title = '错误'
      body = '用户名不存在'
      showModal = true

    @setState
      title: title
      body: body
      showModal: showModal
  componentDidMount: ->
    window.socket.on 'signin_return', @done

  handleLOClick: ->
    if @state.lUsername.length < 1
      title = '错误'
      body = '用户名不能为空'
      showModal = true
    else if @state.lPassword.length < 1
      title = '错误'
      body = '密码不能为空'
      showModal = true
    else
      window.socket.emit 'signin' , {username: @state.lUsername, password: @state.lPassword}
    #sendRequest [0], ['select * from BlackBooks.users;'], @done

  render: ->
    minHeight = window.$('body').clientHeight - 66 - 170
    <Grid style={marginTop: 30, minHeight: minHeight}>
      <SimpleModal title={@state.title} body={@state.body} showModal={@state.showModal} close={@close}/>
      <Col md={7}>
      </Col>
      <Col md={4}>
        <Panel style={padding: 17, margin: 27, paddingBottom: 37, marginTop: '30%'}>
          <Row style={textAlign: 'center'}>
            <h4 className='admin-title'>登陆</h4>
            <hr style={width: '92%', marginTop: 37} />
          </Row>
          <Row>
            <Col md={10} mdOffset={1}>
              <Input  type='text' label='用户名' placeholder='用户名'
                      value={@state.lUsername} hasFeedback ref='lUsername'
                      onChange={@handleLUChange} />
            </Col>
          </Row>
          <Row>
            <Col md={10} mdOffset={1}>
              <Input  type='password' label='密码' placeholder='密码'
                      value={@state.lPassword} hasFeedback ref='lPassword'
                      onChange={@handleLPChange} />
            </Col>
          </Row>
          <Row>
            <Col md={6} mdOffset={3}>
              <Button onClick={@handleLOClick} block>
                登陆
              </Button>
            </Col>
          </Row>
        </Panel>
      </Col>
    </Grid>

module.exports = SignIn
