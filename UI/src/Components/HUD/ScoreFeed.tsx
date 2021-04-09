import { faSkull } from '@fortawesome/free-solid-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import React from 'react';
import { HUDScoreFeed } from '../../Stores/HUD/types';
import './ScoreFeed.css';

interface ScoreFeedProps {
	scoreFeed: HUDScoreFeed
}

export class ScoreFeed extends React.Component<ScoreFeedProps> {
  render() {
	let killCount: any = [];

	for (let index = 0; index < this.props.scoreFeed.skulls.length; index++) {
		killCount.push(<FontAwesomeIcon key={index} icon={faSkull} className={'skull ' + ((this.props.scoreFeed.skulls[index].headshot) ? 'headshot' : '')} />);
	}

    return (
      <div className="ScoreFeed">
		  {this.props.scoreFeed.visible ? <div className="ScoreFeed-inner">
			<div className="ScoreFeed-KillCount">
				{killCount}
			</div>
			<div className="ScoreFeed-LastKill">
				{this.props.scoreFeed.lastKill !== '' ? (this.props.scoreFeed.lastKill + ' +' + this.props.scoreFeed.lastKillScore) : null}
			</div>
			<div className="ScoreFeed-TotalScore">
				{this.props.scoreFeed.totalScore}
			</div>
			<div className="ScoreFeed-Feed">
				{this.props.scoreFeed.entries.map((entry, i) => {
					return <p key={i}>{entry.text} +{entry.value}</p>;
				})}
			</div>
		  </div> : null}
      </div>
    );
  }
}

export default ScoreFeed;
