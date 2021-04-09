import React, { FC } from 'react';
import { useSelector } from 'react-redux';
import { AppSetBlurred } from '../Stores/App/actions';
import { gameModeUpdate } from '../Stores/GameModes/actions';
import { snowballFightScoreUpdate } from '../Stores/GameModes/SnowballFightScore/actions';
import { HUDAddFeedEntryScoreFeed, HUDAddKillFeedEntry, HUDAddKillScoreFeed, HUDUpdateCountdown, HUDUpdateHealth, HUDUpdateWeapon } from '../Stores/HUD/actions';
import { ScoreboardSetPlayers, ScoreboardSetTeams, ScoreboardSetVisible, ScoreboardUpdateConfig } from '../Stores/Scoreboard/actions';
import { RootState, useAppDispatch } from '../Stores/store';


interface DebugProps {
}

const Debug: FC<DebugProps> = () => {
	const dispatch = useAppDispatch();
	const state = useSelector((state: RootState) => state);

    return (
		<div className="Debug">
			{navigator.userAgent.indexOf('Ultralight') !== -1 ? null : <>
				<button onClick={() => {dispatch(HUDUpdateHealth(Math.round(Math.random() * 100), 100))}}>Random health</button>
				<br />
				<button onClick={() => {dispatch(HUDUpdateWeapon(true, Math.round(Math.random() * 100), Math.round(Math.random() * 100)))}}>Random ammunation</button>
				<button onClick={() => {dispatch(HUDUpdateWeapon(false, 0, 0))}}>Disable ammunation</button>
				<br />
				<button onClick={() => {dispatch(HUDAddKillFeedEntry('Hello World', new Date().getTime()))}}>Add kill feed entry</button>
				<br />
				<button onClick={() => {dispatch(gameModeUpdate("deathmatch"))}}>Set gamemode deathmatch</button>
				<button onClick={() => {dispatch(gameModeUpdate("team_deathmatch"))}}>Set gamemode team deathmatch</button>
				<button onClick={() => {dispatch(gameModeUpdate("snowball_fight"))}}>Set gamemode snowball fight</button>
				<br />
				<button onClick={() => {dispatch(snowballFightScoreUpdate([{name: "Syed", heart: Math.round(Math.random() * 3), heartCount: 3, lastUpdate: Math.round(Math.random() * 10000)}, {name: "MegaThorx", heart: Math.round(Math.random() * 3), heartCount: 3, lastUpdate: Math.round(Math.random() * 10000)}, {name: "Malte", heart: Math.round(Math.random() * 3), heartCount: 3, lastUpdate: Math.round(Math.random() * 10000)}, {name: "Mjami", heart: Math.round(Math.random() * 3), heartCount: 3, lastUpdate: Math.round(Math.random() * 10000)}, {name: "meow", heart: Math.round(Math.random() * 3), heartCount: 3, lastUpdate: Math.round(Math.random() * 10000)}, {name: "EinfachMax", heart: Math.round(Math.random() * 3), heartCount: 3, lastUpdate: Math.round(Math.random() * 10000)}]))}}>Snowball fight add score</button>
				<br />
				<button onClick={() => {dispatch(HUDUpdateCountdown(true, Math.round(Math.random() * 15)))}}>Update countdown</button>
				<button onClick={() => {dispatch(HUDUpdateCountdown(false, Math.round(Math.random() * 15)))}}>Disable countdown</button>
				<br />
				<button onClick={() => {dispatch(HUDAddKillScoreFeed({lastKill: 'Gabriel ' + Math.round(Math.random() * 100), lastKillScore: 25, headshot: (Math.random() * 100) > 50}))}}>Add score feed kill</button>
				<button onClick={() => {dispatch(HUDAddFeedEntryScoreFeed({text: 'Enemy hit', value: Math.round(Math.random() * 200), stackAble: true}))}}>Add score feed damage</button>
				<button onClick={() => {dispatch(HUDAddFeedEntryScoreFeed({text: 'Headshot', value: 25, stackAble: false}))}}>Add score feed headshot</button>
				<br />
				<br />
				<button onClick={() => {dispatch(ScoreboardSetVisible(!state.Scoreboard.visible)); dispatch(AppSetBlurred(!state.Scoreboard.visible))}}>Toggle visibility</button>
				<br />
				<button onClick={() => {dispatch(ScoreboardUpdateConfig({splitTeam: false, sortBy: 'Deaths', sortDirection: 'DESC', teams: [], columns: [{name: 'Kills', value: 'Kills'}, {name: 'Deaths', value: 'Deaths'}, {name: 'Score', value: 'Score'}]}))}}>Set config</button>
				<button onClick={() => {dispatch(ScoreboardUpdateConfig({splitTeam: true, sortBy: 'Score', sortDirection: 'DESC', teams: [{id: 1, name: 'Blue', color: '#0000FF', scoreIndex: '', showMaxPlayers: false}, {id: 2, name: 'Red', color: '#FF0000', scoreIndex: '', showMaxPlayers: false}], columns: [{name: 'Kills', value: 'Kills'}, {name: 'Deaths', value: 'Deaths'}, {name: 'Score', value: 'Score'}]}))}}>Set config 2</button>
				<button onClick={() => {dispatch(ScoreboardUpdateConfig({splitTeam: true, sortBy: 'Score', sortDirection: 'DESC', teams: [{id: 1, name: 'Blue', color: '#0000FF', scoreIndex: 'score', showMaxPlayers: false}, {id: 2, name: 'Red', color: '#FF0000', scoreIndex: 'score', showMaxPlayers: false}], columns: [{name: 'K', value: 'Kills'}, {name: 'D', value: 'Deaths'}, {name: 'Score', value: 'Score'}]}))}}>Set config 3</button>
				<button onClick={() => {dispatch(ScoreboardUpdateConfig({splitTeam: false, sortBy: '', sortDirection: 'DESC', teams: [], columns: []}))}}>Clear config</button>
				<br />
				<button onClick={() => {dispatch(ScoreboardSetPlayers([{name: 'MegaThorx', team: 0, ping: 0, data: {'Kills': '7', 'Deaths': '3', 'Score': '784'}}]))}}>Set players (1)</button>
				<button onClick={() => {dispatch(ScoreboardSetPlayers([{name: 'Gabriel', team: 1, ping: 0, data: {'Kills': '3', 'Deaths': '7', 'Score': '454'}}, {name: 'MegaThorx', team: 2, ping: 0, data: {'Kills': '7', 'Deaths': '3', 'Score': '784'}}]))}}>Set players (2)</button>
				<button onClick={() => {dispatch(ScoreboardSetPlayers([]))}}>Clear players</button>
				<br />
				<button onClick={() => {dispatch(ScoreboardSetTeams([{id: 1, maxPlayers: 0, data: {'score': '7'}}, {id: 2, maxPlayers: 0, data: {'score': '3'}}]))}}>Set teams</button>
				<button onClick={() => {dispatch(ScoreboardSetTeams([]))}}>Clear teams</button>
			</>}
		</div>
	);
};

export default Debug;
