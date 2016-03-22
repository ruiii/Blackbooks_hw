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
    @props.close()
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
        </Modal.Footer>
    </Modal>
module.exports = SimpleModal
