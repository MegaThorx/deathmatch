import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import React, { FC, ReactNode } from 'react';
import { useSelector } from 'react-redux';
import { RootState } from '../../Stores/store';
import { faHeart } from '@fortawesome/free-solid-svg-icons'
import './SnowballFightScore.css';
import { SnowballFightScoreEntry } from '../../Stores/GameModes/SnowballFightScore/types';

const SnowballFightScore: FC = () => {
	const state = useSelector((state: RootState) => state.SnowballFightScore);

	let scores: SnowballFightScoreEntry[] = JSON.parse(JSON.stringify(state.players));

	scores.sort((a, b) => {
		if (a.heart === b.heart) {
			if (a.lastUpdate === b.lastUpdate) {
				return 0;
			}
			return a.lastUpdate > b.lastUpdate ? 1 : -1;
		} else {
			return a.heart < b.heart ? 1 : -1;
		}
	});

    return (
		<div className="SnowballFightScore">
			{scores.map((element, i) => {
				if (i < 5) {
					let hearts: ReactNode[] = [];

					for (let index = 0; index < element.heartCount; index++) {
						hearts.push(<FontAwesomeIcon key={index} icon={faHeart} className={'heart ' + ((index + 1 <= element.heart) ? 'active' : '')} />);
					}

					return <p key={i}>{i + 1}. <span className="hearts">{hearts}</span> {element.name}</p>;
				}

				return null;
			})}
		</div>
	);
};

export default SnowballFightScore;
