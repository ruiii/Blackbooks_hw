{ React, ReactBootstrap } = window
{ Button, Modal } = ReactBootstrap


SimpleModal = React.createClass
  getInitialState: ->
    showModal: false
  componentWillReceiveProps: (nextProps) ->
    if nextProps.showModal isnt @state.showModal
      @setState
        showModal: nextProps.showModal
  close: ->
    @props.getRes 0
    @setState
      showModal: false
  ok: ->
    @props.getRes 1
    @setState
      showModal: false
  render: ->
    <Modal style={position: 'absolute', top: '25%'} show={@state.showModal} onHide={@close}>
        <Modal.Header closeButton>
          <Modal.Title>{@props.title}</Modal.Title>
        </Modal.Header>

        <Modal.Body>
          {@props.body}
        </Modal.Body>

        <Modal.Footer>
          <Button onClick={@close}>关闭</Button>
          <Button onClick={@ok} bsStyle='primary'>确定</Button>
        </Modal.Footer>
    </Modal>
module.exports = SimpleModal
