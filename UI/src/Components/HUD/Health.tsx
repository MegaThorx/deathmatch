import React from 'react';
import './Health.css';

type HealthProps = {
  health: number,
  maxHealth: number
}

class Health extends React.Component<HealthProps> {
  render() {
    const healthPrecentage = Math.floor((this.props.health / this.props.maxHealth) * 100);

    return (
      <div className={'Health' + ((healthPrecentage < 20) ? ' Health-low' : '')}>
        	<div className="Health-bar" style={{width: healthPrecentage + '%'}}></div>
        	<span className="Health-text">{this.props.health}</span>
      </div>
    );
  }
}

export default Health;
