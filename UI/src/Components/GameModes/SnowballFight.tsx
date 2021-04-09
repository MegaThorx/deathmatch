import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import React, { FC } from 'react';
import { useSelector } from 'react-redux';
import { RootState } from '../../Stores/store';
import { faHeart } from '@fortawesome/free-solid-svg-icons'
import './SnowballFight.css';

const SnowballFight: FC = () => {
	const state = useSelector((state: RootState) => state.SnowballFight);

	let hearts: any = [];

	for (let index = 0; index < state.heart.heartCount; index++) {
		hearts.push(<FontAwesomeIcon key={index} icon={faHeart} className={'heart ' + ((index + 1 <= state.heart.heart) ? 'active' : '')} />);
	}

    return (
		<div className="SnowballFight">
			{hearts}
		</div>
	);
};

export default SnowballFight;
