import React, { FC } from 'react';
import Health from './HUD/Health';
import { KillFeed } from './HUD/KillFeed';
import Ammunation from './HUD/Ammunation';
import './HUD.css';
import { RootState } from '../Stores/store';
import { useSelector } from 'react-redux';
import Debug from './Debug';
import HUDEvents from './HUD/HUDEvents';
import GameModes from './GameModes';
import GameModeEvents from './GameModes/GameModeEvents';
import SnowballFight from './GameModes/SnowballFight';
import Countdown from './HUD/Countdown';
import ScoreFeed from './HUD/ScoreFeed';

interface HUDProps {
}

const HUD: FC<HUDProps> = () => {
	const state = useSelector((state: RootState) => state.HUD);
	const gameState = useSelector((state: RootState) => state.GameMode);

    return (
		<div className="HUD">
			<HUDEvents />
			<GameModeEvents />
			<div className="HUD-inner">
				<div className="HUD-row">
					<div className="HUD-col">
						{!state.countdown.enabled ? <KillFeed entries={state.killFeed} /> : null}
					</div>
					<div className="HUD-col">
						{state.countdown.enabled ? <Countdown value={state.countdown.value} /> : null}
					</div>
					<div className="HUD-col">
						<Debug />
					</div>
				</div>
				<div className="HUD-row">
					<div className="HUD-col"></div>
					<div className="HUD-col"></div>
					<div className="HUD-col"></div>
				</div>
				<div className="HUD-row">
					<div className="HUD-col">
						{!state.countdown.enabled ? <div className="HUD-GameMode">
							<div className="HUD-GameMode-container">
								 <GameModes />
							</div>
						</div> : null}
					</div>
					<div className="HUD-col">
						{!state.countdown.enabled ? <ScoreFeed scoreFeed={state.scoreFeed} /> : null}
					</div>
					<div className="HUD-col">
						{!state.countdown.enabled ? <div className="HUD-HealthAmmunation">
							<div className="HUD-HealthAmmunation-inner">
								<div className="HUD-HealthAmmunation-container">
									{gameState.gameMode === 'snowball_fight' ? <SnowballFight /> : null}
									<Health health={state.health.health} maxHealth={state.health.maxHealth} />
									{state.weapon.ammunationEnabled ? <Ammunation clip={state.weapon.clip} bag={state.weapon.bag} /> : ''}
								</div>
							</div>
						</div> : null}
					</div>
				</div>
			</div>
		</div>
	  );
};

export default HUD;
