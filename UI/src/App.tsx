import React, { FC } from 'react';
import HUD from './Components/HUD';
import Scoreboard from './Components/Scoreboard';
import './App.css';
import { useSelector } from 'react-redux';
import { RootState } from './Stores/store';

interface AppProps {
}


const App: FC<AppProps> = () => {
	const state = useSelector((state: RootState) => state.App);
	
	let classes = 'App';

	if (navigator.userAgent.indexOf('Ultralight') === -1) {
		classes += ' App-debug';
	}

	return (
		<div className={classes}>
			<Scoreboard />
			{state.blurred ? <div className="App-blurred"></div> : null}
			<div className="App-inner">
			<HUD />
			</div>
		</div>
	);
}

export default App;
