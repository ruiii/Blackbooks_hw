{ React, ReactBootstrap, FontAwesome } = window

Footer = React.createClass
  render: ->
    <div className='footer'>
      <div>
        <a href='https://github.com/ruiii'><FontAwesome name='github' style={fontSize: 27, color: 'white'} /></a>
        <p>Code licensed under MIT.</p>
      </div>
    </div>

module.exports = Footer
