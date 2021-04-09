import React from 'react';
import { HUDKillFeedEntry } from '../../Stores/HUD/types';
import './KillFeed.css';

interface KillFeedProps {
  entries: HUDKillFeedEntry[]
}

export class KillFeed extends React.Component<KillFeedProps> {
  render() {
    return (
      <div className="KillFeed">
        {this.props.entries.map((entry, i) => {
          return <p key={i}>{entry.text}</p>;
        })}
      </div>
    );
  }
}

export default KillFeed;
