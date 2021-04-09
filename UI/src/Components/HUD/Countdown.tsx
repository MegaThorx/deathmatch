import React from 'react';
import './Countdown.css';

type CountdownProps = {
  value: number
}


class Countdown extends React.Component<CountdownProps> {
  render() {
    return (
      <div className="Countdown">
	  	{this.props.value < 10 ? '0' + this.props.value : this.props.value}
      </div>
    );
  }
}

export default Countdown;
