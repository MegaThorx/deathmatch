import React from 'react';
import './Ammunation.css';

type AmmunationProps = {
  clip: number,
  bag: number
}


class Ammunation extends React.Component<AmmunationProps> {
  render() {
    return (
      <div className="Ammunation">
        <div className="Ammunation-content">
        	<span className="Ammunation-clip">{this.props.clip}</span>
        	<span className="Ammunation-clipDelimiter">/</span>
        	<span className="Ammunation-bag">{this.props.bag}</span>
        </div>
      </div>
    );
  }
}

export default Ammunation;
