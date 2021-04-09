import { HUDReducer } from "./HUD/reducers";
import { combineReducers, configureStore } from '@reduxjs/toolkit'
import { useDispatch } from "react-redux";
import { DeathmatchReducer } from "./GameModes/Deathmatch/reducers";
import { TeamDeathmatchReducer } from "./GameModes/TeamDeathmatch/reducers";
import { GameModeReducer } from "./GameModes/reducers";
import { SnowballFightReducer } from "./GameModes/SnowballFight/reducers";
import { SnowballFightScoreReducer } from "./GameModes/SnowballFightScore/reducers";
import { ScoreboardReducer } from "./Scoreboard/reducers";
import { AppReducer } from "./App/reducers";

const rootReducer = combineReducers({
	App: AppReducer,
	HUD: HUDReducer,
	Scoreboard: ScoreboardReducer,
	GameMode: GameModeReducer,
	Deathmatch: DeathmatchReducer,
	TeamDeathmatch: TeamDeathmatchReducer,
	SnowballFight: SnowballFightReducer,
	SnowballFightScore: SnowballFightScoreReducer
});

export const RootStore = configureStore({
	reducer: rootReducer
});

export type RootState = ReturnType<typeof RootStore.getState>
export type AppDispatch = typeof RootStore.dispatch
export const useAppDispatch = () => useDispatch<AppDispatch>()
